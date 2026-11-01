# Nvim Config Report - 2026-11-01.12:32 (v0.16.1)

Tracks `lazy-lock.json` so each tag pins its plugin versions, reviews TODO.md, and removes four
Claude Code allow rules that caused startup warnings. No code changes; the benchmark differences
come from load (6.8 here, 22 for v0.16.0).

| Metric                    | Value                                          | Delta vs v0.16.0 |
| ------------------------- | ---------------------------------------------- | ---------------- |
| Unit test files           | 32 Lua + 1 Python                              | 0                |
| Tests passing             | 412/412 (377 plenary, 17 mini.test, 18 Python) | 0                |
| Line coverage (lua/)      | 50.25%                                         | 0.00             |
| Lua code lines (cloc)     | 184,511 in 1,761 files                         | 0                |
| Markdown code lines       | 5,243                                          | +51              |
| Total code lines          | 216,361 in 2,045 files                         | +51              |
| Installed plugins (lazy/) | 377                                            | 0                |

## Benchmarks

Latest: 2026-11-01T18:59Z, release 0.16.1 (575ee294-dirty), load 6.81, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 2002 ms | 3801 | 1 | -47% |  |  |
| startup settled | 8484 ms | 11367 | 1 | -25% |  |  |
| small.md open | 365 ms | 392 | 1 | -7% |  |  |
| small.md render | 766 ms | 678 | 1 | +13% |  |  |
| medium.md open | 394 ms | 424 | 1 | -7% |  |  |
| medium.md render | 1768 ms | 1999 | 1 | -12% |  |  |
| large.md open | 277 ms | 506 | 1 | -45% |  |  |
| large.md render | 5125 ms | 6978 | 1 | -27% |  |  |
| code.md open | 385 ms | 429 | 1 | -10% |  |  |
| code.md render | 4045 ms | 4291 | 1 | -6% |  |  |
| sample.lua open | 204 ms | 237 | 1 | -14% |  |  |
| sample.lua render | 569 ms | 545 | 1 | +4% |  |  |
| sample.py open | 161 ms | 357 | 1 | -55% |  |  |
| sample.py render | 370 ms | 753 | 1 | -51% |  |  |
| sample.ts open | 197 ms | 326 | 1 | -40% |  |  |
| sample.ts render | 497 ms | 596 | 1 | -17% |  |  |
| sample.json open | 270 ms | 252 | 1 | +7% |  |  |
| sample.json render | 494 ms | 536 | 1 | -8% |  |  |
| rss settled | 116 MiB | 124 | 1 | -6% |  |  |
| rss peak | 219 MiB | 219 | 1 | -0% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,045 | 2,044 | +1 |
| config lua lines | 184,511 | 184,511 | +0 |
| config lines | 216,361 | 216,310 | +51 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |
