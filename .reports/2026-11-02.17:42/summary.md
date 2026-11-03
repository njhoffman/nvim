# Nvim Config Report - 2026-11-02.17:42 (v0.23.1)

Keymaps follow Alacritty's lowercase Alt keys: save-and-quit and command-line save move from `<M-S>` to `<M-s>`, and
workspace diagnostics (LSP buffers) and Telescope's launch-pickers key from `<M-T>` to `<M-t>`. tmux now passes Alt+i,
Alt+t and Alt+o through to Neovim, so the existing `<M-i>` and `<M-o>` mappings also work inside tmux. Tests and
coverage are unchanged; the lsp keymaps spec checks `<M-t>`. The run used the plugin updates in the uncommitted
`lazy-lock.json` (not part of this release; one plugin fewer installed). Benchmark warnings on every timing metric
(startup ready +124% vs baseline, file opens and renders +27% to +164%) most likely come from load: the load average
was 36 shortly before the run and 4.68 when the benchmarks were recorded (baseline 0.95); this release changes only
key mappings.

| Metric                    | Value                                                  | Delta vs v0.23.0 |
| ------------------------- | ------------------------------------------------------ | ---------------- |
| Unit test files           | 41 Lua + 1 Python + 1 bats                             | 0                |
| Tests passing             | 477/477 (434 plenary, 17 mini.test, 19 Python, 7 bats) | 0                |
| Line coverage (lua/)      | 51.16%                                                 | 0.00             |
| Lua code lines (cloc)     | 140,979 in 1,296 files                                 | 0                |
| Markdown code lines       | 5,249                                                  | +6               |
| Total code lines          | 172,413 in 1,574 files                                 | +5               |
| Installed plugins (lazy/) | 376                                                    | -1               |

## Benchmarks

Latest: 2026-11-03T00:02Z, release 0.23.1 (ed6068ee-dirty), load 4.68, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 2381 ms | 1215 | 10 | +96% | 1062 | +124% |
| startup settled | 8320 ms | 6625 | 10 | +26% | 6460 | +29% |
| small.md open | 216 ms | 151 | 10 | +43% | 176 | +23% |
| small.md render | 405 ms | 275 | 10 | +47% | 294 | +37% |
| medium.md open | 371 ms | 181 | 10 | +105% | 159 | +133% |
| medium.md render | 708 ms | 358 | 10 | +98% | 313 | +126% |
| large.md open | 381 ms | 167 | 10 | +128% | 160 | +137% |
| large.md render | 837 ms | 338 | 10 | +148% | 317 | +164% |
| code.md open | 294 ms | 152 | 10 | +94% | 173 | +69% |
| code.md render | 543 ms | 345 | 10 | +57% | 353 | +54% |
| sample.lua open | 215 ms | 124 | 10 | +73% | 139 | +55% |
| sample.lua render | 425 ms | 335 | 10 | +27% | 360 | +18% |
| sample.py open | 190 ms | 147 | 10 | +29% | 124 | +53% |
| sample.py render | 379 ms | 377 | 10 | +1% | 344 | +10% |
| sample.ts open | 130 ms | 109 | 10 | +20% | 116 | +12% |
| sample.ts render | 331 ms | 333 | 10 | -1% | 347 | -5% |
| sample.json open | 122 ms | 142 | 10 | -14% | 131 | -7% |
| sample.json render | 324 ms | 338 | 10 | -4% | 347 | -7% |
| rss settled | 125 MiB | 119 | 10 | +4% | 120 | +4% |
| rss peak | 193 MiB | 193 | 10 | -0% | 194 | -0% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,574 | 1,574 | +0 |
| config lua lines | 140,979 | 140,979 | +0 |
| config lines | 172,413 | 172,408 | +5 |
| plugin lines | 2,245,426 | 2,222,516 | +22,910 |

Over 25% slower: startup ready: +96% vs average; startup ready: +124% vs baseline; startup settled: +26% vs average; startup settled: +29% vs baseline; small.md open: +43% vs average; small.md render: +47% vs average; small.md render: +37% vs baseline; medium.md open: +105% vs average; medium.md open: +133% vs baseline; medium.md render: +98% vs average; medium.md render: +126% vs baseline; large.md open: +128% vs average; large.md open: +137% vs baseline; large.md render: +148% vs average; large.md render: +164% vs baseline; code.md open: +94% vs average; code.md open: +69% vs baseline; code.md render: +57% vs average; code.md render: +54% vs baseline; sample.lua open: +73% vs average; sample.lua open: +55% vs baseline; sample.lua render: +27% vs average; sample.py open: +29% vs average; sample.py open: +53% vs baseline.
