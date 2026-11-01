# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-01T21:03Z, release 0.17.2 (fa0c9e67-dirty), load 2.92, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1271 ms | 2939 | 6 | -57% |  |  |
| startup settled | 6608 ms | 9697 | 6 | -32% |  |  |
| small.md open | 148 ms | 328 | 6 | -55% |  |  |
| small.md render | 280 ms | 638 | 6 | -56% |  |  |
| medium.md open | 164 ms | 385 | 6 | -58% |  |  |
| medium.md render | 348 ms | 1601 | 6 | -78% |  |  |
| large.md open | 145 ms | 348 | 6 | -58% |  |  |
| large.md render | 318 ms | 5091 | 6 | -94% |  |  |
| code.md open | 152 ms | 406 | 6 | -62% |  |  |
| code.md render | 379 ms | 3368 | 6 | -89% |  |  |
| sample.lua open | 105 ms | 249 | 6 | -58% |  |  |
| sample.lua render | 328 ms | 593 | 6 | -45% |  |  |
| sample.py open | 96 ms | 311 | 6 | -69% |  |  |
| sample.py render | 326 ms | 630 | 6 | -48% |  |  |
| sample.ts open | 100 ms | 247 | 6 | -60% |  |  |
| sample.ts render | 327 ms | 534 | 6 | -39% |  |  |
| sample.json open | 238 ms | 266 | 6 | -11% |  |  |
| sample.json render | 333 ms | 523 | 6 | -36% |  |  |
| rss settled | 115 MiB | 120 | 6 | -4% |  |  |
| rss peak | 191 MiB | 210 | 6 | -9% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,053 | 2,052 | +1 |
| config lua lines | 185,047 | 185,012 | +35 |
| config lines | 216,941 | 216,900 | +41 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

<!-- benchmark:end -->
