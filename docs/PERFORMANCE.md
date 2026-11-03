# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-03T21:24Z, release 0.25.0 (9b98cdf5-dirty), load 2.87, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 3048 ms | 1334 | 10 | +129% | 1062 | +187% |
| startup settled | 10136 ms | 6818 | 10 | +49% | 6460 | +57% |
| small.md open | 256 ms | 166 | 10 | +54% | 176 | +45% |
| small.md render | 593 ms | 295 | 10 | +101% | 294 | +101% |
| medium.md open | 409 ms | 210 | 10 | +94% | 159 | +156% |
| medium.md render | 794 ms | 407 | 10 | +95% | 313 | +154% |
| large.md open | 604 ms | 201 | 10 | +200% | 160 | +276% |
| large.md render | 886 ms | 405 | 10 | +119% | 317 | +180% |
| code.md open | 395 ms | 168 | 10 | +135% | 173 | +128% |
| code.md render | 660 ms | 367 | 10 | +80% | 353 | +87% |
| sample.lua open | 298 ms | 137 | 10 | +117% | 139 | +115% |
| sample.lua render | 759 ms | 347 | 10 | +119% | 360 | +111% |
| sample.py open | 239 ms | 149 | 10 | +60% | 124 | +92% |
| sample.py render | 456 ms | 382 | 10 | +19% | 344 | +33% |
| sample.ts open | 292 ms | 116 | 10 | +152% | 116 | +151% |
| sample.ts render | 609 ms | 335 | 10 | +82% | 347 | +76% |
| sample.json open | 324 ms | 142 | 10 | +129% | 131 | +147% |
| sample.json render | 677 ms | 348 | 10 | +95% | 347 | +95% |
| rss settled | 122 MiB | 121 | 10 | +1% | 120 | +2% |
| rss peak | 201 MiB | 194 | 10 | +4% | 194 | +4% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,576 | 1,576 | +0 |
| config lua lines | 141,030 | 141,211 | -181 |
| config lines | 172,487 | 172,657 | -170 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

Over 25% slower: startup ready: +129% vs average; startup ready: +187% vs baseline; startup settled: +49% vs average; startup settled: +57% vs baseline; small.md open: +54% vs average; small.md open: +45% vs baseline; small.md render: +101% vs average; small.md render: +101% vs baseline; medium.md open: +94% vs average; medium.md open: +156% vs baseline; medium.md render: +95% vs average; medium.md render: +154% vs baseline; large.md open: +200% vs average; large.md open: +276% vs baseline; large.md render: +119% vs average; large.md render: +180% vs baseline; code.md open: +135% vs average; code.md open: +128% vs baseline; code.md render: +80% vs average; code.md render: +87% vs baseline; sample.lua open: +117% vs average; sample.lua open: +115% vs baseline; sample.lua render: +119% vs average; sample.lua render: +111% vs baseline; sample.py open: +60% vs average; sample.py open: +92% vs baseline; sample.py render: +33% vs baseline; sample.ts open: +152% vs average; sample.ts open: +151% vs baseline; sample.ts render: +82% vs average; sample.ts render: +76% vs baseline; sample.json open: +129% vs average; sample.json open: +147% vs baseline; sample.json render: +95% vs average; sample.json render: +95% vs baseline.

<!-- benchmark:end -->
