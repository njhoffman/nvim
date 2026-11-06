# Changelog

All notable changes to this Neovim configuration will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to
[Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.31.7] - 2026-11-05

### Changed

- Corrected the startup TODO items with measurements of the fixes, and added the mcphub `curl` memory bug. No config change.

## [0.31.6] - 2026-11-05

### Changed

- Replaced the "Slow startup" TODO item with five high-priority items based on new startup measurements. No config change.

## [0.31.5] - 2026-11-05

### Changed

- Added a one-line header comment to 243 files in `lua/core`, `lua/lib` and `lua/modules`. No behavior change.

## [0.31.4] - 2026-11-04

### Changed

- Formatted the config's own Lua with StyLua. No behavior change. Vendored copies are not touched.

## [0.31.3] - 2026-11-04

### Removed

- About 5,000 lines of commented-out code in blocks of 5+ lines. Disabled plugin specs moved to
  `docs/reference/commented-out-plugin-specs.md`. Short disabled options, usage notes, vendored copies and the
  in-progress `tracker` and `runner` modules are unchanged.

## [0.31.2] - 2026-11-04

### Changed

- `TODO` comments in the config's own code moved to `TODO.md` ("Ideas from old code comments") or were deleted when
  stale. Comments from upstream in vendored copies stay.

## [0.31.1] - 2026-11-04

### Fixed

- `:Telescope gitops` pickers `search_content`, `search_content_file`, `checkout_reflog`, `branches`, `diff_branch`,
  `diff_branch_file`, `diff_commit_file` and `diff_commit_line` no longer error when opened.
- Bare `:Telescope gitops` opens the menu of pickers instead of an error.

## [0.31.0] - 2026-11-03

### Changed

- `scripts/push.sh` takes 2-3 minutes instead of 6-7: it only records metrics and pushes. It no longer runs the tests or
  coverage; run tests with each change, and `scripts/coverage.sh` when you want the coverage number.
- `docs/PERFORMANCE.md` is now a trend: one row per push with plugins, files, lines, sizes, memory and benchmark times.
- A busy machine no longer records bad times. With high load at the start, or a spike during the run, a push records
  counts and sizes and leaves the times blank.
- Metrics commits are `vX.Y.Z: metrics` with a `Metrics: recorded` line, which the `pre-push` guard checks for.

### Added

- Config size and plugin directory size in `benchmarks/history.tsv`.

### Removed

- `scripts/report.sh`, `scripts/report_summary.py` and the per-push `summary.md`. Past summaries stay in the repo.

## [0.30.4] - 2026-11-03

### Changed

- Re-recorded the 0.30.3 benchmarks on a quiet machine (load 0.77, peak 0.9). The row recorded by its push was measured
  while other compile jobs pushed load past 40, showing startup ready at 3780 ms; it is 739 ms.

## [0.30.3] - 2026-11-03

### Changed

- Reran the 0.30.2 benchmarks at low load (2.47). The recorded run had a load of 4.71 and showed `small.md` and
  `sample.py` over 25% slower than average; the rerun has no warnings, so that was load and not a regression.

## [0.30.2] - 2026-11-03

### Changed

- Documented the links that let nvcat (`vt`, `vc`) use the log parser and query. nvcat itself got the `log` filetype and
  a fix for losing its colors when a followed file reloads, in its own repo.

## [0.30.1] - 2026-11-03

### Fixed

- Log files use the colors of the old nvimpager colorscheme again, such as its `logUrl` and `logLevel*` colors, which
  were not carried over. `nord-nick` now sets every `@log.*` group itself instead of linking to general groups.

## [0.30.0] - 2026-11-03

### Changed

- The release report runs when pushing, not with every commit. `scripts/release.sh` now only commits and tags, and the
  new `scripts/push.sh` runs the report for the latest tag, generates `summary.md`, commits the report files and pushes.
  A plain `git push` of main is refused by `scripts/hooks/pre-push`; `git push --no-verify` skips the check.

## [0.29.0] - 2026-11-03

### Added

- Log files are highlighted again: `*.log` and `*_log` get the `log` filetype, which Neovim doesn't assign by default,
  with a new tree-sitter parser (`parsers/tree-sitter-log`, built to `parser/log.so`). It covers dates, times, durations,
  levels in any case plus `SEVERE`/`FINE`/`FINER`/`FINEST` and the nerd-font level glyphs, strings, numbers, URLs, IPs,
  hashes, paths, domains, XML, syslog columns and Lua dump references like `<function 2>`. Colors come from the old
  nvimpager `syntax/log.vim`, as `@log.*` groups you can override. Without the parser, the runtime syntax still applies.
- `/var/log/syslog*` uses `syntax/syslog.vim` again instead of the `messages` filetype.

## [0.28.0] - 2026-11-03

### Changed

- Clipboard provider moved to `lua/core/globals/clipboard.lua`. `+` is still written at once; a tmux buffer and the
  history now come from `clipd yank` in the background, with the filetype, file, lines and operator as context and
  destinations from `~/.config/clipd/config.toml`. By default deletes (`d`, `c`, `x`) reach `+` only, no longer a tmux
  buffer, and `"*y` reaches PRIMARY only. On Claude Code's prompt file the source is `claude`. Without clipd, yanks
  still make a tmux buffer.
- Updated 37 plugins in `lazy-lock.json` and dropped `neoscroll.nvim` from it.

### Removed

- The `nixpkgs_fmt` formatter for Nix files in `lua/configs/conform.lua`, so conform no longer formats them.

## [0.27.0] - 2026-11-03

### Changed

- Shared libraries live under `lua/lib/`: `logger`, `mapper`, `lodash` and `helpers`. Require them as `lib.<name>`
  (for example `require("lib.logger").init("scope")`). The logger's reload-on-save autocommand now watches
  `lua/lib/logger/levels.lua`. `require("logger")` and `require("mapper")` still work as aliases, because the local
  convey.nvim and what-key.nvim plugins use those names.
- CLAUDE.md describes the new `core/` / `modules/` / `lib/` layout and the current `init.lua` load order, and no longer
  lists `devbox`, `hover` or `watcher` as modules of this repo.

## [0.26.0] - 2026-11-03

### Changed

- The config's own plugins-in-progress live under `lua/modules/`: `alt`, `components`, `devdocs2`, `format_cmdline`,
  `gitops`, `glyph-guard`, `jumpguard`, `oldfiles`, `registers`, `runner`, `sidebar`, `stats`, `tail`, `tmux`,
  `tracker`, `undo` and `unicode`. Require them as `modules.<name>`.
- The Markdown helpers are one module: `md_prose`, `md_backtick` and `md_codeblocks` are now `modules.markdown.prose`,
  `modules.markdown.backtick` and `modules.markdown.codeblocks`.
- The LSP entry point moved from `lua/lsp/` to `lua/core/lsp/` (`require("core.lsp")`).

## [0.25.0] - 2026-11-03

### Changed

- The config's own startup modules live under `lua/core/`: `globals/`, `keymaps.lua`, `commands/`,
  `abbreviations.lua`, `autocommands/`, `neovide.lua` and `options/`. Require them as `core.<name>` (for example
  `require("core.commands.scroll")`); the old top-level names no longer resolve.
