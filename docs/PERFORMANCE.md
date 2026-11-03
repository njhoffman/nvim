# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-03T22:57Z, release 0.27.0 (c07914eb-dirty), load 14.46, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 3508 ms | 1472 | 10 | +138% | 1062 | +230% |
| startup settled | 11201 ms | 6646 | 10 | +69% | 6460 | +73% |
| small.md open | 376 ms | 172 | 10 | +119% | 176 | +114% |
| small.md render | 653 ms | 317 | 10 | +106% | 294 | +122% |
| medium.md open | 444 ms | 235 | 10 | +89% | 159 | +178% |
| medium.md render | 814 ms | 451 | 10 | +81% | 313 | +160% |
| large.md open | 484 ms | 238 | 10 | +104% | 160 | +202% |
| large.md render | 803 ms | 445 | 10 | +80% | 317 | +153% |
| code.md open | 415 ms | 185 | 10 | +124% | 173 | +140% |
| code.md render | 934 ms | 389 | 10 | +140% | 353 | +165% |
| sample.lua open | 287 ms | 154 | 10 | +86% | 139 | +107% |
| sample.lua render | 621 ms | 391 | 10 | +59% | 360 | +72% |
| sample.py open | 302 ms | 154 | 10 | +95% | 124 | +143% |
| sample.py render | 560 ms | 382 | 10 | +46% | 344 | +63% |
| sample.ts open | 369 ms | 128 | 10 | +188% | 116 | +217% |
| sample.ts render | 788 ms | 361 | 10 | +119% | 347 | +127% |
| sample.json open | 339 ms | 159 | 10 | +113% | 131 | +159% |
| sample.json render | 960 ms | 381 | 10 | +152% | 347 | +177% |
| rss settled | 126 MiB | 119 | 10 | +5% | 120 | +5% |
| rss peak | 193 MiB | 194 | 10 | -0% | 194 | -0% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 274 | +2 |
| config files | 1,576 | 1,576 | +0 |
| config lua lines | 141,036 | 141,030 | +6 |
| config lines | 172,532 | 172,500 | +32 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

Over 25% slower: startup ready: +138% vs average; startup ready: +230% vs baseline; startup settled: +69% vs average; startup settled: +73% vs baseline; small.md open: +119% vs average; small.md open: +114% vs baseline; small.md render: +106% vs average; small.md render: +122% vs baseline; medium.md open: +89% vs average; medium.md open: +178% vs baseline; medium.md render: +81% vs average; medium.md render: +160% vs baseline; large.md open: +104% vs average; large.md open: +202% vs baseline; large.md render: +80% vs average; large.md render: +153% vs baseline; code.md open: +124% vs average; code.md open: +140% vs baseline; code.md render: +140% vs average; code.md render: +165% vs baseline; sample.lua open: +86% vs average; sample.lua open: +107% vs baseline; sample.lua render: +59% vs average; sample.lua render: +72% vs baseline; sample.py open: +95% vs average; sample.py open: +143% vs baseline; sample.py render: +46% vs average; sample.py render: +63% vs baseline; sample.ts open: +188% vs average; sample.ts open: +217% vs baseline; sample.ts render: +119% vs average; sample.ts render: +127% vs baseline; sample.json open: +113% vs average; sample.json open: +159% vs baseline; sample.json render: +152% vs average; sample.json render: +177% vs baseline.

<!-- benchmark:end -->
