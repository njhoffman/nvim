# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-03T18:14Z, release 0.24.0 (b5e400b2-dirty), load 4.74, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1475 ms | 1313 | 10 | +12% | 1062 | +39% |
| startup settled | 6960 ms | 6783 | 10 | +3% | 6460 | +8% |
| small.md open | 255 ms | 155 | 10 | +65% | 176 | +45% |
| small.md render | 387 ms | 284 | 10 | +36% | 294 | +31% |
| medium.md open | 256 ms | 201 | 10 | +27% | 159 | +61% |
| medium.md render | 490 ms | 392 | 10 | +25% | 313 | +57% |
| large.md open | 285 ms | 187 | 10 | +53% | 160 | +78% |
| large.md render | 506 ms | 386 | 10 | +31% | 317 | +60% |
| code.md open | 189 ms | 164 | 10 | +15% | 173 | +9% |
| code.md render | 443 ms | 361 | 10 | +23% | 353 | +25% |
| sample.lua open | 132 ms | 135 | 10 | -2% | 139 | -5% |
| sample.lua render | 348 ms | 345 | 10 | +1% | 360 | -3% |
| sample.py open | 169 ms | 142 | 10 | +19% | 124 | +36% |
| sample.py render | 356 ms | 379 | 10 | -6% | 344 | +3% |
| sample.ts open | 142 ms | 112 | 10 | +27% | 116 | +22% |
| sample.ts render | 338 ms | 334 | 10 | +1% | 347 | -3% |
| sample.json open | 208 ms | 145 | 10 | +44% | 131 | +59% |
| sample.json render | 426 ms | 338 | 10 | +26% | 347 | +23% |
| rss settled | 126 MiB | 120 | 10 | +5% | 120 | +5% |
| rss peak | 196 MiB | 193 | 10 | +2% | 194 | +1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,576 | 1,574 | +2 |
| config lua lines | 141,211 | 140,979 | +232 |
| config lines | 172,657 | 172,413 | +244 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

Over 25% slower: startup ready: +39% vs baseline; small.md open: +65% vs average; small.md open: +45% vs baseline; small.md render: +36% vs average; small.md render: +31% vs baseline; medium.md open: +27% vs average; medium.md open: +61% vs baseline; medium.md render: +57% vs baseline; large.md open: +53% vs average; large.md open: +78% vs baseline; large.md render: +31% vs average; large.md render: +60% vs baseline; code.md render: +25% vs baseline; sample.py open: +36% vs baseline; sample.ts open: +27% vs average; sample.json open: +44% vs average; sample.json open: +59% vs baseline; sample.json render: +26% vs average.

<!-- benchmark:end -->
