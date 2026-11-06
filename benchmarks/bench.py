"""Benchmark library: drive Neovim through an attached UI, record history, render the tables.

A session starts `nvim --embed` with the full config, attaches a 100x40 UI over msgpack-RPC and
timestamps every `flush` (a finished screen update). Without an attached UI Neovim skips the
redraw, so treesitter highlighting and render-markdown decorations would never be paid for;
this is why headless --startuptime is not used.

Per session:
  startup ready    spawn -> first flush after UIEnter (the screen is usable)
  startup settled  spawn -> last flush once Neovim is idle (deferred setup done)
  <fixture> open   :edit request -> its response (read, filetype, treesitter attach)
  <fixture> render :edit request -> Neovim idle: the final screen is drawn and the main loop
                   is free (time it stays blocked after :edit returns counts)
Each filetype is opened once on a tiny warm-up file first, so lazy-loaded plugins are not
charged to the first measured fixture. CursorHold is ignored (idle popups are not rendering) and language servers never start.
"""

import csv
import datetime
import hashlib
import json
import os
from pathlib import Path
import select
import shutil
import statistics
import subprocess
import tempfile
import threading
import time

import msgpack

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
FIXTURES = HERE / "fixtures"
HISTORY = HERE / "history.tsv"
PERFORMANCE = ROOT / "docs" / "PERFORMANCE.md"
LAZY_DIR = Path.home() / ".local" / "share" / "nvim" / "lazy"
CLOC_CACHE = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache")) / "nvim-report"

COLUMNS, LINES = 100, 40
STARTUP_QUIET_MS, RENDER_QUIET_MS = 1000, 300
PING_SLACK_MS = 50  # a ping answered slower than this means the main loop was busy
STARTUP_CAP_S, RENDER_CAP_S = 20, 10
AVERAGE_WINDOW = 10
# A push records times only from a quiet machine: 1-minute load per CPU at the start, and at most
# during the run. The run itself adds well under 1 to the load.
START_LOAD_PER_CPU, PEAK_LOAD_PER_CPU = 0.4, 0.6

WARMUPS = ["warmup.md", "warmup.lua", "warmup.py", "warmup.ts", "warmup.json"]
SAMPLES = ["small.md", "medium.md", "large.md", "code.md", "sample.lua", "sample.py", "sample.ts", "sample.json"]

# Metric names in table order. Counts are recorded once per release, not averaged.
TIMINGS = ["startup ready", "startup settled"] + [
  f"{name} {phase}" for name in SAMPLES for phase in ("open", "render")
]
MEMORY = ["rss settled", "rss peak"]
COUNTS = ["plugins installed", "plugins loaded", "config files", "config lua lines", "config lines", "plugin lines"]
SIZES = ["config size", "plugin size"]

FIELDS = ["date", "kind", "version", "commit", "load1", "nvim", "metric", "unit", "median", "min", "runs"]
START, END = "<!-- benchmark:start -->", "<!-- benchmark:end -->"

# Strip what would make a run differ from a plain `nvim` in a terminal outside tmux.
DROP_ENV = ("TMUX", "TMUX_PANE", "NVIM", "NVIM_UNIQUE", "NVIM_LISTEN_ADDRESS", "NVIM_STARTUPTIME", "VIMINIT", "MYVIMRC")
# Per-buffer language servers are stubbed out: their startup is asynchronous, depends on the
# project and animates progress spinners, none of which is rendering. Copilot is let through
# (it never attaches to a buffer, and refusing it only produces error notifications).
HOOK = (
  "lua vim.o.eventignore = 'CursorHold,CursorHoldI'; "
  "local lsp_start = vim.lsp.start; "
  "vim.lsp.start = function(config, opts) "
  "if type(config) == 'table' and config.name == 'copilot' then return lsp_start(config, opts) end end; "
  "vim.api.nvim_create_autocmd('UIEnter', { once = true, callback = function() "
  "vim.rpcnotify(0, 'bench', 'uienter') end })"
)


class BenchError(Exception):
  pass