- `user-options.lua` and `vim-options.lua` are now `core/options/user.lua` and `core/options/vim.lua`, loaded together
  by `core.options`.

### Removed

- `lua/config.lua` and `lua/settings.lua`, leftovers of the Packer-era setup that nothing loaded. They are in
  `~/.local/backup/nvim/lua/`.

## [0.24.0] - 2026-11-03

### Added

- Markdown: `yiC` yanks every fenced code block in the buffer without its fences, and `yaC` yanks them with their
  fences and language line. Blocks are separated by one blank line, the shared indent of blocks nested in list items
  is removed, and empty blocks are skipped. The text goes to the unnamed, `0` and `+` registers. `yic` / `yac` still
  yank the block under the cursor.

## [0.23.1] - 2026-11-02

### Changed

- Save-and-quit (normal, insert, visual, select) and save from the command line are on `<M-s>` instead of
  `<M-S>`, matching Alacritty's Ctrl+Shift+S, which now sends Alt+s.
- Workspace diagnostics (LSP buffers) and Telescope's launch-pickers key are on `<M-t>` instead of `<M-T>`:
  Alacritty's Ctrl+Shift+T now sends Alt+t, and tmux passes it to Neovim. tmux also passes Alt+i and Alt+o
  through now, so the existing `<M-i>` (messages) and `<M-o>` (only window) mappings work inside tmux.

## [0.23.0] - 2026-11-01

### Removed

- The vendored copy of plenary.nvim in `lua/plenary/` (60 files, 500K). It shadowed the installed plugin, so plenary
  updates never took effect; the config and the test runner now use the plugin from lazy. The copy only carried this
  config's deprecated-API rewrites, so plenary's own deprecation notices (`nvim_buf_set_option`, `vim.loop`, ...) can
  show up again in `:checkhealth vim.deprecated`. It is in `~/.local/backup/nvim/lua/plenary/`.

## [0.22.0] - 2026-11-01

### Changed

- Markdown notes and keymap dumps moved from `doc/` and `lua/` into `docs/reference/` and are indexed in
  `docs/README.md`: Neovim's default keymaps and this config's keymap dump (`keymaps/`), the smoothie port spec,
  benchmarking and notes (`smoothie/`), the ColorschemeExport guide, bars components, vimade notes, ultimate-autopair
  notes, the escape module's help text and old vim mapping notes. `doc/` now holds only vim help files, and
  `doc/helpfiles/` stays as the source of `:HelpExport`.

### Removed

- The old task prompts in `doc/specs/` (Silence command, feline -> lualine/windline migration, repo setup), now done
  or outdated. The still-open ExportColorscheme follow-ups are tracked in TODO.md ("Highlight exporters").
- `doc/smoothie_benchmarking.md` and `doc/helpfiles/fzf-notes.txt`, exact copies of other files. Both are in
  `~/.local/backup/nvim/`.

## [0.21.0] - 2026-11-01

### Removed

- 27 disabled plugin specs (ui.nvim, incline, zone, cinnamon, neoscroll, visual.nvim, mini.clue, anyline, nvim-ufo,
  tailwind-sorter, ChatGPT.nvim, NeoZoom, sunglasses, wildfire, accelerated-jk, portal, stopinsert, smear-cursor,
  ed-cmd, feed.nvim, telescope-git-submodules, vim-wakatime, nxwm, trailblazer, fzfx, orgmode, headlines) and their
  configs. The removed spec text is kept in `~/.local/backup/nvim/lua/plugins/removed-disabled-specs.lua`.
- 87 configs in `lua/configs/` that match no plugin spec and are required by nothing (e.g. `nvim-lsp-installer`,
  `kommentary`, `nvim-tree`, `wilder`, `stabilize`, `luasnip`, `dap/`, `tmp/`), and 10 unreferenced `*-example` /
  `reference` files.
- 275 Lua modules that nothing requires, among them the old `colorschemes/nord-nvim/` (replaced by `nord-nick`),
  unused `utils/`, `stats/`, `tracker/` and `notifications/` modules, unloaded hydra, codecompanion and chrome-remote
  submodules, and `lua/llm-config.lua`.
- Everything removed is moved to `~/.local/backup/nvim/` under its repo path, so restoring a file is a single `mv`.

### Changed

- lualine, windline, quicknote and markpan stay disabled on purpose; their specs say why.
- reactive.nvim no longer pulls in smear-cursor as a dependency (smear-cursor was never loaded: its spec had
  `cond = false`).

## [0.20.2] - 2026-11-01

### Fixed

- Saving css, scss, less, sass, graphql, handlebars, html, json, yaml, JavaScript/TypeScript and vue files never ran
  prettier: the config overrode conform's prettierd formatter without passing the file, so it ran and changed nothing.
  The overrides are gone and these files are formatted on save with your prettier config (`~/.prettierrc.yml`, or the
  project's own); `:FormatDisable` turns it off. The `--print-width` and `--plugin` options they tried to pass are
  dropped because prettierd ignores CLI options: imports are no longer meant to be organized on save, and toml is
  formatted by taplo only.
- The Python test summary went to the report's progress log instead of `tests.log`.

## [0.20.1] - 2026-11-01

### Changed

- Releases commit only each report's `summary.md`; the raw report data (`coverage.txt`, `tests.log`, cloc JSON, bench
  and progress logs, about 27k lines per release) is gitignored and stays local. The 108 raw files already in the repo
  were untracked.
- A benchmark baseline is recorded (load 0.95, 10 sessions), so `docs/PERFORMANCE.md` compares each release against it.

### Fixed

- `docs/PERFORMANCE.md` described the baseline as "1 sessions": it took the session count from a count metric's row
  instead of the measured ones.

## [0.20.0] - 2026-11-01

### Changed

- `scripts/run_tests.sh` runs unit spec files in parallel, one Neovim each (`TEST_JOBS`, default the CPU count), and
  prints a `progress:` line per finished spec file with its time, plus the first failing test. With coverage, each spec
  file writes its own stats file and `scripts/luacov_merge.lua` adds them up: the coverage run went from about 14 to
  under 5 minutes with the same coverage. `TEST_TIMEOUT` limits each spec file (120 s, 900 s with coverage).
- `scripts/report.sh` shows its progress as it runs: each phase with its duration, the spec file lines, the coverage
  total and the benchmark's load waits and sessions. The plugin tree's cloc is cached by `lazy-lock.json`, which saves
  1.5-3 minutes when plugins haven't changed.
- `scripts/run_tests.sh scripts` runs the new bats tests in `tests/scripts/` (also part of `all`).

### Fixed

- A failed report kept nothing to debug with: it now moves the report to `.reports/failed/<timestamp>/` (gitignored)
  with `tests.log` and `bench.log`, and prints timeouts as well as failing tests.

## [0.19.0] - 2026-11-01

### Added

- Markdown hard wrapping stays consistent:
  - saving reflows prose with prettierd, at the width from `~/.prettierrc.yml` (120, `proseWrap: always`) or a project's
    own prettier config;
  - typing wraps at `textwidth` even on a line that was already longer (`formatoptions` no longer has `l`);
  - `J` joins lines and reflows the paragraph, keeping the cursor at the join point; in code blocks, tables and headings
    it only joins.

