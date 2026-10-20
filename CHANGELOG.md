# Changelog

All notable changes to this Neovim configuration will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.14.2] - 2026-10-20

### Changed

- `TODO.md`: items now carry priorities read by `todo-status`, `/todo` and `todo-fzf` (same
  `(p1)` / `(p3)` / `(due YYYY-MM-DD)` tags as `~/.shell`). P1: shadowed plugin modules and
  tracking `lazy-lock.json`. 11 cleanup and tooling items are P3; the other 12 stay P2.

## [0.14.1] - 2026-10-20

### Changed

- `tests/unit/colorscheme_export_spec.lua` and `tests/manual/test_colorscheme_export.lua`: `nvim_buf_get_option` -> `nvim_get_option_value`. These were rewritten in v0.13.0 but left out of that commit.

## [0.14.0] - 2026-10-20

TODO item 1 (deprecated Neovim APIs) is complete for the config repo.

### Added

- `lua/utils/hl.lua`: `add_highlight()`, an extmark-based replacement for `nvim_buf_add_highlight` with the same contract:
  - `col_end = -1` highlights to end of line
  - namespace 0 or -1 maps to a shared namespace
  - out-of-range columns are clamped
  - the namespace id is returned

  Tests are in `tests/unit/utils_hl_spec.lua`.
- `tests/unit/deprecated_api_spec.lua`: fails on any use of a deprecated or removed Neovim API in
  `lua/`, `after/`, `plugin/` or `ftplugin/` (comments are ignored), listing each file and line.

### Changed

- `nvim_buf_add_highlight` -> `utils.hl.add_highlight`: 27 Lua sites, plus 7 VimL sites via `v:lua`
- `nvim_get_hl_by_name` -> `nvim_get_hl` (devicons, satellite search handler); a missing group now returns `{}` instead of raising
- `vim.diagnostic.goto_next` / `goto_prev` -> `vim.diagnostic.jump` with `float = true`, which keeps the old float default
- Table-form `vim.validate{}` -> `vim.validate(name, value, validator, optional)`: 16 sites. Short type names (`'f'`) are expanded, since the new form rejects them.
- Old-signature `vim.str_utfindex(s[, i])` -> explicit `"utf-32"` encoding
- `nvim_exec` -> `nvim_exec2`
- Dropped dead `vim.fn.has("nvim-0.8".."0.12")` guards and their legacy branches (qf ftplugin, telescope plugin, helpview, feline, live-command, mini.comment/surround, egrepify, recall, nvim-scissors, matchup hl-info)

### Fixed

- `project_nvim`: the `vim.lsp.start_client` monkey-patch never ran for clients started by `vim.lsp.start` / `vim.lsp.enable`, and it returned `nil` to callers. It is now an `LspAttach` autocmd, so the project root is actually recalculated when an LSP attaches.
- `:Silence` / noice silence toggle: restarting LSP clients passed client objects (or a list) to `start_client`; now uses `vim.lsp.start(client.config)` per client
- `tint` highlights required `nvim-treesitter.ts_utils`, which doesn't exist on the nvim-treesitter `main` branch; ported `get_vim_range` locally
- `lsp/diagnostics.lua`: `not vim.fn.has(...)` was always false (0 is truthy in Lua); the dead legacy sign branch was removed
- `gitops` LSP format helpers: removed fallbacks to the removed `vim.lsp.buf.formatting` / `formatting_sync`
- Vendored plenary popup: a broken `nvim_set_option` format string (unquoted option name) now uses `nvim_set_option_value("wrap", ...)`

### Linked `~/git` repos (committed locally, not pushed)

- nvim-cmp, nvim-notify, noice.nvim: explicit encodings for `vim.str_utfindex`. This removes the runtime deprecation warnings from nvim-notify.
- nvim-navbuddy, convey.nvim: `nvim_buf_add_highlight` -> extmarks
- nvim-cmp, nvim-notify, ultimate-autopair, nvim-navbuddy, telescope: `vim.loop` -> `vim.uv` and the other mechanical renames. telescope gets `vim.uv` only, to stay within its CI floor of v0.10.4.

## [0.13.0] - 2026-10-19

### Fixed

Calls to APIs already removed from Neovim v0.13.0-dev (they raised errors when reached):

- `vim.lsp.get_active_clients()` / `vim.lsp.buf_get_clients()` -> `vim.lsp.get_clients()` (14 sites: feline providers, stats panels, LSP notifications, workspace-diagnostics, python ftplugin, text-case)
- `vim.lsp.util.jump_to_location()` -> `vim.lsp.util.show_document()` in definition-or-references
- `vim.diagnostic.disable()` / `is_disabled()` and the old `enable(bufnr)` signature -> `vim.diagnostic.enable(bool, filter)` / `is_enabled()` in the hydra toggles and the mapper keymap
- `vim.lsp.buf.formatting()` -> `vim.lsp.buf.format()`
- `vim.treesitter.query.get_node_text()` -> `vim.treesitter.get_node_text()` (vue ftplugin, snippets-utils)
- `client.supports_method(...)` -> `client:supports_method(...)`

### Changed

Mechanical replacements of deprecated APIs (302 call sites, 174 files), done with an argument-aware rewriter that skips comments and strings:

- `vim.loop` -> `vim.uv` (144)
- `nvim_buf_*_option` / `nvim_win_*_option` -> `nvim_get_option_value` / `nvim_set_option_value` with `{ buf = }` / `{ win = }` (108)
- `nvim_get_option` / `nvim_set_option` -> `*_option_value` with `{ scope = "global" }`, which keeps the global-only semantics (9)
- `nvim_err_writeln(msg)` -> `nvim_echo({ { msg } }, true, { err = true })` (27)
- `vim.tbl_flatten(t)` -> `vim.iter(t):flatten(math.huge):totable()` (13). `dumb_jump` and `egrepify` get a local helper with `tbl_flatten`'s exact semantics, because their argument lists can contain `nil` holes.
- `vim.highlight.*` -> `vim.hl.*`, `vim.tbl_islist` -> `vim.islist`
- Aliased references (`local bufOpt = vim.api.nvim_buf_get_option` etc.) replaced with equivalent wrappers

### Known issues

- 8 files already failed to parse before this change: `stats/commands/*/init.lua` (5), `configs/feline/reference.lua`, `configs/none-ls/services.lua` and `scratch/tmpactions.lua`. They are orphan candidates for TODO item 2.

## [0.12.1] - 2026-10-19

### Added

- Claude Code `SessionStart` hook (`.claude/hooks/todo-reminder.py`, registered in `.claude/settings.local.json`).
  On each new session it shows a one-line count of open `TODO.md` items per section, and passes the full
  list to Claude as context so it can remind you and ask what to work on.

## [0.12.0] - 2026-10-19

### Added

- `scripts/smoke.lua`: headless smoke test of the full config.
  - Runs startup and VeryLazy, then opens a sample file for each common filetype.
  - Optionally force-loads plugins (`SMOKE_PLUGINS=a,b` or `all`) and adds healthcheck sections (`SMOKE_HEALTH`).
  - Records `vim.deprecate` calls and WARN/ERROR notifications, and runs `:checkhealth vim.deprecated`.
  - A watchdog answers blocking prompts.

### Fixed

Breaking changes and errors from the plugin update (`plugin_udpates.txt`), verified headless with all 404 plugins loaded:

- **Removed upstream repos**: dropped `telescope-changes`, `telescope-command-palette`, `telescope-ports` (LinArcX) and `telescope-docker` (lpoto), along with their extension configs
- **yazi.nvim**: re-cloned after the interrupted update left a corrupt submodule
- **rest.nvim rock**: system luarocks 3.8 can't load the `treesitter-parser` build backend, so the
  `tree-sitter-http` rock was pre-installed into `lazy-rocks/rest.nvim` with the backend on `LUA_PATH`.
  Lazy then built rest.nvim normally. Hererocks was tried first and also fails to load that backend.