def nvim_binary():
  """The real executable on PATH (shell functions and aliases are not seen by which)."""
  found = shutil.which(os.environ.get("BENCH_NVIM", "nvim"))
  if not found:
    raise BenchError("nvim not found on PATH")
  return found


def load1():
  return float(Path("/proc/loadavg").read_text().split()[0])


def wait_for_load(limit, max_wait, interval=15, log=print):
  deadline = time.monotonic() + max_wait
  while (current := load1()) > limit:
    if time.monotonic() >= deadline:
      return False
    log(f"load {current:.2f} > {limit:.2f}; waiting {interval}s")
    time.sleep(interval)
  return True


class LoadWatch:
  """Tracks the highest 1-minute load while the block runs: the gate before a run misses a spike."""

  def __init__(self, interval=5):
    self.interval = interval
    self.peak = 0.0
    self._done = threading.Event()

  def _watch(self):
    while True:
      self.peak = max(self.peak, load1())
      if self._done.wait(self.interval):
        return

  def __enter__(self):
    self._thread = threading.Thread(target=self._watch, daemon=True)
    self._thread.start()
    return self

  def __exit__(self, *_):
    self._done.set()
    self._thread.join()
    self.peak = max(self.peak, load1())


def rss_mib(pid, field):
  for line in Path(f"/proc/{pid}/status").read_text().splitlines():
    if line.startswith(field + ":"):
      return int(line.split()[1]) / 1024
  return 0.0


