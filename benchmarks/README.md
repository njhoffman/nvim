# Benchmarks

Size and startup and rendering times of this config, recorded with every push, so progress shows over time. The trend,
one row per push, is in [docs/PERFORMANCE.md](../docs/PERFORMANCE.md); every metric is in `history.tsv`.

```sh
benchmarks/run                       # measure and print the table; records nothing
benchmarks/run --release 0.16.0      # what scripts/push.sh runs: records release 0.16.0
benchmarks/run --baseline            # record a new baseline (see below)
benchmarks/generate.py               # regenerate the fixtures (deterministic)
```

## What is measured

Each session starts `nvim --embed` with the full config and attaches a 100x40 UI over msgpack-RPC, timing every `flush`
(a finished screen update). A real UI matters: headless Neovim never redraws, so treesitter highlighting and
render-markdown decorations would cost nothing.

| Metric             | From            | To                                                         |
| ------------------ | --------------- | ---------------------------------------------------------- |
| startup ready      | spawn           | first screen after `UIEnter`                               |
| startup settled    | spawn           | Neovim idle: deferred setup and startup animations done    |
| `<fixture>` open   | `:edit` request | its response (read, filetype, treesitter attach)           |
| `<fixture>` render | `:edit` request | Neovim idle with the final screen drawn                    |
| rss settled / peak |                 | resident memory once started / peak over the whole session |

"Idle" means the screen stayed quiet for 300 ms (1 s at startup) and a ping is answered within 50 ms. The ping matters:
work scheduled after `:edit` returns can block the main loop for seconds without drawing anything, which looks finished
on screen but is a frozen editor.

Fixtures (`fixtures/`, from `generate.py`): Markdown at 75, 491 and 1,271 lines plus a 1,173-line document with 40 code
fences, and about 600 lines each of Lua, Python and TypeScript, plus 2,082 lines of JSON. A tiny warm-up file per
filetype is opened first, so lazy-loaded plugins are not charged to the first measured fixture.

Counts (no averages): plugins installed and loaded at startup (`lazy.stats()`), and config files, Lua lines, all lines
and installed plugin lines from cloc. Sizes: `config size` is the tracked files of this repo, `plugin size` the disk use
of `~/.local/share/nvim/lazy`, `.git` directories included. Plugins loaded with `dir =` from elsewhere (11 of 386 today)
count as plugins but not in the plugin lines or size.

## Isolation

- The `nvim` executable on `PATH` (`BENCH_NVIM` overrides), not a shell wrapper or function.
- `-i NONE`, plus a temporary `XDG_STATE_HOME`/`XDG_CACHE_HOME` shared by the sessions of one run: sessions, shada and
  swap files stay untouched, and the warm-up session fills the Lua bytecode cache.
- `TMUX`, `NVIM_UNIQUE` and similar variables are removed; the working directory and the fixtures sit in the temporary
  directory, so no project root is detected.
- `CursorHold` is ignored (idle popups are not rendering) and per-buffer language servers are stubbed out (their startup
  is asynchronous and depends on the project). Copilot is let through, since it never attaches to a buffer.

## Runs, averages and the baseline

A release run records counts, sizes and memory on every push, and times only from a quiet machine. With a 1-minute load
over 0.4 x CPUs at the start it measures nothing and takes seconds; if the load goes over 0.6 x CPUs during the run it
drops the times, since the check at the start cannot see a later spike. Otherwise it runs one unrecorded warm-up session
and records the medians of 3 sessions. A rerun for the same version replaces only the metrics it measured, so a busy
rerun keeps the recorded times. An adhoc run waits up to 10 minutes for 0.6 x CPUs, then measures anyway.

The average covers the previous 10 releases, never the current one. Plugin and Neovim updates shift it over time; the
baseline does not. `benchmarks/run --baseline` waits up to 30 minutes for a load of 0.15 x CPUs (and records nothing if
it never gets there), then records the medians of 10 sessions. Rerun it by hand now and then, for example after a Neovim
upgrade. The table compares the latest release with the newest baseline.

A metric more than 25% slower than its average or baseline is listed under the table and printed as a warning; it does not block a push, since this desktop's load alone moves the numbers by about 20%.

## history.tsv

One row per metric per run: `date kind version commit load1 nvim metric unit median min runs`. `kind` is `release` or
`baseline`. `commit` is the HEAD the run measured (the parent of the release commit, with `-dirty` for the uncommitted
change being released).