- **oxocarbon.nvim**: `build = false`; its rockspec needs fennel, which fails to build on Lua 5.1 (prebuilt `lua/` ships with the plugin)
- **E201 on first file open**: indent-blankline lazy-loads on `BufReadPost` instead of `BufReadPre`. Loading it inside `BufReadPre` changed the current buffer.
- **cmp-git**: callback `trigger_actions` migrated to named `actions`
- **codecompanion v20**:
  - removed the unsupported `mini_diff` diff provider
  - dropped the obsolete `interactions.inline.keymaps` (diff keymaps now live in `shared.keymaps`)
  - `:CodeCompanionShare` uses `chat.context:add` with `opts.sync_all` and the `interactions.*.builtin.file` source
- **octo**: `file_panel.use_icons` -> `file_panel.icons`; `timeline_indent` is a number
- **undotree**: keymaps use the `{ [action] = lhs }` format
- **sshfs.nvim**: `ui.file_picker` -> `ui.local_picker`
- **nvim-dap-view**: `windows.height` -> `windows.size`; removed the unsupported `terminal.start_hidden`, in both the spec opts and `configs/nvim-dap-view.lua`
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
- **avante.nvim**: added its new required dependencies `ColinKennedy/mega.cmdparse` and `mega.logging`; avante failed to load without them
- `vim.F.if_nil` -> `vim.nonnil` across 30 in-repo files, including the vendored `lua/plenary/` (deprecated, removal in Nvim 0.15)
- `vim.validate{}` table form -> `vim.validate(name, value, validator)` in `live-command/config_validator.lua` and `mini/surround/Config.lua`

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

- **Release tooling**: `scripts/report.sh` (tests with coverage, cloc stats into `.reports/<timestamp>/`)
  and `scripts/release.sh` (semver-guarded commit, annotated tag, `push --follow-tags`)
- **Test coverage**: `NVIM_COVERAGE=<statsfile>` enables luacov in `tests/minimal_init.lua`;
  `run_tests.sh` runs specs sequentially with a longer timeout in that mode
- Refactoring Telescope extension (`lua/telescope/_extensions/refactoring.lua`)

### Changed

- `configs/refactoring.lua`, `neovide.lua`, `vim-options.lua`, nvim-cmp sources and `configs/convey.lua` reworked
- `notifications/recipes/command.lua`: StyLua formatting; mpc recipe sources `~/.aliases/shell/audio.sh`
- Large cleanup across `configs/`, `telescope/`, `gitops/`, `scrollview/`, `scrollbar/`, `glyph-guard/`
  (233 files, -28k lines)

### Removed

- `lua/notify/_demo/`, `lua/notify/_render/`, `lua/notify/render/_*` and `lua/notify/util/render.lua`
  (unused notify demo and renderer copies)
- `tmp.sh` and `luacov.stats.out` from version control (now ignored)

### Fixed

- `bars_statusline_spec` theme test still expected 6 themes after `feline` was added in v0.9.0
- Pre-commit report referenced nonexistent `~/.nvim`; cloc now targets the config directory
- `quickclose_spec` reads the command `desc`; newer Neovim returns an empty `definition` for Lua callbacks

## [0.10.0] - 2026-04-15

### Changed

- **Logging consolidation**: Merged `lua/structlog/` and `lua/debuglog/` under `lua/logger/` as subdirectories
  - `lua/structlog/` -> `lua/logger/structlog/` (structured logging framework, 19 files)
  - `lua/debuglog/` -> `lua/logger/debug/` (inspect, dump, traceback, timer, namespace helpers; 15 files; dropped `globals.lua` and `test.lua` as superseded)
  - Internal requires rewritten to use new paths; zero consumers outside `lua/logger/` reference the old paths
  - Updated 11 consumers to new paths: `logger/{init,sinks,parsers,notify}.lua`, `watcher/logger.lua`, `tracker/{init,au_events}.lua`, `configs/chrome-remote/scratch.lua`, `import/benchmarks/commands.lua`
  - Removed 4 dead `require("debuglog")` imports in `import/benchmarks/variables.lua`, `import/ui/{init,lines,summary}.lua` (imported but never used)

