# Nvim Config Report - 2026-11-03.21:58 (v0.30.3)

### [0.30.3] - 2026-11-03

#### Changed

- Reran the 0.30.2 benchmarks at low load (2.47). The recorded run had a load of 4.71 and showed `small.md` and
  `sample.py` over 25% slower than average; the rerun has no warnings, so that was load and not a regression.

| Metric                    | Value                                                   | Delta vs v0.30.2 |
| ------------------------- | ------------------------------------------------------- | ---------------- |
| Unit spec files           | 43                                                      | -                |
| Tests passing             | 540/540 (480 plenary, 17 mini.test, 19 Python, 24 bats) | 0                |
| Line coverage (lua/)      | 53.62%                                                  | 0.00             |
| Lua code lines (cloc)     | 141,368 in 1,300 files                                  | 0                |
| Markdown code lines       | 5,360                                                   | +4               |
| Total code lines          | 220,622 in 1,588 files                                  | +4               |
| Installed plugins (lazy/) | 375                                                     | -                |

## Benchmarks

Latest: 2026-11-04T04:01Z, release 0.30.3 (6e85d87b), load 4.39, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 3780 ms | 1657 | 10 | +128% | 1062 | +256% |
| startup settled | 15194 ms | 7015 | 10 | +117% | 6460 | +135% |
| small.md open | 706 ms | 187 | 10 | +278% | 176 | +302% |
| small.md render | 1089 ms | 338 | 10 | +222% | 294 | +270% |
| medium.md open | 710 ms | 249 | 10 | +186% | 159 | +346% |
| medium.md render | 1260 ms | 474 | 10 | +166% | 313 | +303% |
| large.md open | 517 ms | 266 | 10 | +94% | 160 | +222% |
| large.md render | 1308 ms | 492 | 10 | +166% | 317 | +313% |
| code.md open | 791 ms | 205 | 10 | +286% | 173 | +357% |
| code.md render | 1226 ms | 426 | 10 | +188% | 353 | +248% |
| sample.lua open | 620 ms | 163 | 10 | +282% | 139 | +347% |
| sample.lua render | 1096 ms | 418 | 10 | +163% | 360 | +204% |
| sample.py open | 404 ms | 175 | 10 | +131% | 124 | +225% |
| sample.py render | 684 ms | 406 | 10 | +69% | 344 | +99% |
| sample.ts open | 466 ms | 148 | 10 | +215% | 116 | +300% |
| sample.ts render | 1094 ms | 403 | 10 | +172% | 347 | +216% |
| sample.json open | 528 ms | 167 | 10 | +216% | 131 | +303% |
| sample.json render | 756 ms | 437 | 10 | +73% | 347 | +118% |
| rss settled | 114 MiB | 121 | 10 | -5% | 120 | -5% |
| rss peak | 196 MiB | 194 | 10 | +1% | 194 | +1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,588 | 1,588 | +0 |
| config lua lines | 141,368 | 141,368 | +0 |
| config lines | 220,622 | 220,618 | +4 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

Over 25% slower: startup ready: +128% vs average; startup ready: +256% vs baseline; startup settled: +117% vs average; startup settled: +135% vs baseline; small.md open: +278% vs average; small.md open: +302% vs baseline; small.md render: +222% vs average; small.md render: +270% vs baseline; medium.md open: +186% vs average; medium.md open: +346% vs baseline; medium.md render: +166% vs average; medium.md render: +303% vs baseline; large.md open: +94% vs average; large.md open: +222% vs baseline; large.md render: +166% vs average; large.md render: +313% vs baseline; code.md open: +286% vs average; code.md open: +357% vs baseline; code.md render: +188% vs average; code.md render: +248% vs baseline; sample.lua open: +282% vs average; sample.lua open: +347% vs baseline; sample.lua render: +163% vs average; sample.lua render: +204% vs baseline; sample.py open: +131% vs average; sample.py open: +225% vs baseline; sample.py render: +69% vs average; sample.py render: +99% vs baseline; sample.ts open: +215% vs average; sample.ts open: +300% vs baseline; sample.ts render: +172% vs average; sample.ts render: +216% vs baseline; sample.json open: +216% vs average; sample.json open: +303% vs baseline; sample.json render: +73% vs average; sample.json render: +118% vs baseline.