class Session:
  """One embedded Neovim with an attached UI. Times are ms since spawn."""

  def __init__(self, state_dir):
    environment = {k: v for k, v in os.environ.items() if k not in DROP_ENV}
    environment.update(XDG_STATE_HOME=f"{state_dir}/state", XDG_CACHE_HOME=f"{state_dir}/cache")
    command = [nvim_binary(), "--embed", "-i", "NONE", "--cmd", HOOK]
    self.t0 = time.perf_counter()
    self.process = subprocess.Popen(
      command, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL,
      env=environment, cwd=state_dir,  # a neutral cwd: no project roots, exrc or projector.json
    )
    self.unpacker = msgpack.Unpacker(raw=False)
    self.flushes = []
    self.uienter = None
    self.responses = {}
    self.next_id = 1
    self.request("nvim_ui_attach", COLUMNS, LINES, {"ext_linegrid": True, "rgb": True}, wait=False)

  def now(self):
    return (time.perf_counter() - self.t0) * 1000

  def _send(self, message):
    self.process.stdin.write(msgpack.packb(message))
    self.process.stdin.flush()

  def _pump(self, timeout_s):
    """Read and dispatch whatever arrives within timeout_s. False when Neovim exited."""
    ready, _, _ = select.select([self.process.stdout], [], [], max(timeout_s, 0))
    if not ready:
      return True
    data = os.read(self.process.stdout.fileno(), 1 << 20)
    if not data:
      return False
    stamp = self.now()
    self.unpacker.feed(data)
    for message in self.unpacker:
      if message[0] == 1:  # response: [1, id, error, result]
        self.responses[message[1]] = (message[2], message[3], stamp)
      elif message[0] == 2 and message[1] == "redraw":
        if any(event[0] == "flush" for event in message[2]):
          self.flushes.append(stamp)
      elif message[0] == 2 and message[1] == "bench" and self.uienter is None:
        self.uienter = stamp
      elif message[0] == 0:  # a request from Neovim; answer it so Neovim never blocks on us
        self._send([1, message[1], "not supported", None])
    return True

  def request(self, method, *args, wait=True, timeout_s=RENDER_CAP_S):
    msgid = self.next_id
    self.next_id += 1
    self._send([0, msgid, method, list(args)])
    if not wait:
      return None
    deadline = time.perf_counter() + timeout_s
    while msgid not in self.responses:
      if time.perf_counter() > deadline or not self._pump(0.05):
        raise BenchError(f"{method}: no response (a prompt may be blocking Neovim)")
    error, result, stamp = self.responses.pop(msgid)
    if error:
      raise BenchError(f"{method}: {error}")
    return result, stamp

  def wait_uienter(self):
    deadline = time.perf_counter() + STARTUP_CAP_S
    while self.uienter is None:
      if time.perf_counter() > deadline or not self._pump(0.05):
        raise BenchError("UIEnter never fired (a prompt may be blocking startup)")
    return self.uienter

  def wait_quiet(self, quiet_ms, cap_s, since):
    """Last flush after `since`, once no flush has arrived for quiet_ms (or the cap is hit)."""
    deadline = time.perf_counter() + cap_s
    while time.perf_counter() < deadline:
      last = self.flushes[-1] if self.flushes and self.flushes[-1] >= since else since
      remaining = quiet_ms - (self.now() - last)
      if remaining <= 0:
        return last
      if not self._pump(remaining / 1000):
        raise BenchError("Neovim exited while rendering")
    raise BenchError(f"the screen never settled within {cap_s}s")

  def settle(self, quiet_ms, cap_s, since):
    """When Neovim is done after `since`: the later of its last flush and the end of the last
    stretch the main loop was blocked. Pings detect blocking: scheduled work that blocks the main
    loop (a synchronous full treesitter parse, say) often draws nothing, so screen quiet alone
    would report the editor ready while it is frozen. Done = a ping answered promptly with no
    new flush since, after quiet_ms without a flush."""
    deadline = time.perf_counter() + cap_s
    busy_until = since

    def remaining():
      left = deadline - time.perf_counter()
      if left <= 0:
        raise BenchError(f"Neovim never went idle within {cap_s}s")
      return left

    while True:
      before = len(self.flushes)
      sent = self.now()
      _, answered = self.request("nvim_eval", "0", timeout_s=remaining())
      if answered - sent >= PING_SLACK_MS:
        busy_until = answered
        continue
      last = self.flushes[-1] if self.flushes and self.flushes[-1] >= since else since
      if len(self.flushes) == before and self.now() - last >= quiet_ms:
        return max(last, busy_until)
      self.wait_quiet(quiet_ms, remaining(), since)

  def first_flush_after(self, since):
    while True:
      for stamp in self.flushes:
        if stamp >= since:
          return stamp
      if not self._pump(1):
        raise BenchError("Neovim exited before the first redraw")

  def open(self, path):
    """Wipe all buffers, let the screen settle, then time :edit. Returns (open_ms, render_ms)."""
    self.request("nvim_command", "silent! %bwipeout!")
    self.settle(200, RENDER_CAP_S, self.now())
    start = self.now()
    _, responded = self.request("nvim_command", f"edit {path}")
    settled = self.settle(RENDER_QUIET_MS, RENDER_CAP_S, start)
    return responded - start, max(settled, responded) - start

  def lua(self, code):
    return self.request("nvim_exec_lua", code, [])[0]

  def close(self):
    try:
      self.request("nvim_command", "qa!", wait=False)
      self.process.wait(timeout=5)
    except Exception:
      self.process.kill()
      self.process.wait()


def stage_fixtures(state_dir):
  """Copy the fixtures out of this repo, so project.nvim finds no root and never chdirs."""
  target = Path(state_dir) / "fixtures"
  if not target.exists():
    shutil.copytree(FIXTURES, target)
  return target


def run_session(state_dir, samples=SAMPLES):
  """One measured session: startup, warm-up opens, then each sample. Returns {metric: value}."""
  fixtures = stage_fixtures(state_dir)
  session = Session(state_dir)
  try:
    uienter = session.wait_uienter()
    result = {"startup ready": session.first_flush_after(uienter)}
    result["startup settled"] = session.settle(STARTUP_QUIET_MS, STARTUP_CAP_S, uienter)
    result["rss settled"] = rss_mib(session.process.pid, "VmRSS")
    stats = session.lua("local s = require('lazy').stats() return { count = s.count, loaded = s.loaded }")
    result["plugins installed"], result["plugins loaded"] = stats["count"], stats["loaded"]
    for name in WARMUPS:
      session.open(fixtures / name)
    for name in samples:
      result[f"{name} open"], result[f"{name} render"] = session.open(fixtures / name)
    result["rss peak"] = rss_mib(session.process.pid, "VmHWM")
    return result
  finally:
    session.close()


