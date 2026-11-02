# Nvim Config Report - 2026-11-01.19:07 (v0.20.2)

prettierd formats on save again: the broken `prettierd` override and its `_js`/`_toml`/`_vue`/`_packagejson` variants
(no file passed, so nothing changed) are removed in favor of conform's built-in definition, with a new spec that also
runs a real format. The Python test summary is back in `tests.log`. No benchmark warnings (load 2.26; baseline 0.95).

| Metric                    | Value                                                  | Delta vs v0.20.1 |
| ------------------------- | ------------------------------------------------------ | ---------------- |
| Unit test files           | 41 Lua + 1 Python + 1 bats                             | +1               |
| Tests passing             | 477/477 (434 plenary, 17 mini.test, 19 Python, 7 bats) | +5               |
| Line coverage (lua/)      | 51.16%                                                 | +0.26            |
| Lua code lines (cloc)     | 185,564 in 1,777 files                                 | +22              |
| Markdown code lines       | 5,254                                                  | +6               |
| Total code lines          | 217,666 in 2,062 files                                 | +28              |
| Installed plugins (lazy/) | 377                                                    | 0                |

## Benchmarks

Latest: 2026-11-02T01:10Z, release 0.20.2 (3223206a-dirty), load 2.26, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1110 ms | 2048 | 10 | -46% | 1062 | +4% |
| startup settled | 6439 ms | 8075 | 10 | -20% | 6460 | -0% |
| small.md open | 157 ms | 241 | 10 | -35% | 176 | -11% |
| small.md render | 309 ms | 467 | 10 | -34% | 294 | +5% |
| medium.md open | 158 ms | 287 | 10 | -45% | 159 | -1% |
| medium.md render | 311 ms | 959 | 10 | -68% | 313 | -0% |
| large.md open | 155 ms | 244 | 10 | -37% | 160 | -3% |
| large.md render | 307 ms | 2535 | 10 | -88% | 317 | -3% |
| code.md open | 181 ms | 282 | 10 | -36% | 173 | +5% |
| code.md render | 384 ms | 1778 | 10 | -78% | 353 | +9% |
| sample.lua open | 124 ms | 190 | 10 | -34% | 139 | -10% |
| sample.lua render | 356 ms | 469 | 10 | -24% | 360 | -1% |
| sample.py open | 104 ms | 216 | 10 | -52% | 124 | -16% |
| sample.py render | 327 ms | 480 | 10 | -32% | 344 | -5% |
| sample.ts open | 106 ms | 175 | 10 | -40% | 116 | -9% |
| sample.ts render | 344 ms | 429 | 10 | -20% | 347 | -1% |
| sample.json open | 152 ms | 214 | 10 | -29% | 131 | +16% |
| sample.json render | 399 ms | 426 | 10 | -6% | 347 | +15% |
| rss settled | 117 MiB | 119 | 10 | -2% | 120 | -3% |
| rss peak | 195 MiB | 201 | 10 | -3% | 194 | +1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,062 | 2,061 | +1 |
| config lua lines | 185,564 | 185,542 | +22 |
| config lines | 217,666 | 217,638 | +28 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |
