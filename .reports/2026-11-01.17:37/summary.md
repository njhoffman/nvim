# Nvim Config Report - 2026-11-01.17:37 (v0.19.0)

Consistent Markdown hard wrapping: prettierd (`prettierd_md`) reflows prose on save at the width
from `~/.prettierrc.yml` (120) or a project config, `formatoptions` drops `l` so typing wraps
already-long lines, and `J` reflows the paragraph (`lua/md_prose.lua`,
`after/ftplugin/markdown.lua`). The repo's Markdown was reflowed once (26 files), which is why
Markdown code lines dropped by 81. Also ships five pending path edits (greek-gods list and
script paths under `~/.shell`, tailwind-sorter's node path). No benchmark warnings (load 4.73).

| Metric                    | Value                                          | Delta vs v0.18.0 |
| ------------------------- | ---------------------------------------------- | ---------------- |
| Unit test files           | 39 Lua + 1 Python                              | +1               |
| Tests passing             | 460/460 (425 plenary, 17 mini.test, 18 Python) | +8               |
| Line coverage (lua/)      | 50.90%                                         | +0.10            |
| Lua code lines (cloc)     | 185,477 in 1,774 files                         | +138             |
| Markdown code lines       | 5,221                                          | -81              |
| Total code lines          | 217,416 in 2,059 files                         | +172             |
| Installed plugins (lazy/) | 377                                            | 0                |

## Benchmarks

Latest: 2026-11-01T23:54Z, release 0.19.0 (43f512f8-dirty), load 4.73, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1594 ms | 2506 | 8 | -36% |  |  |
| startup settled | 7227 ms | 8907 | 8 | -19% |  |  |
| small.md open | 170 ms | 286 | 8 | -41% |  |  |
| small.md render | 322 ms | 555 | 8 | -42% |  |  |
| medium.md open | 221 ms | 330 | 8 | -33% |  |  |
| medium.md render | 463 ms | 1280 | 8 | -64% |  |  |
| large.md open | 206 ms | 299 | 8 | -31% |  |  |
| large.md render | 473 ms | 3895 | 8 | -88% |  |  |
| code.md open | 158 ms | 347 | 8 | -54% |  |  |
| code.md render | 352 ms | 2621 | 8 | -87% |  |  |
| sample.lua open | 132 ms | 215 | 8 | -39% |  |  |
| sample.lua render | 331 ms | 527 | 8 | -37% |  |  |
| sample.py open | 179 ms | 266 | 8 | -33% |  |  |
| sample.py render | 451 ms | 556 | 8 | -19% |  |  |
| sample.ts open | 120 ms | 215 | 8 | -44% |  |  |
| sample.ts render | 329 ms | 485 | 8 | -32% |  |  |
| sample.json open | 98 ms | 249 | 8 | -61% |  |  |
| sample.json render | 323 ms | 477 | 8 | -32% |  |  |
| rss settled | 124 MiB | 119 | 8 | +4% |  |  |
| rss peak | 195 MiB | 206 | 8 | -5% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,059 | 2,055 | +4 |
| config lua lines | 185,477 | 185,339 | +138 |
| config lines | 217,416 | 217,244 | +172 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |
