# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-02T01:04Z, release 0.20.1 (f7e338e6-dirty), load 2.07, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1047 ms | 2323 | 10 | -55% | 1062 | -1% |
| startup settled | 6491 ms | 8562 | 10 | -24% | 6460 | +0% |
| small.md open | 161 ms | 264 | 10 | -39% | 176 | -9% |
| small.md render | 250 ms | 509 | 10 | -51% | 294 | -15% |
| medium.md open | 179 ms | 311 | 10 | -42% | 159 | +12% |
| medium.md render | 366 ms | 1122 | 10 | -67% | 313 | +17% |
| large.md open | 172 ms | 278 | 10 | -38% | 160 | +8% |
| large.md render | 334 ms | 3199 | 10 | -90% | 317 | +5% |
| code.md open | 162 ms | 309 | 10 | -47% | 173 | -6% |
| code.md render | 356 ms | 2172 | 10 | -84% | 353 | +1% |
| sample.lua open | 143 ms | 199 | 10 | -28% | 139 | +3% |
| sample.lua render | 354 ms | 488 | 10 | -27% | 360 | -2% |
| sample.py open | 118 ms | 240 | 10 | -51% | 124 | -5% |
| sample.py render | 337 ms | 522 | 10 | -35% | 344 | -2% |
| sample.ts open | 116 ms | 197 | 10 | -41% | 116 | -1% |
| sample.ts render | 343 ms | 454 | 10 | -24% | 347 | -1% |
| sample.json open | 149 ms | 224 | 10 | -33% | 131 | +14% |
| sample.json render | 335 ms | 446 | 10 | -25% | 347 | -3% |
| rss settled | 124 MiB | 119 | 10 | +4% | 120 | +3% |
| rss peak | 193 MiB | 203 | 10 | -5% | 194 | -0% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,061 | 2,061 | +0 |
| config lua lines | 185,542 | 185,542 | +0 |
| config lines | 217,638 | 217,619 | +19 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

<!-- benchmark:end -->