### Changed

- The repo's Markdown docs were reflowed once to the new width, so later diffs don't carry the reflow.
- Paths moved with the shell config: the greek-gods name list is read from `~/.shell/share/greekgods.txt` (dashboard
  loader and its test), and comments point to `~/.shell/scripts/` for `asynctask` and `wshada.sh`.

### Fixed

- tailwind-sorter's node path pointed at an asdf shim that no longer exists; it now uses `exepath("node")`.

## [0.18.0] - 2026-11-01

### Added

- In Markdown, `` ` `` in visual mode toggles backticks around the selection and keeps it selected:
  - a selection within one line becomes an inline code span;
  - a linewise selection, or one spanning lines, gets a ``` fence around the whole lines, indented like its first line
    (so code inside list items stays in the item);
  - on a selection that is already a code span or fenced block, it removes that wrapping (backticks inside the code are
    kept); otherwise, if the selection contains backticks, it removes all of them, including fence lines. Unwrapping
    shows a notification, and pressing `` ` `` again wraps normally.

## [0.17.2] - 2026-11-01

### Fixed

- Markdown indented by 4 spaces, so `>` / `<` on list items moved them two levels at once: Neovim's markdown ftplugin
  applied its "recommended style" (`shiftwidth=4`). It's turned off, so Markdown uses the global 2.

## [0.17.1] - 2026-11-01

### Fixed

- Opening Markdown files no longer blocks the editor for seconds: the scrollbar (satellite) measured wrapped and
  concealed text with `nvim_win_text_height`, which ran the treesitter highlighter over the whole buffer. It now counts
  rows (closed folds count once). Render times in `benchmarks/run`: large.md 5058 -> 423 ms, code.md 3007 -> 574 ms,
  medium.md 1136 -> 436 ms, small.md 645 -> 386 ms. In soft-wrapped prose the bar can sit slightly off.
- The scrollbar's row count found closed folds one line off.

## [0.17.0] - 2026-11-01

### Added

- `lua/tmux/pane_flag.lua` (loaded from `plugin/tmux_pane_flag.lua`): inside tmux, Neovim sets the pane option
  `@pane-is-vim` while it holds the terminal (set on start and resume, cleared on suspend and exit). The tmux config
  (0.19.0) reads it to decide whether alt-hjkl and ctrl-hjkl go to Neovim, instead of running `ps` on every keypress, so
  held resize keys no longer queue up under load. Headless Neovim and Neovim in another Neovim's `:terminal` leave the
  flag alone.

## [0.16.3] - 2026-11-01

### Fixed

- A deleted file buffer that you return to (jumplist, `<C-o>`, `:buffer`, a picker) is listed again, so it shows in the
  tabline.

### Added

- `lua/jumpguard`: records buffer deletions and appends a report to `~/.local/state/nvim/jumpguard.log` whenever a
  deleted buffer is entered again or a jumplist jump fails (jumplist around the cursor, the deletion, the last
  messages), to catch the "buffer not found" error on `<C-o>`.

## [0.16.2] - 2026-11-01

### Fixed

- In buffers with an LSP attached, `<C-t>` and `<M-T>` opened Snacks diagnostics pickers instead of telescope: the LSP
  attach handler bound them buffer-locally, which shadowed the global telescope mapping. `<C-t>` now opens telescope
  diagnostics for the current buffer and `<M-T>` for the workspace.
- The global `<C-t>` mapping was labeled "frecency files" although it opens diagnostics.

## [0.16.1] - 2026-11-01

### Changed

- `lazy-lock.json` is tracked, so every release tag pins the plugin versions it shipped with. Restore an older release's
  plugins with `git checkout vX.Y.Z -- lazy-lock.json` and `:Lazy restore`.
- `TODO.md` review: added a hardcoded home paths item, and more detail on the report.sh timeout and on root clutter.
- Removed four one-off Claude Code allow rules from `.claude/settings.local.json` whose literal `*` was read as a
  wildcard, which caused warnings at startup.

## [0.16.0] - 2026-11-01

### Added

- Startup and rendering benchmarks, recorded with every release: `benchmarks/run` drives Neovim through an attached UI
  and times startup (first screen and fully idle), plus open and render times for Markdown in four sizes, Lua, Python,
  TypeScript and JSON. Render time counts the time the editor stays blocked after `:edit` returns. `docs/PERFORMANCE.md`
  shows the latest release against the average of the previous 10 releases and against a baseline taken under low load
  (`benchmarks/run --baseline`), plus plugin, file and line counts. See `benchmarks/README.md`.
- `scripts/report.sh X.Y.Z` runs the benchmarks after the tests and records them as release X.Y.Z (`BENCH=0` skips
  them); `scripts/run_tests.sh python` runs the harness's unit tests, which are also part of `all`.

### Changed

- cloc statistics exclude the generated `benchmarks/fixtures/`.

## [0.15.1] - 2026-10-31

### Fixed

- tmux navigation no longer logs "window_layout returned no valid panes" when moving out of Neovim into another tmux
  pane. tmux next-3.9 prints `#{window_layout}` as JSON, and `tmux.layout.parse` now reads it alongside the classic
  `WxH,x,y,id` format, so border detection works again.

### Added

- JSON layout cases in `tests/unit/tmux_layout_parse_spec.lua`.

## [0.15.0] - 2026-10-21

### Fixed

- action-hints no longer throws "index out of range" from `vim.range` when a visual selection starts or ends on an empty
  line; the code action range now comes from `getregionpos()`.

### Added

- `docs/` for reference material and specs, separate from `doc/` (vim help files): the deprecated API migration record,
  the custom dashboard spec and the hlslens templating notes, all moved out of `TODO.md`.
- `tests/unit/action_hints_codeactions_spec.lua` covering selection ranges on empty lines.

### Changed

- `TODO.md`: every item now has a title, priority and category (bug, feature, refactor, docs, test, chore, perf). New
  projects: 6 Bugs, 7 Docs and code consistency, 8 Editing behavior, 9 Integrations plugin, plus a report-size item in
  project 5.

## [0.14.2] - 2026-10-20

### Changed

- `TODO.md`: items now carry priorities read by `todo-status`, `/todo` and `todo-fzf` (same `(p1)` / `(p3)` /
  `(due YYYY-MM-DD)` tags as `~/.shell`). P1: shadowed plugin modules and tracking `lazy-lock.json`. 11 cleanup and
  tooling items are P3; the other 12 stay P2.

## [0.14.1] - 2026-10-20

### Changed

- `tests/unit/colorscheme_export_spec.lua` and `tests/manual/test_colorscheme_export.lua`: `nvim_buf_get_option` ->
  `nvim_get_option_value`. These were rewritten in v0.13.0 but left out of that commit.

## [0.14.0] - 2026-10-20

TODO item 1 (deprecated Neovim APIs) is complete for the config repo.

### Added

- `lua/utils/hl.lua`: `add_highlight()`, an extmark-based replacement for `nvim_buf_add_highlight` with the same
  contract:
  - `col_end = -1` highlights to end of line
  - namespace 0 or -1 maps to a shared namespace
  - out-of-range columns are clamped
  - the namespace id is returned

  Tests are in `tests/unit/utils_hl_spec.lua`.

