# Nvim Config Report - 2026-11-01.20:18 (v0.22.0)

Docs consolidation: markdown notes and keymap dumps move from `doc/` and `lua/` into `docs/reference/` (indexed in
`docs/README.md`), the stale task prompts in `doc/specs/` and two exact duplicates go to `~/.local/backup/nvim/`.
No Lua code changed; tests are unchanged. The benchmark warnings below are load noise, not a regression: system load
rose to about 4 during the run (load 1.76 at start, baseline 0.95), with leftover headless test processes from earlier
sessions running.

| Metric                    | Value                                                  | Delta vs v0.21.0 |
| ------------------------- | ------------------------------------------------------ | ---------------- |
| Unit test files           | 41 Lua + 1 Python + 1 bats                             | 0                |
| Tests passing             | 477/477 (434 plenary, 17 mini.test, 19 Python, 7 bats) | 0                |
| Line coverage (lua/)      | 51.16%                                                 | 0.00             |
| Lua code lines (cloc)     | 148,403 in 1,355 files                                 | 0                |
| Markdown code lines       | 5,236                                                  | +13              |
| Total code lines          | 179,825 in 1,633 files                                 | +13              |
| Installed plugins (lazy/) | 377                                                    | 0                |

## Benchmarks

Latest: 2026-11-02T02:21Z, release 0.22.0 (d4a48dc9-dirty), load 1.76, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1370 ms | 1757 | 10 | -22% | 1062 | +29% |
| startup settled | 6761 ms | 7484 | 10 | -10% | 6460 | +5% |
| small.md open | 128 ms | 209 | 10 | -39% | 176 | -27% |
| small.md render | 224 ms | 382 | 10 | -41% | 294 | -24% |
| medium.md open | 278 ms | 222 | 10 | +25% | 159 | +74% |
| medium.md render | 506 ms | 634 | 10 | -20% | 313 | +62% |
| large.md open | 242 ms | 207 | 10 | +17% | 160 | +51% |
| large.md render | 488 ms | 1328 | 10 | -63% | 317 | +54% |
| code.md open | 134 ms | 239 | 10 | -44% | 173 | -23% |
| code.md render | 377 ms | 982 | 10 | -62% | 353 | +7% |
| sample.lua open | 194 ms | 156 | 10 | +24% | 139 | +39% |
| sample.lua render | 326 ms | 419 | 10 | -22% | 360 | -9% |
| sample.py open | 324 ms | 187 | 10 | +74% | 124 | +161% |
| sample.py render | 656 ms | 437 | 10 | +50% | 344 | +91% |
| sample.ts open | 119 ms | 151 | 10 | -21% | 116 | +2% |
| sample.ts render | 339 ms | 395 | 10 | -14% | 347 | -2% |
| sample.json open | 122 ms | 194 | 10 | -37% | 131 | -7% |
| sample.json render | 336 ms | 405 | 10 | -17% | 347 | -3% |
| rss settled | 124 MiB | 119 | 10 | +3% | 120 | +3% |
| rss peak | 191 MiB | 196 | 10 | -3% | 194 | -1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,633 | 1,633 | +0 |
| config lua lines | 148,403 | 148,403 | +0 |
| config lines | 179,825 | 179,812 | +13 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |

Over 25% slower: startup ready: +29% vs baseline; medium.md open: +74% vs baseline; medium.md render: +62% vs baseline; large.md open: +51% vs baseline; large.md render: +54% vs baseline; sample.lua open: +39% vs baseline; sample.py open: +74% vs average; sample.py open: +161% vs baseline; sample.py render: +50% vs average; sample.py render: +91% vs baseline.
