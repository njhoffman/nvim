# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-01T20:53Z, release 0.17.1 (da1811b7-dirty), load 4.74, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1396 ms | 3248 | 5 | -57% |  |  |
| startup settled | 6742 ms | 10289 | 5 | -34% |  |  |
| small.md open | 178 ms | 358 | 5 | -50% |  |  |
| small.md render | 317 ms | 702 | 5 | -55% |  |  |
| medium.md open | 167 ms | 429 | 5 | -61% |  |  |
| medium.md render | 363 ms | 1849 | 5 | -80% |  |  |
| large.md open | 178 ms | 382 | 5 | -53% |  |  |
| large.md render | 350 ms | 6039 | 5 | -94% |  |  |
| code.md open | 169 ms | 453 | 5 | -63% |  |  |
| code.md render | 383 ms | 3965 | 5 | -90% |  |  |
| sample.lua open | 111 ms | 276 | 5 | -60% |  |  |
| sample.lua render | 331 ms | 645 | 5 | -49% |  |  |
| sample.py open | 238 ms | 325 | 5 | -27% |  |  |
| sample.py render | 353 ms | 686 | 5 | -49% |  |  |
| sample.ts open | 101 ms | 276 | 5 | -63% |  |  |
| sample.ts render | 326 ms | 576 | 5 | -43% |  |  |
| sample.json open | 92 ms | 301 | 5 | -69% |  |  |
| sample.json render | 323 ms | 563 | 5 | -43% |  |  |
| rss settled | 117 MiB | 121 | 5 | -3% |  |  |
| rss peak | 192 MiB | 214 | 5 | -10% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,052 | 2,051 | +1 |
| config lua lines | 185,012 | 184,943 | +69 |
| config lines | 216,900 | 216,827 | +73 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

<!-- benchmark:end -->
