# Performance

Startup and rendering benchmarks, recorded with every release by `scripts/report.sh`
through `benchmarks/run`. The table below is rewritten on each recorded run.

## Benchmarks

<!-- benchmark:start -->

Latest: 2026-11-01T19:15Z, release 0.16.2 (711cce57-dirty), load 4.50, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 2822 ms | 2901 | 2 | -3% |  |  |
| startup settled | 10031 ms | 9926 | 2 | +1% |  |  |
| small.md open | 221 ms | 379 | 2 | -42% |  |  |
| small.md render | 590 ms | 722 | 2 | -18% |  |  |
| medium.md open | 515 ms | 409 | 2 | +26% |  |  |
| medium.md render | 1987 ms | 1883 | 2 | +6% |  |  |
| large.md open | 352 ms | 392 | 2 | -10% |  |  |
| large.md render | 7456 ms | 6052 | 2 | +23% |  |  |
| code.md open | 354 ms | 407 | 2 | -13% |  |  |
| code.md render | 4546 ms | 4168 | 2 | +9% |  |  |
| sample.lua open | 330 ms | 221 | 2 | +50% |  |  |
| sample.lua render | 624 ms | 557 | 2 | +12% |  |  |
| sample.py open | 320 ms | 259 | 2 | +23% |  |  |
| sample.py render | 727 ms | 562 | 2 | +29% |  |  |
| sample.ts open | 236 ms | 261 | 2 | -10% |  |  |
| sample.ts render | 509 ms | 546 | 2 | -7% |  |  |
| sample.json open | 251 ms | 261 | 2 | -4% |  |  |
| sample.json render | 455 ms | 515 | 2 | -12% |  |  |
| rss settled | 116 MiB | 120 | 2 | -3% |  |  |
| rss peak | 218 MiB | 219 | 2 | -0% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,046 | 2,045 | +1 |
| config lua lines | 184,569 | 184,511 | +58 |
| config lines | 216,433 | 216,361 | +72 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

Over 25% slower: medium.md open: +26% vs average; sample.lua open: +50% vs average; sample.py render: +29% vs average.

<!-- benchmark:end -->
