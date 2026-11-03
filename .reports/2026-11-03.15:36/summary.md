# Nvim Config Report - 2026-11-03.15:36 (v0.26.0)

Second step of the `lua/` layout refactor: the config's own plugins-in-progress move under `lua/modules/` (`alt`,
`components`, `devdocs2`, `format_cmdline`, `gitops`, `glyph-guard`, `jumpguard`, `oldfiles`, `registers`, `runner`,
`sidebar`, `stats`, `tail`, `tmux`, `tracker`, `undo`, `unicode`), the three Markdown helpers become
`modules.markdown.{prose,backtick,codeblocks}`, and `lsp/` moves to `core/lsp/`. 197 files had requires rewritten;
two module names built by concatenation (`lsp.servers.`, `tracker.sources.`), the `gitops` script path and three specs'
`package.loaded` cleanup patterns were fixed by hand. Checks: the smoke test report is identical to v0.24.0's, the set
of modules loaded 5 s after startup is the same (modulo the new prefixes), and no literal require newly fails to
resolve. The recorded "startup settled" of 1835 ms (-74%) is a measurement artifact: a plain `benchmarks/run` right
after gave 6519 ms for this tree and 7035 ms for v0.24.0. The run used the uncommitted `lazy-lock.json` and
`lua/configs/conform.lua` (not part of this release).

| Metric                    | Value                                                  | Delta vs v0.25.0 |
| ------------------------- | ------------------------------------------------------ | ---------------- |
| Unit test files           | 42 Lua + 1 Python + 1 bats                             | 0                |
| Tests passing             | 491/491 (448 plenary, 17 mini.test, 19 Python, 7 bats) | 0                |
| Line coverage (lua/)      | 51.38%                                                 | 0.00             |
| Lua code lines (cloc)     | 141,030 in 1,297 files                                 | 0                |
| Markdown code lines       | 5,285                                                  | +13              |
| Total code lines          | 172,500 in 1,576 files                                 | +13              |
| Installed plugins (lazy/) | 376                                                    | 0                |

## Benchmarks

Latest: 2026-11-03T21:40Z, release 0.26.0 (9fa13028-dirty), load 4.40, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1064 ms | 1525 | 10 | -30% | 1062 | +0% |
| startup settled | 1835 ms | 7185 | 10 | -74% | 6460 | -72% |
| small.md open | 150 ms | 174 | 10 | -14% | 176 | -15% |
| small.md render | 289 ms | 320 | 10 | -10% | 294 | -2% |
| medium.md open | 222 ms | 235 | 10 | -6% | 159 | +39% |
| medium.md render | 396 ms | 458 | 10 | -13% | 313 | +27% |
| large.md open | 128 ms | 245 | 10 | -48% | 160 | -20% |
| large.md render | 282 ms | 464 | 10 | -39% | 317 | -11% |
| code.md open | 127 ms | 189 | 10 | -32% | 173 | -27% |
| code.md render | 283 ms | 396 | 10 | -29% | 353 | -20% |
| sample.lua open | 124 ms | 155 | 10 | -20% | 139 | -11% |
| sample.lua render | 343 ms | 390 | 10 | -12% | 360 | -5% |
| sample.py open | 154 ms | 157 | 10 | -1% | 124 | +24% |
| sample.py render | 334 ms | 394 | 10 | -15% | 344 | -3% |
| sample.ts open | 92 ms | 131 | 10 | -29% | 116 | -21% |
| sample.ts render | 323 ms | 361 | 10 | -11% | 347 | -7% |
| sample.json open | 111 ms | 158 | 10 | -30% | 131 | -15% |
| sample.json render | 325 ms | 381 | 10 | -15% | 347 | -6% |
| rss settled | 101 MiB | 122 | 10 | -17% | 120 | -16% |
| rss peak | 191 MiB | 194 | 10 | -2% | 194 | -1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 274 | 276 | -2 |
| config files | 1,576 | 1,576 | +0 |
| config lua lines | 141,030 | 141,030 | +0 |
| config lines | 172,500 | 172,487 | +13 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |

Over 25% slower: medium.md open: +39% vs baseline; medium.md render: +27% vs baseline.
