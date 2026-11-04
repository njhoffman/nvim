# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-04T05:44Z, release 0.30.3 (89f11b10), load 0.77, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 739 ms | 1657 | 10 | -55% | 1062 | -30% |
| startup settled | 6162 ms | 7015 | 10 | -12% | 6460 | -5% |
| small.md open | 102 ms | 187 | 10 | -45% | 176 | -42% |
| small.md render | 184 ms | 338 | 10 | -45% | 294 | -37% |
| medium.md open | 104 ms | 249 | 10 | -58% | 159 | -34% |
| medium.md render | 188 ms | 474 | 10 | -60% | 313 | -40% |
| large.md open | 111 ms | 266 | 10 | -58% | 160 | -31% |
| large.md render | 213 ms | 492 | 10 | -57% | 317 | -33% |
| code.md open | 106 ms | 205 | 10 | -48% | 173 | -39% |
| code.md render | 212 ms | 426 | 10 | -50% | 353 | -40% |
| sample.lua open | 148 ms | 163 | 10 | -9% | 139 | +7% |
| sample.lua render | 343 ms | 418 | 10 | -18% | 360 | -5% |
| sample.py open | 81 ms | 175 | 10 | -54% | 124 | -35% |
| sample.py render | 323 ms | 406 | 10 | -20% | 344 | -6% |
| sample.ts open | 83 ms | 148 | 10 | -44% | 116 | -29% |
| sample.ts render | 337 ms | 403 | 10 | -16% | 347 | -3% |
| sample.json open | 81 ms | 167 | 10 | -52% | 131 | -38% |
| sample.json render | 344 ms | 437 | 10 | -21% | 347 | -1% |
| rss settled | 117 MiB | 121 | 10 | -3% | 120 | -2% |
| rss peak | 195 MiB | 194 | 10 | +1% | 194 | +1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,588 | 1,588 | +0 |
| config lua lines | 141,368 | 141,368 | +0 |
| config lines | 220,622 | 220,618 | +4 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

<!-- benchmark:end -->
