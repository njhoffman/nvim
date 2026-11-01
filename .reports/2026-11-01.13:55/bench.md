Latest: 2026-11-01T20:20Z, release 0.16.3 (c3685316-dirty), load 12.16, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 5091 ms | 2875 | 3 | +77% |  |  |
| startup settled | 13094 ms | 9961 | 3 | +31% |  |  |
| small.md open | 580 ms | 326 | 3 | +78% |  |  |
| small.md render | 1048 ms | 678 | 3 | +54% |  |  |
| medium.md open | 569 ms | 445 | 3 | +28% |  |  |
| medium.md render | 2908 ms | 1918 | 3 | +52% |  |  |
| large.md open | 506 ms | 378 | 3 | +34% |  |  |
| large.md render | 10039 ms | 6520 | 3 | +54% |  |  |
| code.md open | 835 ms | 389 | 3 | +115% |  |  |
| code.md render | 6420 ms | 4294 | 3 | +50% |  |  |
| sample.lua open | 465 ms | 257 | 3 | +81% |  |  |
| sample.lua render | 1116 ms | 580 | 3 | +93% |  |  |
| sample.py open | 638 ms | 279 | 3 | +128% |  |  |
| sample.py render | 1128 ms | 617 | 3 | +83% |  |  |
| sample.ts open | 452 ms | 253 | 3 | +79% |  |  |
| sample.ts render | 918 ms | 534 | 3 | +72% |  |  |
| sample.json open | 488 ms | 258 | 3 | +89% |  |  |
| sample.json render | 875 ms | 495 | 3 | +77% |  |  |
| rss settled | 124 MiB | 119 | 3 | +4% |  |  |
| rss peak | 221 MiB | 219 | 3 | +1% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,051 | 2,046 | +5 |
| config lua lines | 184,943 | 184,569 | +374 |
| config lines | 216,820 | 216,433 | +387 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

Over 25% slower: startup ready: +77% vs average; startup settled: +31% vs average; small.md open: +78% vs average; small.md render: +54% vs average; medium.md open: +28% vs average; medium.md render: +52% vs average; large.md open: +34% vs average; large.md render: +54% vs average; code.md open: +115% vs average; code.md render: +50% vs average; sample.lua open: +81% vs average; sample.lua render: +93% vs average; sample.py open: +128% vs average; sample.py render: +83% vs average; sample.ts open: +79% vs average; sample.ts render: +72% vs average; sample.json open: +89% vs average; sample.json render: +77% vs average.
