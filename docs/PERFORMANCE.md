# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-02T00:28Z, release 0.20.0 (1bb932ac-dirty), load 4.09, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1592 ms | 2405 | 9 | -34% |  |  |
| startup settled | 7137 ms | 8720 | 9 | -18% |  |  |
| small.md open | 183 ms | 273 | 9 | -33% |  |  |
| small.md render | 331 ms | 529 | 9 | -38% |  |  |
| medium.md open | 254 ms | 318 | 9 | -20% |  |  |
| medium.md render | 517 ms | 1189 | 9 | -57% |  |  |
| large.md open | 180 ms | 289 | 9 | -38% |  |  |
| large.md render | 359 ms | 3515 | 9 | -90% |  |  |
| code.md open | 158 ms | 326 | 9 | -52% |  |  |
| code.md render | 401 ms | 2368 | 9 | -83% |  |  |
| sample.lua open | 139 ms | 206 | 9 | -32% |  |  |
| sample.lua render | 334 ms | 505 | 9 | -34% |  |  |
| sample.py open | 96 ms | 256 | 9 | -62% |  |  |
| sample.py render | 322 ms | 544 | 9 | -41% |  |  |
| sample.ts open | 122 ms | 205 | 9 | -41% |  |  |
| sample.ts render | 330 ms | 468 | 9 | -29% |  |  |
| sample.json open | 146 ms | 233 | 9 | -37% |  |  |
| sample.json render | 322 ms | 460 | 9 | -30% |  |  |
| rss settled | 116 MiB | 120 | 9 | -3% |  |  |
| rss peak | 191 MiB | 205 | 9 | -6% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,061 | 2,059 | +2 |
| config lua lines | 185,542 | 185,477 | +65 |
| config lines | 217,619 | 217,416 | +203 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

<!-- benchmark:end -->