- `tests/unit/deprecated_api_spec.lua`: fails on any use of a deprecated or removed Neovim API in `lua/`, `after/`,
  `plugin/` or `ftplugin/` (comments are ignored), listing each file and line.

### Changed

- `nvim_buf_add_highlight` -> `utils.hl.add_highlight`: 27 Lua sites, plus 7 VimL sites via `v:lua`
- `nvim_get_hl_by_name` -> `nvim_get_hl` (devicons, satellite search handler); a missing group now returns `{}` instead
  of raising
- `vim.diagnostic.goto_next` / `goto_prev` -> `vim.diagnostic.jump` with `float = true`, which keeps the old float
  default
- Table-form `vim.validate{}` -> `vim.validate(name, value, validator, optional)`: 16 sites. Short type names (`'f'`)
  are expanded, since the new form rejects them.
- Old-signature `vim.str_utfindex(s[, i])` -> explicit `"utf-32"` encoding
- `nvim_exec` -> `nvim_exec2`
- Dropped dead `vim.fn.has("nvim-0.8".."0.12")` guards and their legacy branches (qf ftplugin, telescope plugin,
  helpview, feline, live-command, mini.comment/surround, egrepify, recall, nvim-scissors, matchup hl-info)

### Fixed

- `project_nvim`: the `vim.lsp.start_client` monkey-patch never ran for clients started by `vim.lsp.start` /
  `vim.lsp.enable`, and it returned `nil` to callers. It is now an `LspAttach` autocmd, so the project root is actually
  recalculated when an LSP attaches.
- `:Silence` / noice silence toggle: restarting LSP clients passed client objects (or a list) to `start_client`; now
  uses `vim.lsp.start(client.config)` per client
- `tint` highlights required `nvim-treesitter.ts_utils`, which doesn't exist on the nvim-treesitter `main` branch;
  ported `get_vim_range` locally
- `lsp/diagnostics.lua`: `not vim.fn.has(...)` was always false (0 is truthy in Lua); the dead legacy sign branch was
  removed
- `gitops` LSP format helpers: removed fallbacks to the removed `vim.lsp.buf.formatting` / `formatting_sync`
- Vendored plenary popup: a broken `nvim_set_option` format string (unquoted option name) now uses
  `nvim_set_option_value("wrap", ...)`

### Linked `~/git` repos (committed locally, not pushed)

- nvim-cmp, nvim-notify, noice.nvim: explicit encodings for `vim.str_utfindex`. This removes the runtime deprecation
  warnings from nvim-notify.
- nvim-navbuddy, convey.nvim: `nvim_buf_add_highlight` -> extmarks
- nvim-cmp, nvim-notify, ultimate-autopair, nvim-navbuddy, telescope: `vim.loop` -> `vim.uv` and the other mechanical
  renames. telescope gets `vim.uv` only, to stay within its CI floor of v0.10.4.

## [0.13.0] - 2026-10-19

### Fixed

Calls to APIs already removed from Neovim v0.13.0-dev (they raised errors when reached):

- `vim.lsp.get_active_clients()` / `vim.lsp.buf_get_clients()` -> `vim.lsp.get_clients()` (14 sites: feline providers,
  stats panels, LSP notifications, workspace-diagnostics, python ftplugin, text-case)
- `vim.lsp.util.jump_to_location()` -> `vim.lsp.util.show_document()` in definition-or-references
- `vim.diagnostic.disable()` / `is_disabled()` and the old `enable(bufnr)` signature ->
  `vim.diagnostic.enable(bool, filter)` / `is_enabled()` in the hydra toggles and the mapper keymap
- `vim.lsp.buf.formatting()` -> `vim.lsp.buf.format()`
- `vim.treesitter.query.get_node_text()` -> `vim.treesitter.get_node_text()` (vue ftplugin, snippets-utils)
- `client.supports_method(...)` -> `client:supports_method(...)`

### Changed

Mechanical replacements of deprecated APIs (302 call sites, 174 files), done with an argument-aware rewriter that skips
comments and strings:

- `vim.loop` -> `vim.uv` (144)
- `nvim_buf_*_option` / `nvim_win_*_option` -> `nvim_get_option_value` / `nvim_set_option_value` with `{ buf = }` /
  `{ win = }` (108)
- `nvim_get_option` / `nvim_set_option` -> `*_option_value` with `{ scope = "global" }`, which keeps the global-only
  semantics (9)
- `nvim_err_writeln(msg)` -> `nvim_echo({ { msg } }, true, { err = true })` (27)
- `vim.tbl_flatten(t)` -> `vim.iter(t):flatten(math.huge):totable()` (13). `dumb_jump` and `egrepify` get a local helper
  with `tbl_flatten`'s exact semantics, because their argument lists can contain `nil` holes.
- `vim.highlight.*` -> `vim.hl.*`, `vim.tbl_islist` -> `vim.islist`
- Aliased references (`local bufOpt = vim.api.nvim_buf_get_option` etc.) replaced with equivalent wrappers

### Known issues

- 8 files already failed to parse before this change: `stats/commands/*/init.lua` (5), `configs/feline/reference.lua`,
  `configs/none-ls/services.lua` and `scratch/tmpactions.lua`. They are orphan candidates for TODO item 2.

## [0.12.1] - 2026-10-19

### Added

- Claude Code `SessionStart` hook (`.claude/hooks/todo-reminder.py`, registered in `.claude/settings.local.json`). On
  each new session it shows a one-line count of open `TODO.md` items per section, and passes the full list to Claude as
  context so it can remind you and ask what to work on.

## [0.12.0] - 2026-10-19

### Added

- `scripts/smoke.lua`: headless smoke test of the full config.
  - Runs startup and VeryLazy, then opens a sample file for each common filetype.
  - Optionally force-loads plugins (`SMOKE_PLUGINS=a,b` or `all`) and adds healthcheck sections (`SMOKE_HEALTH`).
  - Records `vim.deprecate` calls and WARN/ERROR notifications, and runs `:checkhealth vim.deprecated`.
  - A watchdog answers blocking prompts.

### Fixed

Breaking changes and errors from the plugin update (`plugin_udpates.txt`), verified headless with all 404 plugins
loaded:

- **Removed upstream repos**: dropped `telescope-changes`, `telescope-command-palette`, `telescope-ports` (LinArcX) and
  `telescope-docker` (lpoto), along with their extension configs
- **yazi.nvim**: re-cloned after the interrupted update left a corrupt submodule
- **rest.nvim rock**: system luarocks 3.8 can't load the `treesitter-parser` build backend, so the `tree-sitter-http`
  rock was pre-installed into `lazy-rocks/rest.nvim` with the backend on `LUA_PATH`. Lazy then built rest.nvim normally.
  Hererocks was tried first and also fails to load that backend.
- **oxocarbon.nvim**: `build = false`; its rockspec needs fennel, which fails to build on Lua 5.1 (prebuilt `lua/` ships
  with the plugin)
- **E201 on first file open**: indent-blankline lazy-loads on `BufReadPost` instead of `BufReadPre`. Loading it inside
  `BufReadPre` changed the current buffer.
