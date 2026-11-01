# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-01T23:10Z, release 0.18.0 (566ad04f-dirty), load 4.74, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1140 ms | 2701 | 7 | -58% |  |  |
| startup settled | 6464 ms | 9256 | 7 | -30% |  |  |
| small.md open | 176 ms | 302 | 7 | -42% |  |  |
| small.md render | 337 ms | 586 | 7 | -43% |  |  |
| medium.md open | 164 ms | 354 | 7 | -54% |  |  |
| medium.md render | 284 ms | 1422 | 7 | -80% |  |  |
| large.md open | 160 ms | 319 | 7 | -50% |  |  |
| large.md render | 297 ms | 4409 | 7 | -93% |  |  |
| code.md open | 187 ms | 369 | 7 | -49% |  |  |
| code.md render | 376 ms | 2941 | 7 | -87% |  |  |
| sample.lua open | 122 ms | 228 | 7 | -47% |  |  |
| sample.lua render | 332 ms | 555 | 7 | -40% |  |  |
| sample.py open | 165 ms | 280 | 7 | -41% |  |  |
| sample.py render | 339 ms | 587 | 7 | -42% |  |  |
| sample.ts open | 143 ms | 226 | 7 | -37% |  |  |
| sample.ts render | 345 ms | 505 | 7 | -32% |  |  |
| sample.json open | 161 ms | 262 | 7 | -39% |  |  |
| sample.json render | 345 ms | 496 | 7 | -30% |  |  |
| rss settled | 117 MiB | 119 | 7 | -2% |  |  |
| rss peak | 194 MiB | 208 | 7 | -6% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,055 | 2,053 | +2 |
| config lua lines | 185,339 | 185,047 | +292 |
| config lines | 217,244 | 216,941 | +303 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

<!-- benchmark:end -->