def measure(runs, samples=SAMPLES, log=print):
  """One unrecorded warm-up session, then `runs` measured ones; medians and minimums per metric."""
  with tempfile.TemporaryDirectory(prefix="nvim-bench-") as state_dir:
    log("warm-up session")
    run_session(state_dir, samples)
    collected = {}
    for index in range(runs):
      log(f"session {index + 1}/{runs}")
      for metric, value in run_session(state_dir, samples).items():
        collected.setdefault(metric, []).append(value)
  return {metric: (statistics.median(values), min(values)) for metric, values in collected.items()}


def plugin_counts(log=print):
  """Plugin counts from one started session, for a run that measures no times. {} if it fails."""
  with tempfile.TemporaryDirectory(prefix="nvim-bench-") as state_dir:
    session = None
    try:
      session = Session(state_dir)
      uienter = session.wait_uienter()
      session.settle(STARTUP_QUIET_MS, STARTUP_CAP_S * 3, uienter)
      stats = session.lua("local s = require('lazy').stats() return { count = s.count, loaded = s.loaded }")
    except BenchError as error:
      log(f"no plugin counts: {error}")
      return {}
    finally:
      if session:
        session.close()
  return {"plugins installed": (stats["count"],) * 2, "plugins loaded": (stats["loaded"],) * 2}


def measure_release(runs, log=print, cpus=os.cpu_count() or 1):
  """What a push records. Times from a busy machine would only skew the trend, so a high load at
  the start or during the run, or a failed run, leaves them out; the counts are still recorded."""
  start_limit, peak_limit = START_LOAD_PER_CPU * cpus, PEAK_LOAD_PER_CPU * cpus
  if (current := load1()) > start_limit:
    log(f"load {current:.2f} > {start_limit:.2f}: too busy, recording no times")
    return plugin_counts(log)
  try:
    with LoadWatch() as watch:
      measured = measure(runs, log=log)
  except BenchError as error:
    log(f"failed: {error}; recording no times")
    return plugin_counts(log)
  if watch.peak > peak_limit:
    log(f"load peaked at {watch.peak:.2f} > {peak_limit:.2f} during the run: recording no times")
    return {metric: value for metric, value in measured.items() if metric not in TIMINGS}
  return measured


def code_counts(cloc_main, cloc_lazy):
  """File and line counts from cloc JSON reports."""
  main = json.loads(Path(cloc_main).read_text())
  lazy = json.loads(Path(cloc_lazy).read_text())
  return {
    "config files": main["SUM"]["nFiles"],
    "config lua lines": main.get("Lua", {}).get("code", 0),
    "config lines": main["SUM"]["code"],
    "plugin lines": lazy["SUM"]["code"],
  }


