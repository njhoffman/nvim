# Nvim Config Report - 2026-11-01.18:22 (v0.20.0)

Faster, visible release reports. Unit spec files now run in parallel (one Neovim each) with per-spec luacov stats
merged by `scripts/luacov_merge.lua`; `scripts/report.sh` prints each phase with its duration, a line per spec file and
the benchmark's load waits, caches the plugin cloc by `lazy-lock.json`, and keeps a failed run's logs in
`.reports/failed/`. This report took 459 s (tests 324 s, cloc 8 s from cache, benchmarks 127 s including a 30 s load
wait) against about 30 minutes before. Coverage is unchanged by the parallel run (50.90%). New: 7 bats tests for
`run_tests.sh`, run as part of `all`. No benchmark warnings (load 4.09).

| Metric                    | Value                                                    | Delta vs v0.19.0 |
| ------------------------- | -------------------------------------------------------- | ---------------- |
| Unit test files           | 40 Lua + 1 Python + 1 bats                               | +2               |
| Tests passing             | 471/471 (429 plenary, 17 mini.test, 18 Python, 7 bats)   | +11              |
| Line coverage (lua/)      | 50.90%                                                   | 0.00             |
| Lua code lines (cloc)     | 185,542 in 1,776 files                                   | +65              |
| Markdown code lines       | 5,237                                                    | +16              |
| Total code lines          | 217,619 in 2,061 files                                   | +203             |
| Installed plugins (lazy/) | 377                                                      | 0                |

## Benchmarks

Latest: 2026-11-02T00:28Z, release 0.20.0 (1bb932ac-dirty), load 4.09, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; no baseline yet (run `benchmarks/run --baseline` under low load). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1592 ms | 2405 | 9 | -34% |  |  |
| startup settled | 7137 ms | 8720 | 9 | -18% |  |  |
| small.md open | 183 ms | 273 | 9 | -33% |  |  |
| small.md render | 331 ms | 529 | 9 | -38% |  |  |
| medium.md open | 254 ms | 318 | 9 | -20% |  |  |
| medium.md render | 517 ms | 1189 | 9 | -57% |  |  |
| large.md open | 180 ms | 289 | 9 | -38% |  |  |
| large.md render | 359 ms | 3515 | 9 | -90% |  |  |
| code.md open | 158 ms | 326 | 9 | -52% |  |  |
| code.md render | 401 ms | 2368 | 9 | -83% |  |  |
| sample.lua open | 139 ms | 206 | 9 | -32% |  |  |
| sample.lua render | 334 ms | 505 | 9 | -34% |  |  |
| sample.py open | 96 ms | 256 | 9 | -62% |  |  |
| sample.py render | 322 ms | 544 | 9 | -41% |  |  |
| sample.ts open | 122 ms | 205 | 9 | -41% |  |  |
| sample.ts render | 330 ms | 468 | 9 | -29% |  |  |
| sample.json open | 146 ms | 233 | 9 | -37% |  |  |
| sample.json render | 322 ms | 460 | 9 | -30% |  |  |
| rss settled | 116 MiB | 120 | 9 | -3% |  |  |
| rss peak | 191 MiB | 205 | 9 | -6% |  |  |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 2,061 | 2,059 | +2 |
| config lua lines | 185,542 | 185,477 | +65 |
| config lines | 217,619 | 217,416 | +203 |
| plugin lines | 2,222,516 | 2,222,516 | +0 |