- **Registers module refactor** (v0.10.0 scope, moved from v0.9.0 in-progress work):
  - Fade state in `fade_controller` with scenario-aware levels, buffer-variable sync, relative values
  - `range_hl` decoration provider for per-range restoration and color transforms
  - `color_math` HSL transform pipeline + derived highlight cache
  - 23 new tests in `tests/unit/registers_spec.lua`

### Removed

- **Dead code in `lua/globals/`**:
  - `lua/globals/modules/` (entire directory): `buffers.lua` had a broken load-time `vim.dbglog()` side-effect, `filter.lua` / `format.lua` / `utils.lua` / `windows.lua` were stubs or broken
  - `lua/globals/overrides.lua` (unreferenced), `preload.lua` (standalone `/tmp/nvim-preload.log` system, never wired in), `record-events.lua` (only referenced in a commented-out line)
  - Unused `N` and `D` globals from `globals/init.lua` (scan showed zero usage)
  - Commented-out code blocks in `globals/init.lua`

- **`lua/structlog/`** (moved to `lua/logger/structlog/`)
- **`lua/debuglog/`** (moved to `lua/logger/debug/`, minus `globals.lua` and `test.lua`)

### Fixed

- **`logger/debug/timer.lua`**: Fixed two latent bugs discovered during the move
  - `finished[_]` used global lodash table as key instead of string `"_"`
  - `stop_time(anon_timer, vim.loop.hrtime())` passed timestamp as `name` parameter
  - Function now also returns the elapsed time (previously side-effect only)

- **Registers key-binding crash with scrolloff=0**: `upwards()` / `backwards()` no longer exit early when cursor is at window top but buffer has content above (fixes `winline <= 1` guard)

### Modernized

- `vim.loop.hrtime()` -> `(vim.uv or vim.loop).hrtime()` in `logger/debug/timer.lua`
- `vim.loop` fallback via `vim.uv or vim.loop` in `logger/structlog/{formatters/sinks,sinks/rotating_file}.lua`

### Added

- **`tests/unit/logger_spec.lua`** — 23 tests covering scope management, level filtering, sinks, debug helpers, `:LogScopes` command, structlog API smoke, globals integration

### Project Statistics

| Metric | Value |
|--------|-------|
| Total Tests | 33 test files, 372 tests (355 unit + 17 integration; 1 pre-existing fail unrelated) |
| Total Plugins | 380 installed plugins |
| Config Lines of Code | 285,454 lines (Lua/Vim) |
| Plugin Lines of Code | 1,640,391 lines |

---

## [0.9.0] - 2026-03-29

### Added

- **Vimade fade controller** (`lua/configs/vimade/fade_controller.lua`): State management layer for per-buffer fade levels
  - Scenario-aware fadelevel function: cmdline (0.2), split (0.6), popup (0.6), configurable per scenario
  - Public API: `fade(bufnr, level, source)`, `unfade(bufnr)`, `get(bufnr)`, `fadetint(bufnr, level)`
  - Relative fade values: `"+0.2"`, `"-0.1"` syntax applied against current level, clamped to [0, 1]
  - Buffer variable sync: `vim.b.fadelevel` and `vim.b.fade_source` updated on every mutation
  - Forces immediate vimade update on API calls (bypasses 500ms polling)
  - User commands: `:VimadeFade [bufnr] [level] [source]`, `:VimadeUnfade [bufnr]`

- **Per-range highlight module** (`lua/configs/vimade/range_hl.lua`): Decoration provider for range-level highlight control
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

- **Performance analysis notes** (`lua/configs/vimade/NOTES.md`): Detailed comparison of vimade vs tint.nvim architectures

### Changed

- **Vimade config**: Replaced flat `fadelevel = 0.45` with `fade_controller.make_fadelevel(cfg)` for scenario-aware fading
- **Vimade minimalist style**: Moved CursorLineNr/LineNr/Scrollbar/Satellite groups to LOW_VISIBILITY_NAMES, set low_visibility_fadelevel to 0.5
- **Vimade init**: Added BufDelete cleanup autocmd, visual restore setup, VimadeFade/VimadeUnfade commands
- **Vimade utils**: Removed old fadelevel function and get_active_info (replaced by fade_controller)

### Fixed

- **VimadeUnfadeAll command**: Fixed reference to undefined `M` variable (was `M.vimade_unfade_global()`, now `v_utils.vimade_unfade_global()`)
- **VimadeInfo command cleanup**: Wrapped `nvim_del_user_command` in pcall to avoid error on first load

### Project Statistics

| Metric | Value |
|--------|-------|
| Total Tests | 25 test files, 304 tests (287 unit + 17 integration) |
| Total Plugins | 377 installed plugins |
| Config Lines of Code | 284,472 lines (Lua/Vim) |
| Plugin Lines of Code | 276,274 lines |

---

## [0.8.0] - 2026-03-28

### Added

- **hover.nvim plugin** (`~/git/hover.nvim`): Extracted hover and devbox modules into standalone plugin
  - Multi-provider floating window system with tab navigation
  - 9 hover providers: lsp-hover, lsp-signature, lsp-definition, lsp-type-definition, help, man, dictionary, syntax, GitHub issues
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

| Metric | Value |
|--------|-------|
| Total Tests | 22 test files, 250 tests (config) + 102 tests (hover.nvim) |
| Total Plugins | 378 installed plugins |
| Config Lines of Code | 280,414 lines (Lua/Vim) |
| Plugin Lines of Code | 276,719 lines |

---

## [0.7.0] - 2026-03-16

### Removed

- **Telescope shadow file cleanup**: Moved 25 stale plugin shadow files from `lua/telescope/` to `~/.local/backup/telescope/`
  - Removed `config.lua` that shadowed plugin's config (caused startup errors after upstream merge deleted `telescope.deprecated` module)
  - Removed 5 underscore-prefixed directory copies: `_actions/`, `_builtin/` (6 files), `_finders/` (3 files), `_pickers/` (2 files), `_previewers/` (5 files)
  - Removed 7 standalone unreferenced files: `__.lua`, `_config.lua`, `_command.lua`, `_from_entry.lua`, `_make_entry.lua`, `_pickers.lua`, `issues.txt`
  - Kept: `run.lua`, `telemap.lua`, `telethemes.lua`, `log.lua` (custom functionality), `_extensions/init.lua` (custom enhancements), `_layouts/` (custom layouts)

- **Telescope config cleanup**: Moved 22 unused config files from `lua/configs/telescope/` to `~/.local/backup/nvim-refactor/`
  - Entire `pickers2/` directory (10 experimental pickers: code-action, command-palette, glance, harpoon, marks, mind, nvim-tree, ollama, terminal, timetracker)
  - 12 standalone files: `backdrop.lua`, `symbol_highlights.lua`, `filename-first.lua`, `layout-fused.lua`, `minimal.lua`, `sorters.lua`, `_which_key.lua`, `launchkeys.lua`, `reference.lua`, `stickybuf.lua`, `display-path.lua`, `previewers/delta.lua`
  - 2 unused entry makers: `entry_makers/file.lua`, `entry_makers/quickfix.lua`
  - 2 unused actions: `actions/directory.lua` (empty), `actions/reference.lua`

- **Dead code removal**: Removed ~377 lines of commented-out/unused code from active config files
  - `init.lua`: unused requires, dead functions, commented-out autocmd blocks
  - `extensions.lua`: 8 commented-out extension configs, unused `telescope` require
  - `pickers.lua`: commented-out option blocks, symbols_highlights blocks
  - `mappings.lua`: 67-line LazyVim example keymaps

### Fixed

- **Startup error**: Fixed `telescope.deprecated` module-not-found error after upstream merge by removing stale shadow `config.lua`

### Project Statistics

| Metric | Value |
|--------|-------|
| Total Tests | 11 test files, 132 tests (132 passing) |
| Total Plugins | 378 installed plugins |
| Config Lines of Code | 204,063 lines (Lua/Vim) |
| Plugin Lines of Code | 2,037,917 lines |

---

## [0.6.0] - 2026-03-09

### Removed

- **Unreferenced module cleanup**: Moved 29 unreferenced lua modules to `~/.local/backup/nvim-refactor/`
  - 12 top-level dead modules: `evaluate`, `formatter-nvim`, `keyutils`, `layouts`, `oputils`,
    `random-colorscheme`, `shebang`, `splitter`, `test_runner`, `tmp-dap`, `tmpts`, `unicode`
  - 5 unused utils: `autofunc`, `blink_animate`, `bufopt`, `chainsaw`, `gradient_utils`
  - 6 test/scratch scripts: `notify-remote`, `test-options`, `test-timer`, `import-test`,
    `test-scratch`, `test-scratch2`
  - 5 treesitter reference/backup files: `bash_zsh`, `variousobj`, `tstextobj`, `miniai`,
    `js-template-string`
  - 1 misc: `remote/eample_errors`

### Project Statistics

| Metric | Value |
|--------|-------|
| Total Tests | 10 test files (6 unit, 2 integration), 99 tests |
| Total Plugins | 406 installed plugins |
| Config Lines of Code | ~267,173 lines (Lua/Vim) |
| Plugin Lines of Code | ~2,126,243 lines |

---

## [0.5.0] - 2026-03-09

### Removed

- **Dead code cleanup**: Removed 9 unused old/backup files (~1,990 lines)
  - `lua/tracker/diff/init_old.lua`, `lua/tracker/defaults_old.lua`
  - `lua/reactive/commands-old.lua`, `lua/reactive/old_snapshot.lua`, `lua/reactive/snapshot-old.lua`, `lua/reactive/old_commands.lua`
  - `lua/yanky/init-old.lua`
  - `lua/configs/nvim-cmp/reference/backup2.lua`
  - `lua/scripts/test-old-options.lua`

- **Duplicate profiler**: Removed `lua/utils/debug/profile/p.lua` (identical copy of `lua/plenary/profile/p.lua`)

- **Bundled project source**: Removed `lab/lab.nvim-main/` directory (95 files, full lab.nvim GPLv3 source)

- **Empty directories**: Removed `lua/tmp/`, `lua/ui/`, `lua/conform/`

### Project Statistics

| Metric | Value |
|--------|-------|
| Total Tests | 10 test files (6 unit, 2 integration), 99 tests |
| Total Plugins | 406 installed plugins |
| Config Lines of Code | ~269,024 lines (Lua/Vim) |
| Plugin Lines of Code | ~2,126,243 lines |

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

- **LSP Configuration Migration**: Migrated from deprecated `nvim-lspconfig` API to native Neovim 0.11+ `vim.lsp.config` API
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

| Metric | Value |
|--------|-------|
| Total Tests | 5 test files (3 unit, 2 integration) |
| Total Plugins | 402 installed plugins |
| Config Lines of Code | ~1,542 lines (Lua/Vim) |
| Plugin Lines of Code | ~170,267 lines |

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

| Metric | Value |
|--------|-------|
| Total Tests | 5 test files (3 unit, 2 integration) |
| Total Plugins | 402 installed plugins |
| Config Lines of Code | ~1,542 lines (Lua/Vim) |
| Plugin Lines of Code | ~170,267 lines |

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

| Metric | Value |
|--------|-------|
| Total Tests | 5 test files (2 unit, 3 integration) |
| Total Plugins | 401 installed plugins |
| Config Lines of Code | ~1,411 lines (Lua/Vim) |
| Plugin Lines of Code | ~169,752 lines |

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

| Metric | Value |
|--------|-------|
| Total Tests | N test files |
| Total Plugins | N installed plugins |
| Config Lines of Code | N lines (Lua/Vim) |
| Plugin Lines of Code | N lines |
```

---

## Versioning Guidelines

- **MAJOR** (X.0.0): Incompatible changes, major refactoring, breaking changes
- **MINOR** (0.X.0): New features, enhancements, plugin additions
- **PATCH** (0.0.X): Bug fixes, minor tweaks, documentation updates