- **cmp-git**: callback `trigger_actions` migrated to named `actions`
- **codecompanion v20**:
  - removed the unsupported `mini_diff` diff provider
  - dropped the obsolete `interactions.inline.keymaps` (diff keymaps now live in `shared.keymaps`)
  - `:CodeCompanionShare` uses `chat.context:add` with `opts.sync_all` and the `interactions.*.builtin.file` source
- **octo**: `file_panel.use_icons` -> `file_panel.icons`; `timeline_indent` is a number
- **undotree**: keymaps use the `{ [action] = lhs }` format
- **sshfs.nvim**: `ui.file_picker` -> `ui.local_picker`
- **nvim-dap-view**: `windows.height` -> `windows.size`; removed the unsupported `terminal.start_hidden`, in both the
  spec opts and `configs/nvim-dap-view.lua`
- **competitest**: removed `runner_ui.viewer.close_mappings`; viewer close keys come from `runner_ui.mappings.close`
- **nvim-rip-substitute**:
  - `keymaps.confirm` -> `confirmAndSubstituteInBuffer`
  - `keymaps.insertModeConfirm` -> `insertModeConfirmAndSubstituteInBuffer`
  - `rangeBackdrop` -> `rangeBackdropBrightness`

### Changed

- **kulala.nvim replaced with rest.nvim (v3)**:
  - kulala moved to a new org and its tooling now requires a license token; `.http` buffers prompted for it on open
  - `configs/rest.lua` rewritten for the v3 API (`vim.g.rest_nvim`, `:Rest ...`)
  - `:RESTRun`, `:RESTRunLast` and `:RESTPreview` kept as aliases (results open in a vertical split)
  - Removed the orphaned v1-era `configs/rest-nvim.lua`
- **avante.nvim**: added its new required dependencies `ColinKennedy/mega.cmdparse` and `mega.logging`; avante failed to
  load without them
- `vim.F.if_nil` -> `vim.nonnil` across 30 in-repo files, including the vendored `lua/plenary/` (deprecated, removal in
  Nvim 0.15)
- `vim.validate{}` table form -> `vim.validate(name, value, validator)` in `live-command/config_validator.lua` and
  `mini/surround/Config.lua`

## [0.11.1] - 2026-10-19

### Added

- `TODO.md` roadmap:
  - deprecated Neovim API inventory, with hit counts and replacements, after the v0.13.0-dev-1915 update
  - orphaned module and config candidates
  - folder and config simplification
  - custom dashboard spec to replace alpha-nvim
  - additional suggestions (track `lazy-lock.json`, CI, coverage speed and targets, startup budget, health check)
- Existing hlslens and Snacks notes kept under "Existing notes"

## [0.11.0] - 2026-10-19

### Added

- **Release tooling**: `scripts/report.sh` (tests with coverage, cloc stats into `.reports/<timestamp>/`) and
  `scripts/release.sh` (semver-guarded commit, annotated tag, `push --follow-tags`)
- **Test coverage**: `NVIM_COVERAGE=<statsfile>` enables luacov in `tests/minimal_init.lua`; `run_tests.sh` runs specs
  sequentially with a longer timeout in that mode
- Refactoring Telescope extension (`lua/telescope/_extensions/refactoring.lua`)

### Changed

- `configs/refactoring.lua`, `neovide.lua`, `vim-options.lua`, nvim-cmp sources and `configs/convey.lua` reworked
- `notifications/recipes/command.lua`: StyLua formatting; mpc recipe sources `~/.aliases/shell/audio.sh`
- Large cleanup across `configs/`, `telescope/`, `gitops/`, `scrollview/`, `scrollbar/`, `glyph-guard/` (233 files, -28k
  lines)

### Removed

- `lua/notify/_demo/`, `lua/notify/_render/`, `lua/notify/render/_*` and `lua/notify/util/render.lua` (unused notify
  demo and renderer copies)
- `tmp.sh` and `luacov.stats.out` from version control (now ignored)

### Fixed

- `bars_statusline_spec` theme test still expected 6 themes after `feline` was added in v0.9.0
- Pre-commit report referenced nonexistent `~/.nvim`; cloc now targets the config directory
- `quickclose_spec` reads the command `desc`; newer Neovim returns an empty `definition` for Lua callbacks

## [0.10.0] - 2026-04-15

### Changed

- **Logging consolidation**: Merged `lua/structlog/` and `lua/debuglog/` under `lua/logger/` as subdirectories
  - `lua/structlog/` -> `lua/logger/structlog/` (structured logging framework, 19 files)
  - `lua/debuglog/` -> `lua/logger/debug/` (inspect, dump, traceback, timer, namespace helpers; 15 files; dropped
    `globals.lua` and `test.lua` as superseded)
  - Internal requires rewritten to use new paths; zero consumers outside `lua/logger/` reference the old paths
  - Updated 11 consumers to new paths: `logger/{init,sinks,parsers,notify}.lua`, `watcher/logger.lua`,
    `tracker/{init,au_events}.lua`, `configs/chrome-remote/scratch.lua`, `import/benchmarks/commands.lua`
  - Removed 4 dead `require("debuglog")` imports in `import/benchmarks/variables.lua`,
    `import/ui/{init,lines,summary}.lua` (imported but never used)

- **Registers module refactor** (v0.10.0 scope, moved from v0.9.0 in-progress work):
  - Fade state in `fade_controller` with scenario-aware levels, buffer-variable sync, relative values
  - `range_hl` decoration provider for per-range restoration and color transforms
  - `color_math` HSL transform pipeline + derived highlight cache
  - 23 new tests in `tests/unit/registers_spec.lua`

### Removed

- **Dead code in `lua/globals/`**:
  - `lua/globals/modules/` (entire directory): `buffers.lua` had a broken load-time `vim.dbglog()` side-effect,
    `filter.lua` / `format.lua` / `utils.lua` / `windows.lua` were stubs or broken
  - `lua/globals/overrides.lua` (unreferenced), `preload.lua` (standalone `/tmp/nvim-preload.log` system, never wired
    in), `record-events.lua` (only referenced in a commented-out line)
  - Unused `N` and `D` globals from `globals/init.lua` (scan showed zero usage)
  - Commented-out code blocks in `globals/init.lua`

- **`lua/structlog/`** (moved to `lua/logger/structlog/`)
- **`lua/debuglog/`** (moved to `lua/logger/debug/`, minus `globals.lua` and `test.lua`)

### Fixed

- **`logger/debug/timer.lua`**: Fixed two latent bugs discovered during the move
  - `finished[_]` used global lodash table as key instead of string `"_"`
  - `stop_time(anon_timer, vim.loop.hrtime())` passed timestamp as `name` parameter
  - Function now also returns the elapsed time (previously side-effect only)

- **Registers key-binding crash with scrolloff=0**: `upwards()` / `backwards()` no longer exit early when cursor is at
  window top but buffer has content above (fixes `winline <= 1` guard)

### Modernized

- `vim.loop.hrtime()` -> `(vim.uv or vim.loop).hrtime()` in `logger/debug/timer.lua`
- `vim.loop` fallback via `vim.uv or vim.loop` in `logger/structlog/{formatters/sinks,sinks/rotating_file}.lua`

### Added

- **`tests/unit/logger_spec.lua`** — 23 tests covering scope management, level filtering, sinks, debug helpers,
  `:LogScopes` command, structlog API smoke, globals integration

### Project Statistics

| Metric               | Value                                                                               |
| -------------------- | ----------------------------------------------------------------------------------- |
| Total Tests          | 33 test files, 372 tests (355 unit + 17 integration; 1 pre-existing fail unrelated) |
| Total Plugins        | 380 installed plugins                                                               |
| Config Lines of Code | 285,454 lines (Lua/Vim)                                                             |
| Plugin Lines of Code | 1,640,391 lines                                                                     |

---

## [0.9.0] - 2026-03-29

### Added

- **Vimade fade controller** (`lua/configs/vimade/fade_controller.lua`): State management layer for per-buffer fade
  levels
  - Scenario-aware fadelevel function: cmdline (0.2), split (0.6), popup (0.6), configurable per scenario
  - Public API: `fade(bufnr, level, source)`, `unfade(bufnr)`, `get(bufnr)`, `fadetint(bufnr, level)`
  - Relative fade values: `"+0.2"`, `"-0.1"` syntax applied against current level, clamped to [0, 1]
  - Buffer variable sync: `vim.b.fadelevel` and `vim.b.fade_source` updated on every mutation
  - Forces immediate vimade update on API calls (bypasses 500ms polling)
  - User commands: `:VimadeFade [bufnr] [level] [source]`, `:VimadeUnfade [bufnr]`

- **Per-range highlight module** (`lua/configs/vimade/range_hl.lua`): Decoration provider for range-level highlight
  control
  - `restore_range(bufnr, start, col, end, col)`: Restore original highlights in a faded buffer range
  - `transform_range(bufnr, start, col, end, col, transforms)`: Apply color transforms to a range
  - Visual mode auto-restore with 50ms delay (shows original colors for visual selection in faded buffers)
  - Uses `nvim_set_decoration_provider` with ephemeral extmarks (same approach as snacks.dim)
  - Treesitter + extmark highlight source extraction for accurate per-token restoration

- **Color math module** (`lua/configs/vimade/color_math.lua`): HSL color transforms with derived highlight caching
  - `lighten(color, amount)`, `darken(color, amount)`, `saturate(color, amount)`, `hue_shift(color, degrees)`
  - RGB-HSL conversion utilities
  - `apply_transforms(color, {lighten=0.2, darken=0.1, saturate=0.3, hue=90})` composable pipeline
  - Derived highlight cache keyed by `group:transform`, cleared on ColorScheme change
  - Imports vimade's bitwise color utilities for base operations

- **Benchmark suite** (`lua/configs/vimade/bench.lua`): 7-scenario comparison of fade/tint approaches
  - Vimade tick cost, custom namespace clone+fade, decoration provider cost, combined
  - tint.nvim setup cost (namespace generation), tint.nvim hot path (O(1) namespace swap)
  - Color math head-to-head: vimade bitwise vs tint.nvim string-based pipeline (per-color ns timing)
  - Namespace stats tracking (total count, highlights per ns, vimade/tint-specific counts)
  - Run with `:lua require("configs.vimade.bench").run()`

- **Performance analysis notes** (`lua/configs/vimade/NOTES.md`): Detailed comparison of vimade vs tint.nvim
  architectures

### Changed

- **Vimade config**: Replaced flat `fadelevel = 0.45` with `fade_controller.make_fadelevel(cfg)` for scenario-aware
  fading
- **Vimade minimalist style**: Moved CursorLineNr/LineNr/Scrollbar/Satellite groups to LOW_VISIBILITY_NAMES, set
  low_visibility_fadelevel to 0.5
- **Vimade init**: Added BufDelete cleanup autocmd, visual restore setup, VimadeFade/VimadeUnfade commands
- **Vimade utils**: Removed old fadelevel function and get_active_info (replaced by fade_controller)

### Fixed

- **VimadeUnfadeAll command**: Fixed reference to undefined `M` variable (was `M.vimade_unfade_global()`, now
  `v_utils.vimade_unfade_global()`)
- **VimadeInfo command cleanup**: Wrapped `nvim_del_user_command` in pcall to avoid error on first load

### Project Statistics

| Metric               | Value                                                |
| -------------------- | ---------------------------------------------------- |
| Total Tests          | 25 test files, 304 tests (287 unit + 17 integration) |
| Total Plugins        | 377 installed plugins                                |
| Config Lines of Code | 284,472 lines (Lua/Vim)                              |
| Plugin Lines of Code | 276,274 lines                                        |

---

## [0.8.0] - 2026-03-28

### Added

- **hover.nvim plugin** (`~/git/hover.nvim`): Extracted hover and devbox modules into standalone plugin
  - Multi-provider floating window system with tab navigation
  - 9 hover providers: lsp-hover, lsp-signature, lsp-definition, lsp-type-definition, help, man, dictionary, syntax,
    GitHub issues
  - Commands: `:Hover`, `:HoverCursor`, `:HoverSticky`, `:HoverInspect`, `:HoverClose`
  - `cursor_delay` / `sticky_delay` config for independent timing control
  - Devbox inspection panel integrated as `:HoverInspect`
  - 102 tests (49 hover + 53 devbox)

- **Devbox provider system**: Dynamic provider filtering with `enabled` functions
  - LSP providers: hover, definition, signature, completion, codeAction
  - Conditional providers: man (shell filetypes), help (lua filetype), LSP (capability check)
  - Two-pass execution for correct batch timing
  - Dynamic popup sizing based on active providers
  - Right-aligned provider names with calculated max width

### Changed

- **Devbox display**: Formatting now owned by display layer (time + padded name + detail)
  - Provider names right-aligned to longest active name
  - Progressive title: `N/M finished` updates as each handler completes
  - Batch timing scoped to active providers only

### Removed

- **nvim-treesitter.ts_utils dependency**: All references replaced with builtins or inlined functions
  - `get_node_at_cursor()` replaced by `vim.treesitter.get_node()`
  - `get_vim_range`, `highlight_node`, `highlight_range` moved to shared `utils/treesitter.lua`
  - `swap_nodes` inlined into selectease
  - Fixed broken references in `vue.lua`, `devbox/handlers/treesitter.lua`

- **Local hover/devbox modules**: Migrated to `~/git/hover.nvim` plugin, loaded via lazy.nvim

### Fixed

- **Deprecated function cleanup** across hover and devbox:
  - `vim.lsp.get_active_clients()` -> `vim.lsp.get_clients()`
  - `vim.lsp.util.trim_empty_lines()` -> `vim.tbl_filter`
  - `vim.lsp.util.make_position_params()` -> explicit `offset_encoding` parameter
  - `vim.lsp.buf_request()` -> `client:request()` (avoids dev-tools.nvim handler conflicts)
  - `nvim_buf_add_highlight()` -> `nvim_buf_set_extmark()` with `hl_group`
  - `require("nvim-treesitter.parsers")` -> `pcall(vim.treesitter.get_parser)`
  - `require("vim.treesitter.highlighter")` -> `vim.treesitter.highlighter`
  - `vim.loop` -> `(vim.uv or vim.loop)`
  - `nvim-treesitter-playground.internal.clear_highlights` -> `nvim_buf_clear_namespace`

- **LSP handler bugs**: Fixed operator precedence in provider targeting, codeAction params (range vs position)
- **Devbox man handler**: Fixed duplicate `done()` calls (missing returns)
- **Devbox state**: Fixed `heigt` typo, `state.base_bufnr` -> `state.source.bufnr`

### Project Statistics

| Metric               | Value                                                      |
| -------------------- | ---------------------------------------------------------- |
| Total Tests          | 22 test files, 250 tests (config) + 102 tests (hover.nvim) |
| Total Plugins        | 378 installed plugins                                      |
| Config Lines of Code | 280,414 lines (Lua/Vim)                                    |
| Plugin Lines of Code | 276,719 lines                                              |

---

## [0.7.0] - 2026-03-16

### Removed

- **Telescope shadow file cleanup**: Moved 25 stale plugin shadow files from `lua/telescope/` to
  `~/.local/backup/telescope/`
  - Removed `config.lua` that shadowed plugin's config (caused startup errors after upstream merge deleted
    `telescope.deprecated` module)
  - Removed 5 underscore-prefixed directory copies: `_actions/`, `_builtin/` (6 files), `_finders/` (3 files),
    `_pickers/` (2 files), `_previewers/` (5 files)
  - Removed 7 standalone unreferenced files: `__.lua`, `_config.lua`, `_command.lua`, `_from_entry.lua`,
    `_make_entry.lua`, `_pickers.lua`, `issues.txt`
  - Kept: `run.lua`, `telemap.lua`, `telethemes.lua`, `log.lua` (custom functionality), `_extensions/init.lua` (custom
    enhancements), `_layouts/` (custom layouts)

- **Telescope config cleanup**: Moved 22 unused config files from `lua/configs/telescope/` to
  `~/.local/backup/nvim-refactor/`
  - Entire `pickers2/` directory (10 experimental pickers: code-action, command-palette, glance, harpoon, marks, mind,
    nvim-tree, ollama, terminal, timetracker)
  - 12 standalone files: `backdrop.lua`, `symbol_highlights.lua`, `filename-first.lua`, `layout-fused.lua`,
    `minimal.lua`, `sorters.lua`, `_which_key.lua`, `launchkeys.lua`, `reference.lua`, `stickybuf.lua`,
    `display-path.lua`, `previewers/delta.lua`
  - 2 unused entry makers: `entry_makers/file.lua`, `entry_makers/quickfix.lua`
  - 2 unused actions: `actions/directory.lua` (empty), `actions/reference.lua`

- **Dead code removal**: Removed ~377 lines of commented-out/unused code from active config files
  - `init.lua`: unused requires, dead functions, commented-out autocmd blocks
  - `extensions.lua`: 8 commented-out extension configs, unused `telescope` require
  - `pickers.lua`: commented-out option blocks, symbols_highlights blocks
  - `mappings.lua`: 67-line LazyVim example keymaps

### Fixed

- **Startup error**: Fixed `telescope.deprecated` module-not-found error after upstream merge by removing stale shadow
  `config.lua`

### Project Statistics

| Metric               | Value                                  |
| -------------------- | -------------------------------------- |
| Total Tests          | 11 test files, 132 tests (132 passing) |
| Total Plugins        | 378 installed plugins                  |
| Config Lines of Code | 204,063 lines (Lua/Vim)                |
| Plugin Lines of Code | 2,037,917 lines                        |

---

## [0.6.0] - 2026-03-09

### Removed

- **Unreferenced module cleanup**: Moved 29 unreferenced lua modules to `~/.local/backup/nvim-refactor/`
  - 12 top-level dead modules: `evaluate`, `formatter-nvim`, `keyutils`, `layouts`, `oputils`, `random-colorscheme`,
    `shebang`, `splitter`, `test_runner`, `tmp-dap`, `tmpts`, `unicode`
  - 5 unused utils: `autofunc`, `blink_animate`, `bufopt`, `chainsaw`, `gradient_utils`
  - 6 test/scratch scripts: `notify-remote`, `test-options`, `test-timer`, `import-test`, `test-scratch`,
    `test-scratch2`
  - 5 treesitter reference/backup files: `bash_zsh`, `variousobj`, `tstextobj`, `miniai`, `js-template-string`
  - 1 misc: `remote/eample_errors`

### Project Statistics

| Metric               | Value                                           |
| -------------------- | ----------------------------------------------- |
| Total Tests          | 10 test files (6 unit, 2 integration), 99 tests |
| Total Plugins        | 406 installed plugins                           |
| Config Lines of Code | ~267,173 lines (Lua/Vim)                        |
| Plugin Lines of Code | ~2,126,243 lines                                |

---

## [0.5.0] - 2026-03-09

### Removed

- **Dead code cleanup**: Removed 9 unused old/backup files (~1,990 lines)
  - `lua/tracker/diff/init_old.lua`, `lua/tracker/defaults_old.lua`
  - `lua/reactive/commands-old.lua`, `lua/reactive/old_snapshot.lua`, `lua/reactive/snapshot-old.lua`,
    `lua/reactive/old_commands.lua`
  - `lua/yanky/init-old.lua`
  - `lua/configs/nvim-cmp/reference/backup2.lua`
  - `lua/scripts/test-old-options.lua`

- **Duplicate profiler**: Removed `lua/utils/debug/profile/p.lua` (identical copy of `lua/plenary/profile/p.lua`)

- **Bundled project source**: Removed `lab/lab.nvim-main/` directory (95 files, full lab.nvim GPLv3 source)

- **Empty directories**: Removed `lua/tmp/`, `lua/ui/`, `lua/conform/`

### Project Statistics

| Metric               | Value                                           |
| -------------------- | ----------------------------------------------- |
| Total Tests          | 10 test files (6 unit, 2 integration), 99 tests |
| Total Plugins        | 406 installed plugins                           |
| Config Lines of Code | ~269,024 lines (Lua/Vim)                        |
| Plugin Lines of Code | ~2,126,243 lines                                |

---

## [0.4.0] - 2025-11-03

### Added

- **Smoothie Code Reorganization**: Consolidated all smoothie code into `lua/smoothie/` directory
  - Moved VimL code from `plugin/` and `autoload/` to `lua/smoothie/` for better organization
  - Added `lua/smoothie/load_viml.lua` loader for VimL version
  - Maintained autoload compatibility with wrapper file
  - Both Lua and VimL versions now coexist in same directory structure

- **Consolidated Benchmark Commands**: Unified command interface for both VimL and Lua implementations
  - `SBEnable`, `SBDisable`, `SBToggle`, `SBReset`, `SBStats` now work with active implementation
  - `SmoothieBenchmarkEnable`, `SmoothieBenchmarkDisable`, etc. for explicit control
  - Commands automatically detect and call correct implementation (VimL or Lua)
  - Maintained backward compatibility with legacy Lua-specific commands

