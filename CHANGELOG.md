# Changelog

All notable changes to this Neovim configuration will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
