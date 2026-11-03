# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-03T23:55Z, release 0.30.0 (e57cfcff), load 4.58, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1296 ms | 1663 | 10 | -22% | 1062 | +22% |
| startup settled | 6356 ms | 7053 | 10 | -10% | 6460 | -2% |
| small.md open | 151 ms | 191 | 10 | -21% | 176 | -14% |
| small.md render | 250 ms | 349 | 10 | -28% | 294 | -15% |
| medium.md open | 148 ms | 254 | 10 | -42% | 159 | -7% |
| medium.md render | 322 ms | 481 | 10 | -33% | 313 | +3% |
| large.md open | 172 ms | 268 | 10 | -36% | 160 | +7% |
| large.md render | 347 ms | 489 | 10 | -29% | 317 | +9% |
| code.md open | 162 ms | 211 | 10 | -23% | 173 | -7% |
| code.md render | 333 ms | 442 | 10 | -25% | 353 | -6% |
| sample.lua open | 113 ms | 169 | 10 | -33% | 139 | -18% |
| sample.lua render | 344 ms | 419 | 10 | -18% | 360 | -4% |
| sample.py open | 94 ms | 175 | 10 | -46% | 124 | -24% |
| sample.py render | 323 ms | 406 | 10 | -20% | 344 | -6% |
| sample.ts open | 94 ms | 153 | 10 | -38% | 116 | -19% |
| sample.ts render | 327 ms | 407 | 10 | -20% | 347 | -6% |
| sample.json open | 107 ms | 179 | 10 | -40% | 131 | -18% |
| sample.json render | 322 ms | 445 | 10 | -28% | 347 | -7% |
| rss settled | 115 MiB | 120 | 10 | -4% | 120 | -4% |
| rss peak | 191 MiB | 194 | 10 | -2% | 194 | -1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,588 | 1,576 | +12 |
| config lua lines | 141,318 | 141,036 | +282 |
| config lines | 220,560 | 172,532 | +48,028 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

<!-- benchmark:end -->