def run_cloc(report, *arguments):
  # Relative paths on purpose: an absolute path under ~/.config yields {}
  subprocess.run(["cloc", "--json", f"--report-file={report}", *arguments], cwd=ROOT, check=True,
                 stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def collect_code_counts(log=print):
  """Run cloc over the config and the plugin tree. The tree only changes with plugin updates, so its
  result is cached by lazy-lock.json and the plugin directories. {} if cloc fails."""
  key_source = (ROOT / "lazy-lock.json").read_bytes() + "\n".join(sorted(os.listdir(LAZY_DIR))).encode()
  cached = CLOC_CACHE / f"lazy-{hashlib.sha256(key_source).hexdigest()[:16]}.json"
  with tempfile.TemporaryDirectory(prefix="nvim-cloc-") as directory:
    main = Path(directory) / "main.json"
    try:
      run_cloc(main, "--follow-links", "--exclude-dir=.reports,.git,node_modules,__pycache__",
               "--fullpath", "--not-match-d=.*benchmarks/fixtures.*", ".")
      if not cached.is_file() or cached.stat().st_size == 0:
        CLOC_CACHE.mkdir(parents=True, exist_ok=True)
        # No --follow-links here: plugin test fixtures contain symlink loops
        partial = Path(directory) / "lazy.json"
        run_cloc(partial, str(LAZY_DIR))
        shutil.move(partial, cached)
    except (OSError, subprocess.CalledProcessError) as error:
      log(f"no code counts: {error}")
      return {}
    return code_counts(main, cached)


def config_size_mib():
  """Tracked files of the config, without the old report summaries."""
  paths = git("ls-files", "-z", "--", ".", ":!.reports").split("\0")
  # A tracked file can be deleted in the work tree; lstat so a symlink counts as itself
  return sum((ROOT / path).lstat().st_size for path in paths if path and os.path.lexists(ROOT / path)) / (1 << 20)


def plugin_size_mib(path=LAZY_DIR):
  """Disk use of the plugin tree, .git directories included."""
  output = subprocess.run(["du", "-sk", str(path)], capture_output=True, text=True, check=True).stdout
  return int(output.split()[0]) / 1024


def git(*arguments):
  return subprocess.run(["git", "-C", str(ROOT), *arguments], capture_output=True, text=True).stdout.rstrip("\n")


def metadata(kind, version):
  dirty = "-dirty" if git("status", "--porcelain", "--untracked-files=no") else ""
  nvim = subprocess.run([nvim_binary(), "--version"], capture_output=True, text=True).stdout.splitlines()[0]
  return {
    "date": datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%dT%H:%MZ"),
    "kind": kind,
    "version": version,
    "commit": git("rev-parse", "--short", "HEAD") + dirty,
    "load1": f"{load1():.2f}",
    "nvim": nvim,
  }


def unit_of(metric):
  if metric in COUNTS:
    return "count"
  if metric in MEMORY or metric in SIZES:
    return "MiB"
  return "ms"


def to_rows(meta, measured, counts, runs):
  rows = []
  for metric in TIMINGS + MEMORY + COUNTS + SIZES:
    if metric in measured:
      median, minimum = measured[metric]
    elif metric in counts:
      median = minimum = counts[metric]
    else:
      continue
    rows.append({**meta, "metric": metric, "unit": unit_of(metric),
                 "median": f"{median:.1f}" if unit_of(metric) != "count" else str(int(median)),
                 "min": f"{minimum:.1f}" if unit_of(metric) != "count" else str(int(minimum)),
                 "runs": str(runs if metric in measured and metric not in COUNTS else 1)})
  return rows


def read_history(path=HISTORY):
  if not Path(path).exists():
    return []
  with open(path, newline="") as handle:
    return list(csv.DictReader(handle, delimiter="\t"))


def write_history(rows, path=HISTORY):
  with open(path, "w", newline="") as handle:
    writer = csv.DictWriter(handle, FIELDS, delimiter="\t", lineterminator="\n")
    writer.writeheader()
    writer.writerows(rows)


def record(history, new_rows):
  """Append new_rows, replacing the same metrics of the same release: a re-run that was too busy to
  measure times keeps the times already recorded."""
  kind, version = new_rows[0]["kind"], new_rows[0]["version"]
  if kind == "release":
    metrics = {row["metric"] for row in new_rows}
    history = [row for row in history
               if not (row["kind"] == "release" and row["version"] == version and row["metric"] in metrics)]
  return history + new_rows


def releases_before(history, version):
  """Release versions in recorded order, excluding `version` and anything after it."""
  order = []
  for row in history:
    if row["kind"] == "release" and row["version"] not in order:
      order.append(row["version"])
  if version in order:
    order = order[: order.index(version)]
  return order


def best_run(row):
  """The fastest session of a row: unlike the median, it stays stable while the machine is busy."""
  return float(row.get("min") or row["median"])


def summarize(history, current_rows, window=AVERAGE_WINDOW):
  """Per metric: latest, the average over the previous `window` releases, and the latest baseline.
  The `best` fields hold the best runs that warnings compare."""
  version = current_rows[0]["version"]
  previous = releases_before(history, version)[-window:]
  baseline_rows = [row for row in history if row["kind"] == "baseline"]
  baseline_date = baseline_rows[-1]["date"] if baseline_rows else None
  baseline = {row["metric"]: float(row["median"]) for row in baseline_rows if row["date"] == baseline_date}
  last_release = previous[-1] if previous else None
  summary = []
  for row in current_rows:
    metric = row["metric"]
    values = [float(r["median"]) for r in history
              if r["kind"] == "release" and r["version"] in previous and r["metric"] == metric]
    prior = [float(r["median"]) for r in history
             if r["kind"] == "release" and r["version"] == last_release and r["metric"] == metric]
    # The newest earlier release that has this metric: a push on a busy machine records no times.
    releases = {r["version"]: r for r in history
                if r["kind"] == "release" and r["version"] in previous and r["metric"] == metric}
    ordered = [version for version in previous if version in releases]
    older = [best_run(releases[version]) for version in ordered[:-1]]
    summary.append({
      "metric": metric,
      "unit": row["unit"],
      "latest": float(row["median"]),
      "average": statistics.mean(values) if values else None,
      "averaged": len(values),
      "baseline": baseline.get(metric),
      "previous": prior[0] if prior else None,
      "best": best_run(row),
      "prior_best": best_run(releases[ordered[-1]]) if ordered else None,
      "average_best": statistics.mean(older) if older else None,
    })
  # Describe the baseline by its measured rows: count metrics (plugins, lines) record 1 run
  latest_baseline = [row for row in baseline_rows if row["date"] == baseline_date]
  baseline_meta = max(latest_baseline, key=lambda row: int(row["runs"])) if latest_baseline else None
  return summary, baseline_date, baseline_meta


def table_for(history, rows, runs):
  """Tables for `rows` against the history recorded before them."""
  if rows[0]["kind"] == "baseline":
    history = [row for row in history if row["date"] != rows[0]["date"] or row["kind"] != "baseline"]
  summary, baseline_date, baseline_meta = summarize(history, rows)
  meta = {key: rows[0][key] for key in ("date", "kind", "version", "commit", "load1", "nvim")}
  return render_tables(summary, meta, baseline_date, baseline_meta, runs)


def percent(latest, reference):
  if reference in (None, 0):
    return ""
  return f"{(latest - reference) / reference * 100:+.0f}%"


def number(value, unit):
  if value is None:
    return ""
  return f"{int(value):,}" if unit == "count" else f"{value:.0f}"


def render_tables(summary, meta, baseline_date, baseline_meta, runs, warn_pct=25):
  timed = [s for s in summary if s["unit"] != "count" and s["metric"] not in SIZES]
  counted = [s for s in summary if s["unit"] == "count" or s["metric"] in SIZES]
  baseline_text = (
    f"baseline from {baseline_date} (load {baseline_meta['load1']}, {baseline_meta['runs']} sessions)"
    if baseline_date else "no baseline yet (run `benchmarks/run --baseline` under low load)"
  )
  lines = [
    f"Latest: {meta['date']}, {meta['kind']} {meta['version']} ({meta['commit']}), load {meta['load1']}, "
    f"{meta['nvim']}. Median of {runs} sessions after one warm-up session, {COLUMNS}x{LINES} UI. "
    f"Average is over the previous {AVERAGE_WINDOW} releases; {baseline_text}. "
    "Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see "
    "[benchmarks/README.md](../benchmarks/README.md).",
  ]
  if timed:
    lines += [
      "",
      "| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |",
      "|---|---:|---:|---:|---:|---:|---:|",
    ]
  warnings = []
  for s in timed:
    unit = " MiB" if s["unit"] == "MiB" else " ms"
    lines.append(
      f"| {s['metric']} | {number(s['latest'], s['unit'])}{unit} | {number(s['average'], s['unit'])} | "
      f"{s['averaged']} | {percent(s['latest'], s['average'])} | {number(s['baseline'], s['unit'])} | "
      f"{percent(s['latest'], s['baseline'])} |"
    )
    # One noisy release is normal, so the best run has to be slower twice against the same reference.
    # The baseline's median, not its best: that comes from 10 sessions and a release's from 3.
    for label, reference in (("average", s["average_best"]), ("baseline", s["baseline"])):
      if reference and s["prior_best"] is not None and all(
        (value - reference) / reference * 100 > warn_pct for value in (s["best"], s["prior_best"])
      ):
        warnings.append(f"{s['metric']}: best run {percent(s['best'], reference)} vs {label}, 2 releases in a row")
  lines += ["", "| Count | Latest | Previous release | Change |", "|---|---:|---:|---:|"]
  for s in counted:
    if s["unit"] == "count":
      shown = [number(s["latest"], "count"), number(s["previous"], "count")]
      change = "" if s["previous"] is None else f"{int(s['latest'] - s['previous']):+,}"
    else:
      shown = [f"{s['latest']:,.1f} MiB", "" if s["previous"] is None else f"{s['previous']:,.1f} MiB"]
      change = "" if s["previous"] is None else f"{s['latest'] - s['previous']:+,.1f}"
    lines.append(f"| {s['metric']} | {shown[0]} | {shown[1]} | {change} |")
  if warnings:
    lines += ["", f"Over {warn_pct}% slower: " + "; ".join(warnings) + "."]
  return "\n".join(lines), warnings


def trend_table(history):
  """One row per recorded push, newest first; blank where a run recorded no such metric."""
  by_version = {}
  for row in history:
    if row["kind"] == "release":
      by_version.setdefault(row["version"], []).append(row)

  def whole(values, metric):
    return f"{float(values[metric]):,.0f}" if metric in values else ""

  def mean(values, phase):
    samples = [float(values[f"{name} {phase}"]) for name in SAMPLES if f"{name} {phase}" in values]
    return f"{statistics.mean(samples):,.0f}" if samples else ""

  columns = [
    ("Version", None), ("Date", None), ("Load", None),
    ("Plugins", "plugins installed"), ("Loaded", "plugins loaded"), ("Files", "config files"),
    ("Lua lines", "config lua lines"), ("Lines", "config lines"), ("Plugin lines", "plugin lines"),
    ("Config MiB", "config size"), ("Plugins MiB", "plugin size"),
    ("Ready ms", "startup ready"), ("Settled ms", "startup settled"),
    ("Open ms", "open"), ("Render ms", "render"),
    ("RSS MiB", "rss settled"), ("Peak MiB", "rss peak"),
  ]
  lines = [
    "| " + " | ".join(name for name, _ in columns) + " |",
    "|---|---|" + "---:|" * (len(columns) - 2),
  ]
  for version, rows in reversed(by_version.items()):
    values = {row["metric"]: row["median"] for row in rows}
    timed = [row for row in rows if row["metric"] in TIMINGS]
    # The load only explains times, so it is the load of the run that measured them
    load = timed[-1]["load1"] if timed else ""
    cells = [version, rows[-1]["date"][:10], load]
    for _, metric in columns[3:]:
      cells.append(mean(values, metric) if metric in ("open", "render") else whole(values, metric))
    lines.append("| " + " | ".join(cells) + " |")
  return "\n".join(lines)


def update_performance_doc(table, path=PERFORMANCE):
  path = Path(path)
  block = f"{START}\n\n{table}\n\n{END}"
  if path.exists():
    text = path.read_text()
    if START in text and END in text:
      head, rest = text.split(START, 1)
      _, tail = rest.split(END, 1)
      path.write_text(head + block + tail)
      return
  else:
    text = (
      "# Performance\n\n"
      "Size and speed of this config after every push, recorded by `scripts/push.sh` through\n"
      "`benchmarks/run`. The table below is rewritten on each recorded run.\n"
    )
  path.write_text(text.rstrip("\n") + "\n\n## Benchmarks\n\n" + block + "\n")
