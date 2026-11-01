# Nvim Config Report - 2026-11-01.14:25 (v0.17.0)

Adds `lua/tmux/pane_flag.lua` (loaded from `plugin/tmux_pane_flag.lua`): inside tmux, Neovim marks
its pane with `@pane-is-vim` while it holds the terminal, so tmux 0.19.0 can pass alt-hjkl and
ctrl-hjkl to Neovim with a format check instead of running `ps` on every keypress. No benchmark
warnings: load was 4.50 (v0.16.3 ran at 12.16), and every timing is below its average. The spec's 7
tests were already counted (untracked) in the v0.16.3 report, so test and code counts are unchanged.
The working tree held 5 modified files from other work (not part of this release) while the report ran.

| Metric                    | Value                                          | Delta vs v0.16.3 |
| ------------------------- | ---------------------------------------------- | ---------------- |
| Unit test files           | 35 Lua + 1 Python                              | 0                |
| Tests passing             | 430/430 (395 plenary, 17 mini.test, 18 Python) | 0                |
| Line coverage (lua/)      | 50.68%                                         | 0.00             |
| Lua code lines (cloc)     | 184,943 in 1,767 files                         | 0                |
| Markdown code lines       | 5,281                                          | +7               |
| Total code lines          | 216,827 in 2,051 files                         | +7               |
| Installed plugins (lazy/) | 377                                            | 0                |

## Benchmarks

Latest: 2026-11-01T20:43Z, release 0.17.0 (82c34988-dirty), load 4.50, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 2524 ms | 3429 | 4 | -26% |  |  |
| startup settled | 8467 ms | 10744 | 4 | -21% |  |  |
| small.md open | 230 ms | 390 | 4 | -41% |  |  |
| small.md render | 425 ms | 771 | 4 | -45% |  |  |
| medium.md open | 242 ms | 476 | 4 | -49% |  |  |
| medium.md render | 582 ms | 2165 | 4 | -73% |  |  |
| large.md open | 267 ms | 410 | 4 | -35% |  |  |
| large.md render | 599 ms | 7400 | 4 | -92% |  |  |
| code.md open | 262 ms | 501 | 4 | -48% |  |  |
| code.md render | 526 ms | 4825 | 4 | -89% |  |  |
| sample.lua open | 144 ms | 309 | 4 | -54% |  |  |
| sample.lua render | 372 ms | 714 | 4 | -48% |  |  |
| sample.py open | 151 ms | 369 | 4 | -59% |  |  |
| sample.py render | 450 ms | 745 | 4 | -40% |  |  |
| sample.ts open | 169 ms | 303 | 4 | -44% |  |  |
| sample.ts render | 362 ms | 630 | 4 | -43% |  |  |
| sample.json open | 244 ms | 315 | 4 | -23% |  |  |
| sample.json render | 454 ms | 590 | 4 | -23% |  |  |
| rss settled | 124 MiB | 120 | 4 | +3% |  |  |
| rss peak | 192 MiB | 219 | 4 | -12% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,051 | 2,051 | +0 |
| config lua lines | 184,943 | 184,943 | +0 |
| config lines | 216,827 | 216,820 | +7 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |
