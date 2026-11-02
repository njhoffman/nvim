# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-02T02:16Z, release 0.21.0 (fc29c65a-dirty), load 2.00, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 806 ms | 1959 | 10 | -59% | 1062 | -24% |
| startup settled | 6170 ms | 7870 | 10 | -22% | 6460 | -4% |
| small.md open | 108 ms | 220 | 10 | -51% | 176 | -39% |
| small.md render | 202 ms | 421 | 10 | -52% | 294 | -32% |
| medium.md open | 104 ms | 263 | 10 | -60% | 159 | -35% |
| medium.md render | 195 ms | 813 | 10 | -76% | 313 | -38% |
| large.md open | 106 ms | 232 | 10 | -54% | 160 | -34% |
| large.md render | 199 ms | 2053 | 10 | -90% | 317 | -37% |
| code.md open | 122 ms | 262 | 10 | -53% | 173 | -29% |
| code.md render | 246 ms | 1412 | 10 | -83% | 353 | -30% |
| sample.lua open | 78 ms | 182 | 10 | -57% | 139 | -44% |
| sample.lua render | 331 ms | 448 | 10 | -26% | 360 | -8% |
| sample.py open | 80 ms | 211 | 10 | -62% | 124 | -35% |
| sample.py render | 337 ms | 476 | 10 | -29% | 344 | -2% |
| sample.ts open | 80 ms | 166 | 10 | -52% | 116 | -32% |
| sample.ts render | 330 ms | 413 | 10 | -20% | 347 | -5% |
| sample.json open | 168 ms | 202 | 10 | -16% | 131 | +29% |
| sample.json render | 342 ms | 416 | 10 | -18% | 347 | -1% |
| rss settled | 118 MiB | 119 | 10 | -1% | 120 | -2% |
| rss peak | 195 MiB | 198 | 10 | -2% | 194 | +1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,633 | 2,062 | -429 |
| config lua lines | 148,403 | 185,564 | -37,161 |
| config lines | 179,812 | 217,666 | -37,854 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

Over 25% slower: sample.json open: +29% vs baseline.

<!-- benchmark:end -->
