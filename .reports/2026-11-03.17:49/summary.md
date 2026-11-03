# Nvim Config Report - 2026-11-03.17:49 (v0.30.0)

### [0.30.0] - 2026-11-03

#### Changed

- The release report runs when pushing, not with every commit. `scripts/release.sh` now only commits and tags, and the
  new `scripts/push.sh` runs the report for the latest tag, generates `summary.md`, commits the report files and pushes.
  A plain `git push` of main is refused by `scripts/hooks/pre-push`; `git push --no-verify` skips the check.

### [0.29.0] - 2026-11-03

#### Added

- Log files are highlighted again: `*.log` and `*_log` get the `log` filetype, which Neovim doesn't assign by default,
  with a new tree-sitter parser (`parsers/tree-sitter-log`, built to `parser/log.so`). It covers dates, times, durations,
  levels in any case plus `SEVERE`/`FINE`/`FINER`/`FINEST` and the nerd-font level glyphs, strings, numbers, URLs, IPs,
  hashes, paths, domains, XML, syslog columns and Lua dump references like `<function 2>`. Colors come from the old
  nvimpager `syntax/log.vim`, as `@log.*` groups you can override. Without the parser, the runtime syntax still applies.
- `/var/log/syslog*` uses `syntax/syslog.vim` again instead of the `messages` filetype.

### [0.28.0] - 2026-11-03

#### Changed

- Clipboard provider moved to `lua/core/globals/clipboard.lua`. `+` is still written at once; a tmux buffer and the
  history now come from `clipd yank` in the background, with the filetype, file, lines and operator as context and
  destinations from `~/.config/clipd/config.toml`. By default deletes (`d`, `c`, `x`) reach `+` only, no longer a tmux
  buffer, and `"*y` reaches PRIMARY only. On Claude Code's prompt file the source is `claude`. Without clipd, yanks
  still make a tmux buffer.
- Updated 37 plugins in `lazy-lock.json` and dropped `neoscroll.nvim` from it.

#### Removed

- The `nixpkgs_fmt` formatter for Nix files in `lua/configs/conform.lua`, so conform no longer formats them.

| Metric                    | Value                                                   | Delta vs v0.27.0 |
| ------------------------- | ------------------------------------------------------- | ---------------- |
| Unit spec files           | 43                                                      | -                |
| Tests passing             | 538/538 (478 plenary, 17 mini.test, 19 Python, 24 bats) | +47              |
| Line coverage (lua/)      | 51.28%                                                  | -0.10            |
| Lua code lines (cloc)     | 141,318 in 1,300 files                                  | +282             |
| Markdown code lines       | 5,348                                                   | +37              |
| Total code lines          | 220,560 in 1,588 files                                  | +48,028          |
| Installed plugins (lazy/) | 375                                                     | -                |

## Benchmarks

Latest: 2026-11-03T23:55Z, release 0.30.0 (e57cfcff), load 4.58, NVIM v0.13.0-dev-1915+gc5641b2bfb. Median of 3 sessions after one warm-up session, 100x40 UI. Average is over the previous 10 releases; baseline from 2026-11-02T00:56Z (load 0.95, 10 sessions). Recorded in [benchmarks/history.tsv](../benchmarks/history.tsv); see [benchmarks/README.md](../benchmarks/README.md).

| Metric | Latest | Average | Releases | vs average | Baseline | vs baseline |
|---|---:|---:|---:|---:|---:|---:|
| startup ready | 1296 ms | 1663 | 10 | -22% | 1062 | +22% |
| startup settled | 6356 ms | 7053 | 10 | -10% | 6460 | -2% |
| small.md open | 151 ms | 191 | 10 | -21% | 176 | -14% |
| small.md render | 250 ms | 349 | 10 | -28% | 294 | -15% |
| medium.md open | 148 ms | 254 | 10 | -42% | 159 | -7% |
| medium.md render | 322 ms | 481 | 10 | -33% | 313 | +3% |
| large.md open | 172 ms | 268 | 10 | -36% | 160 | +7% |
| large.md render | 347 ms | 489 | 10 | -29% | 317 | +9% |
| code.md open | 162 ms | 211 | 10 | -23% | 173 | -7% |
| code.md render | 333 ms | 442 | 10 | -25% | 353 | -6% |
| sample.lua open | 113 ms | 169 | 10 | -33% | 139 | -18% |
| sample.lua render | 344 ms | 419 | 10 | -18% | 360 | -4% |
| sample.py open | 94 ms | 175 | 10 | -46% | 124 | -24% |
| sample.py render | 323 ms | 406 | 10 | -20% | 344 | -6% |
| sample.ts open | 94 ms | 153 | 10 | -38% | 116 | -19% |
| sample.ts render | 327 ms | 407 | 10 | -20% | 347 | -6% |
| sample.json open | 107 ms | 179 | 10 | -40% | 131 | -18% |
| sample.json render | 322 ms | 445 | 10 | -28% | 347 | -7% |
| rss settled | 115 MiB | 120 | 10 | -4% | 120 | -4% |
| rss peak | 191 MiB | 194 | 10 | -2% | 194 | -1% |

| Count | Latest | Previous release | Change |
|---|---:|---:|---:|
| plugins installed | 386 | 386 | +0 |
| plugins loaded | 276 | 276 | +0 |
| config files | 1,588 | 1,576 | +12 |
| config lua lines | 141,318 | 141,036 | +282 |
| config lines | 220,560 | 172,532 | +48,028 |
| plugin lines | 2,245,426 | 2,245,426 | +0 |
