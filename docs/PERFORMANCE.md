# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-03T21:40Z, release 0.26.0 (9fa13028-dirty), load 4.40, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1064 ms | 1525 | 10 | -30% | 1062 | +0% |
| startup settled | 1835 ms | 7185 | 10 | -74% | 6460 | -72% |
| small.md open | 150 ms | 174 | 10 | -14% | 176 | -15% |
| small.md render | 289 ms | 320 | 10 | -10% | 294 | -2% |
| medium.md open | 222 ms | 235 | 10 | -6% | 159 | +39% |
| medium.md render | 396 ms | 458 | 10 | -13% | 313 | +27% |
| large.md open | 128 ms | 245 | 10 | -48% | 160 | -20% |
| large.md render | 282 ms | 464 | 10 | -39% | 317 | -11% |
| code.md open | 127 ms | 189 | 10 | -32% | 173 | -27% |
| code.md render | 283 ms | 396 | 10 | -29% | 353 | -20% |
| sample.lua open | 124 ms | 155 | 10 | -20% | 139 | -11% |
| sample.lua render | 343 ms | 390 | 10 | -12% | 360 | -5% |
| sample.py open | 154 ms | 157 | 10 | -1% | 124 | +24% |
| sample.py render | 334 ms | 394 | 10 | -15% | 344 | -3% |
| sample.ts open | 92 ms | 131 | 10 | -29% | 116 | -21% |
| sample.ts render | 323 ms | 361 | 10 | -11% | 347 | -7% |
| sample.json open | 111 ms | 158 | 10 | -30% | 131 | -15% |
| sample.json render | 325 ms | 381 | 10 | -15% | 347 | -6% |
| rss settled | 101 MiB | 122 | 10 | -17% | 120 | -16% |
| rss peak | 191 MiB | 194 | 10 | -2% | 194 | -1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 274 | 276 | -2 |
| config files | 1,576 | 1,576 | +0 |
| config lua lines | 141,030 | 141,030 | +0 |
| config lines | 172,500 | 172,487 | +13 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

Over 25% slower: medium.md open: +39% vs baseline; medium.md render: +27% vs baseline.

<!-- benchmark:end -->
