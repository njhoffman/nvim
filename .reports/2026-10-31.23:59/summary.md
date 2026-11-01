# Nvim Config Report - 2026-10-31.23:59 (v0.16.0)

Adds startup and rendering benchmarks recorded with every release (`benchmarks/run`), with
averages over the previous 10 releases and a low-load baseline. This is the first recorded
release, so there is no average yet, and no baseline has been taken (load was 22 during this run).

| Metric                    | Value                                     | Delta vs v0.15.1 |
| ------------------------- | ----------------------------------------- | ---------------- |
| Unit test files           | 32 Lua + 1 Python                         | +1               |
| Tests passing             | 412/412 (377 plenary, 17 mini.test, 18 Python) | +18         |
| Line coverage (lua/)      | 50.25%                                    | 0.00             |
| Lua code lines (cloc)     | 184,511 in 1,761 files                    | 0                |
| Markdown code lines       | 5,192                                     | +108             |
| Total code lines          | 216,310 in 2,044 files                    | +844             |
| Installed plugins (lazy/) | 377                                       | 0                |

## Benchmarks

Latest: 2026-11-01T05:27Z, release 0.16.0 (cd13877d-dirty), load 22.31, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 3801 ms |  | 0 |  |  |  |
| startup settled | 11367 ms |  | 0 |  |  |  |
| small.md open | 392 ms |  | 0 |  |  |  |
| small.md render | 678 ms |  | 0 |  |  |  |
| medium.md open | 424 ms |  | 0 |  |  |  |
| medium.md render | 1999 ms |  | 0 |  |  |  |
| large.md open | 506 ms |  | 0 |  |  |  |
| large.md render | 6978 ms |  | 0 |  |  |  |
| code.md open | 429 ms |  | 0 |  |  |  |
| code.md render | 4291 ms |  | 0 |  |  |  |
| sample.lua open | 237 ms |  | 0 |  |  |  |
| sample.lua render | 545 ms |  | 0 |  |  |  |
| sample.py open | 357 ms |  | 0 |  |  |  |
| sample.py render | 753 ms |  | 0 |  |  |  |
| sample.ts open | 326 ms |  | 0 |  |  |  |
| sample.ts render | 596 ms |  | 0 |  |  |  |
| sample.json open | 252 ms |  | 0 |  |  |  |
| sample.json render | 536 ms |  | 0 |  |  |  |
| rss settled | 124 MiB |  | 0 |  |  |  |
| rss peak | 219 MiB |  | 0 |  |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 |  |  |
| plugins loaded | 276 |  |  |
| config files | 2,044 |  |  |
| config lua lines | 184,511 |  |  |
| config lines | 216,310 |  |  |
| plugin lines | 2,222,516 |  |  |
