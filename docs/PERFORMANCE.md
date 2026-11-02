# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-02T02:34Z, release 0.23.0 (141315c7-dirty), load 2.11, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 823 ms | 1385 | 10 | -41% | 1062 | -23% |
| startup settled | 6214 ms | 6851 | 10 | -9% | 6460 | -4% |
| small.md open | 104 ms | 164 | 10 | -37% | 176 | -41% |
| small.md render | 182 ms | 300 | 10 | -39% | 294 | -38% |
| medium.md open | 118 ms | 193 | 10 | -39% | 159 | -26% |
| medium.md render | 225 ms | 394 | 10 | -43% | 313 | -28% |
| large.md open | 122 ms | 181 | 10 | -33% | 160 | -24% |
| large.md render | 250 ms | 372 | 10 | -33% | 317 | -21% |
| code.md open | 92 ms | 169 | 10 | -45% | 173 | -47% |
| code.md render | 198 ms | 378 | 10 | -47% | 353 | -44% |
| sample.lua open | 95 ms | 129 | 10 | -27% | 139 | -32% |
| sample.lua render | 330 ms | 340 | 10 | -3% | 360 | -8% |
| sample.py open | 68 ms | 155 | 10 | -56% | 124 | -45% |
| sample.py render | 318 ms | 390 | 10 | -18% | 344 | -7% |
| sample.ts open | 82 ms | 117 | 10 | -30% | 116 | -30% |
| sample.ts render | 320 ms | 338 | 10 | -5% | 347 | -8% |
| sample.json open | 90 ms | 157 | 10 | -43% | 131 | -31% |
| sample.json render | 324 ms | 351 | 10 | -8% | 347 | -7% |
| rss settled | 124 MiB | 119 | 10 | +4% | 120 | +3% |
| rss peak | 193 MiB | 193 | 10 | +0% | 194 | -0% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,574 | 1,633 | -59 |
| config lua lines | 140,979 | 148,403 | -7,424 |
| config lines | 172,408 | 179,825 | -7,417 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

<!-- benchmark:end -->
