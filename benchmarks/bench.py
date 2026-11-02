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
import json
import os
from pathlib import Path
import select
import shutil
import statistics
import subprocess
import tempfile
import time

import msgpack

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
FIXTURES = HERE / "fixtures"
HISTORY = HERE / "history.tsv"
PERFORMANCE = ROOT / "docs" / "PERFORMANCE.md"

COLUMNS, LINES = 100, 40
STARTUP_QUIET_MS, RENDER_QUIET_MS = 1000, 300
PING_SLACK_MS = 50  # a ping answered slower than this means the main loop was busy
STARTUP_CAP_S, RENDER_CAP_S = 20, 10
AVERAGE_WINDOW = 10

WARMUPS = ["warmup.md", "warmup.lua", "warmup.py", "warmup.ts", "warmup.json"]
SAMPLES = ["small.md", "medium.md", "large.md", "code.md", "sample.lua", "sample.py", "sample.ts", "sample.json"]

# Metric names in table order. Counts are recorded once per release, not averaged.
TIMINGS = ["startup ready", "startup settled"] + [
  f"{name} {phase}" for name in SAMPLES for phase in ("open", "render")
]
MEMORY = ["rss settled", "rss peak"]
COUNTS = ["plugins installed", "plugins loaded", "config files", "config lua lines", "config lines", "plugin lines"]

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


def code_counts(cloc_main, cloc_lazy):
  """File and line counts from the cloc JSON that scripts/report.sh writes."""
  main = json.loads(Path(cloc_main).read_text())
  lazy = json.loads(Path(cloc_lazy).read_text())
  return {
    "config files": main["SUM"]["nFiles"],
    "config lua lines": main.get("Lua", {}).get("code", 0),
    "config lines": main["SUM"]["code"],
    "plugin lines": lazy["SUM"]["code"],
  }


def git(*arguments):
  return subprocess.run(["git", "-C", str(ROOT), *arguments], capture_output=True, text=True).stdout.strip()


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
  if metric in MEMORY:
    return "MiB"
  return "ms"


def to_rows(meta, measured, counts, runs):
  rows = []
  for metric in TIMINGS + MEMORY + COUNTS:
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
  """Append new_rows, replacing earlier rows of the same release (a re-run of report.sh)."""
  kind, version = new_rows[0]["kind"], new_rows[0]["version"]
  if kind == "release":
    history = [row for row in history if not (row["kind"] == "release" and row["version"] == version)]
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


def summarize(history, current_rows, window=AVERAGE_WINDOW):
  """Per metric: latest, the average over the previous `window` releases, and the latest baseline."""
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
    summary.append({
      "metric": metric,
      "unit": row["unit"],
      "latest": float(row["median"]),
      "average": statistics.mean(values) if values else None,
      "averaged": len(values),
      "baseline": baseline.get(metric),
      "previous": prior[0] if prior else None,
    })
  # Describe the baseline by its measured rows: count metrics (plugins, lines) record 1 run
  latest_baseline = [row for row in baseline_rows if row["date"] == baseline_date]
  baseline_meta = max(latest_baseline, key=lambda row: int(row["runs"])) if latest_baseline else None
  return summary, baseline_date, baseline_meta


def latest_release_rows(history):
  versions = [row["version"] for row in history if row["kind"] == "release"]
  if not versions:
    return []
  return [row for row in history if row["kind"] == "release" and row["version"] == versions[-1]]


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
  timed = [s for s in summary if s["unit"] != "count"]
  counted = [s for s in summary if s["unit"] == "count"]
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
    for label, reference in (("average", s["average"]), ("baseline", s["baseline"])):
      if reference and (s["latest"] - reference) / reference * 100 > warn_pct:
        warnings.append(f"{s['metric']}: {percent(s['latest'], reference)} vs {label}")
  lines += ["", "| Count | Latest | Previous release | Change |", "|---|---:|---:|---:|"]
  for s in counted:
    change = "" if s["previous"] is None else f"{int(s['latest'] - s['previous']):+,}"
    lines.append(f"| {s['metric']} | {number(s['latest'], 'count')} | {number(s['previous'], 'count')} | {change} |")
  if warnings:
    lines += ["", f"Over {warn_pct}% slower: " + "; ".join(warnings) + "."]
  return "\n".join(lines), warnings


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
      "Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`\n"
      "through `benchmarks/run`. The table below is rewritten on each recorded run.\n"
    )
  path.write_text(text.rstrip("\n") + "\n\n## Benchmarks\n\n" + block + "\n")
