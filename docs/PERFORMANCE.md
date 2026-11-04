# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-04T02:09Z, release 0.30.2 (5278ca0d), load 4.71, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1796 ms | 1688 | 10 | +6% | 1062 | +69% |
| startup settled | 7674 ms | 7039 | 10 | +9% | 6460 | +19% |
| small.md open | 332 ms | 190 | 10 | +75% | 176 | +89% |
| small.md render | 615 ms | 349 | 10 | +76% | 294 | +109% |
| medium.md open | 264 ms | 251 | 10 | +5% | 159 | +65% |
| medium.md render | 551 ms | 476 | 10 | +16% | 313 | +76% |
| large.md open | 280 ms | 268 | 10 | +5% | 160 | +75% |
| large.md render | 522 ms | 491 | 10 | +6% | 317 | +65% |
| code.md open | 192 ms | 211 | 10 | -9% | 173 | +11% |
| code.md render | 388 ms | 440 | 10 | -12% | 353 | +10% |
| sample.lua open | 130 ms | 166 | 10 | -21% | 139 | -6% |
| sample.lua render | 343 ms | 418 | 10 | -18% | 360 | -5% |
| sample.py open | 254 ms | 172 | 10 | +47% | 124 | +104% |
| sample.py render | 569 ms | 405 | 10 | +41% | 344 | +66% |
| sample.ts open | 172 ms | 151 | 10 | +14% | 116 | +48% |
| sample.ts render | 374 ms | 405 | 10 | -8% | 347 | +8% |
| sample.json open | 139 ms | 174 | 10 | -20% | 131 | +6% |
| sample.json render | 332 ms | 443 | 10 | -25% | 347 | -4% |
| rss settled | 126 MiB | 120 | 10 | +5% | 120 | +5% |
| rss peak | 194 MiB | 194 | 10 | +0% | 194 | +0% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,588 | 1,588 | +0 |
| config lua lines | 141,368 | 141,318 | +50 |
| config lines | 220,618 | 220,560 | +58 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

Over 25% slower: startup ready: +69% vs baseline; small.md open: +75% vs average; small.md open: +89% vs baseline; small.md render: +76% vs average; small.md render: +109% vs baseline; medium.md open: +65% vs baseline; medium.md render: +76% vs baseline; large.md open: +75% vs baseline; large.md render: +65% vs baseline; sample.py open: +47% vs average; sample.py open: +104% vs baseline; sample.py render: +41% vs average; sample.py render: +66% vs baseline; sample.ts open: +48% vs baseline.

<!-- benchmark:end -->
