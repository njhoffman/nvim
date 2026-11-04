# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-04T03:56Z, release 0.30.2 (f0249253), load 2.47, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 802 ms | 1688 | 10 | -53% | 1062 | -25% |
| startup settled | 6201 ms | 7039 | 10 | -12% | 6460 | -4% |
| small.md open | 125 ms | 190 | 10 | -34% | 176 | -29% |
| small.md render | 197 ms | 349 | 10 | -44% | 294 | -33% |
| medium.md open | 137 ms | 251 | 10 | -45% | 159 | -14% |
| medium.md render | 288 ms | 476 | 10 | -39% | 313 | -8% |
| large.md open | 135 ms | 268 | 10 | -50% | 160 | -16% |
| large.md render | 316 ms | 491 | 10 | -36% | 317 | -0% |
| code.md open | 117 ms | 211 | 10 | -44% | 173 | -32% |
| code.md render | 242 ms | 440 | 10 | -45% | 353 | -31% |
| sample.lua open | 89 ms | 166 | 10 | -46% | 139 | -36% |
| sample.lua render | 347 ms | 418 | 10 | -17% | 360 | -4% |
| sample.py open | 131 ms | 172 | 10 | -24% | 124 | +5% |
| sample.py render | 337 ms | 405 | 10 | -17% | 344 | -2% |
| sample.ts open | 81 ms | 151 | 10 | -46% | 116 | -30% |
| sample.ts render | 320 ms | 405 | 10 | -21% | 347 | -8% |
| sample.json open | 79 ms | 174 | 10 | -55% | 131 | -39% |
| sample.json render | 334 ms | 443 | 10 | -25% | 347 | -4% |
| rss settled | 127 MiB | 120 | 10 | +6% | 120 | +6% |
| rss peak | 192 MiB | 194 | 10 | -1% | 194 | -1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,588 | 1,588 | +0 |
| config lua lines | 141,368 | 141,318 | +50 |
| config lines | 220,618 | 220,560 | +58 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

<!-- benchmark:end -->