- **Visual Lines Support**: New `use_visual_lines` config option
  - Accounts for wrapped lines and visual decorations when scrolling
  - Uses `gj`/`gk` movements instead of `j`/`k` when enabled
  - Better handling of markdown code blocks and long wrapped lines
  - Available in both Lua and VimL versions
  - Default: disabled (set `use_visual_lines = true` to enable)

### Fixed

- **Freeze Prevention for G/gg Commands**: Resolved infinite loop issue near buffer boundaries
  - Added timeout mechanism with max 10,000 iterations
  - Detects stuck animations after 50 iterations without movement
  - Early exit when already at target position
  - Proper cleanup when animation is stopped or completes
  - Fixes hanging issue when pressing `G` or `gg` near top/bottom of buffer

- **Benchmark Stats Display**: Improved table formatting and readability
  - Fixed border alignment (all lines now exactly 53 characters)
  - Added syntax highlighting for better visual distinction:
    - Blue borders (bold)
    - Red headers (bold)
    - Yellow labels
    - Green values (bold)
    - Cyan units (italic)
  - Consistent padding and formatting across all metrics
  - Applied to both Lua and VimL implementations

### Changed

- **Smoothie Toggle System**: Enhanced implementation switching
  - `SmoothieUseVimL` and `SmoothieUseLua` remain separate for explicit control
  - All benchmark commands now auto-detect active implementation
  - Improved state management between implementations

### Tests

- **Extended Test Coverage**: Added tests for new features
  - Freeze fix validation (ensures G/gg complete in < 5 seconds)
  - Consolidated commands verification
  - `use_visual_lines` config option testing
  - Edge case handling (already at target position)

## [0.3.0] - 2025-10-20

### Changed

- **LSP Configuration Migration**: Migrated from deprecated `nvim-lspconfig` API to native Neovim 0.11+ `vim.lsp.config`
  API
  - Replaced `require('lspconfig').*. setup()` pattern with `vim.lsp.config()` + `vim.lsp.enable()`
  - Migrated `on_attach` callback to `LspAttach` autocmd pattern (`lua/lsp/on_attach.lua`)
  - Updated global LSP configuration using `vim.lsp.config("*", {...})` for default settings
  - Converted `root_dir` functions to `root_markers` arrays for simpler configuration
  - Updated all server-specific configurations:
    - `lua/lsp/servers.lua`: Main server configuration and initialization
    - `lua/lsp/servers/lua_ls.lua`: Lua language server
    - `lua/lsp/servers/ts_ls.lua`: TypeScript/JavaScript language server
    - `lua/lsp/servers/eslint.lua`: ESLint language server
    - `lua/lsp/servers/jsonls.lua`: JSON language server
    - `lua/lsp/servers/stylelint_lsp.lua`: Stylelint language server
  - All 30+ LSP servers now use modern vim.lsp API
  - Maintained backward compatibility during transition

### Removed

- Removed dependency on deprecated `lspconfig.util` module
- Removed legacy `on_attach` callback pattern from individual server configurations
- Removed `mason-lspconfig.setup_handlers()` in favor of `vim.lsp.enable()`

### Project Statistics

| Metric               | Value                                |
| -------------------- | ------------------------------------ |
| Total Tests          | 5 test files (3 unit, 2 integration) |
| Total Plugins        | 402 installed plugins                |
| Config Lines of Code | ~1,542 lines (Lua/Vim)               |
| Plugin Lines of Code | ~170,267 lines                       |

---

## [0.2.0] - 2025-10-20

### Added

- **QuickClose Command**: Smart buffer/window closing functionality
  - Automatically detects and closes floating windows
  - Handles special splits (quickfix, help, neo-tree, CodeCompanion, Avante)
  - Intelligent buffer deletion with fallback to Alpha startup screen
  - Regex pattern matching for filetype detection
  - User command: `:QuickClose`

- **Comprehensive Test Suite**: Added 12 unit tests for QuickClose functionality
  - Buffer operations testing
  - Window operations (floating, split) testing
  - Special split detection and handling
  - Edge case coverage (last buffer scenario)
  - Regex pattern matching validation
  - All tests passing ✅

### Fixed

- **Syntax Errors**:
  - Fixed `for` loop syntax in `commands/quickclose.lua:76` (changed `then` to `do`)
  - Fixed undefined `augroup()` function call in `autocommands/init.lua:28`
  - Changed to use `vim.api.nvim_create_augroup()` directly

- **Deprecated Code**:
  - Updated CodeCompanion adapter configuration to new structure
  - Moved adapters from `adapters.*` to `adapters.http.*`
  - Moved `adapters.opts` to `adapters.http.opts`
  - Files updated: `configs/codecompanion/adapters/init.lua`, `configs/codecompanion/defaults.lua`

### Changed

- Enhanced test infrastructure with better cleanup and edge case coverage
- Improved documentation in test files with detailed comments

### Project Statistics

| Metric               | Value                                |
| -------------------- | ------------------------------------ |
| Total Tests          | 5 test files (3 unit, 2 integration) |
| Total Plugins        | 402 installed plugins                |
| Config Lines of Code | ~1,542 lines (Lua/Vim)               |
| Plugin Lines of Code | ~170,267 lines                       |

---

## [0.1.0] - 2025-10-18

### Added

- **Testing Framework**: Comprehensive testing infrastructure for unit and integration tests
  - Plenary.nvim integration for unit tests
  - Mini.test integration for integration tests
  - Test directory structure (`tests/unit`, `tests/integration`, `tests/fixtures`)
  - Minimal init file for isolated test environment (`tests/minimal_init.lua`)
  - Bash test runner script (`scripts/run_tests.sh`) with colored output
  - Lua test runner module (`lua/test_runner.lua`) with Neovim commands
  - Example unit tests demonstrating Vim API, Lua stdlib, and utility testing
  - Example integration tests for buffer operations, windows, autocommands, and keymaps
  - Test runner commands: `:TestUnit`, `:TestIntegration`, `:TestAll`, `:TestFile`, `:TestNearest`

- **Documentation**:
  - Comprehensive TESTING.md guide with examples and best practices
  - CLAUDE.md file documenting architecture for AI assistance

### Project Statistics

| Metric               | Value                                |
| -------------------- | ------------------------------------ |
| Total Tests          | 5 test files (2 unit, 3 integration) |
| Total Plugins        | 401 installed plugins                |
| Config Lines of Code | ~1,411 lines (Lua/Vim)               |
| Plugin Lines of Code | ~169,752 lines                       |

---

## Template for Future Entries

```markdown
## [X.Y.Z] - YYYY-MM-DD

### Added

- New features

### Changed

- Changes to existing functionality

### Deprecated

- Features marked for removal

### Removed

- Removed features

### Fixed

- Bug fixes

### Security

- Security improvements

### Project Statistics

| Metric               | Value               |
| -------------------- | ------------------- |
| Total Tests          | N test files        |
| Total Plugins        | N installed plugins |
| Config Lines of Code | N lines (Lua/Vim)   |
| Plugin Lines of Code | N lines             |
```

---

## Versioning Guidelines

- **MAJOR** (X.0.0): Incompatible changes, major refactoring, breaking changes
- **MINOR** (0.X.0): New features, enhancements, plugin additions
- **PATCH** (0.0.X): Bug fixes, minor tweaks, documentation updates
