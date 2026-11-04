# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-04T05:48Z, release 0.30.4 (7e7fdc75), load 1.56, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1410 ms | 1650 | 10 | -15% | 1062 | +33% |
| startup settled | 6892 ms | 7015 | 10 | -2% | 6460 | +7% |
| small.md open | 134 ms | 186 | 10 | -28% | 176 | -24% |
| small.md render | 225 ms | 336 | 10 | -33% | 294 | -24% |
| medium.md open | 163 ms | 249 | 10 | -35% | 159 | +2% |
| medium.md render | 338 ms | 473 | 10 | -29% | 313 | +8% |
| large.md open | 132 ms | 266 | 10 | -50% | 160 | -17% |
| large.md render | 279 ms | 493 | 10 | -43% | 317 | -12% |
| code.md open | 144 ms | 203 | 10 | -29% | 173 | -17% |
| code.md render | 291 ms | 423 | 10 | -31% | 353 | -17% |
| sample.lua open | 118 ms | 170 | 10 | -30% | 139 | -15% |
| sample.lua render | 335 ms | 419 | 10 | -20% | 360 | -7% |
| sample.py open | 110 ms | 175 | 10 | -37% | 124 | -12% |
| sample.py render | 333 ms | 404 | 10 | -18% | 344 | -3% |
| sample.ts open | 96 ms | 148 | 10 | -35% | 116 | -17% |
| sample.ts render | 335 ms | 403 | 10 | -17% | 347 | -3% |
| sample.json open | 134 ms | 158 | 10 | -16% | 131 | +2% |
| sample.json render | 328 ms | 437 | 10 | -25% | 347 | -5% |
| rss settled | 125 MiB | 121 | 10 | +4% | 120 | +4% |
| rss peak | 197 MiB | 194 | 10 | +2% | 194 | +2% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,588 | 1,588 | +0 |
| config lua lines | 141,368 | 141,368 | +0 |
| config lines | 220,626 | 220,622 | +4 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

Over 25% slower: startup ready: +33% vs baseline.

<!-- benchmark:end -->
