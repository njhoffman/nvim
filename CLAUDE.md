# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a heavily customized Neovim configuration written in Lua (~282k lines). It uses lazy.nvim for plugin management
with an extensive collection of plugins and custom modules.

## Git Configuration

This directory is its own git repository (`origin` = `git@github.com:njhoffman/nvim.git`, branch `main`). Use plain
`git` commands from `~/.config/nvim`. The old `~/.cfg` bare repo no longer tracks this directory.

### Versioning and releases

The config uses semver with annotated `vX.Y.Z` tags and a Keep a Changelog `CHANGELOG.md`. Every verified, completed
change gets its own commit, bump and tag. The report runs when pushing, not on every commit, so changes can pile up
locally and go out together.

Bump rules (pre-1.0):

- **patch**: bug fixes, formatting, small cleanups, test-only changes
- **minor**: new features or modules, refactors, removals, anything breaking
- **major**: only when explicitly requested (1.0.0)

Per change:

1. Run the tests for what changed (`./scripts/run_tests.sh unit`, or a single spec file).
2. Add a `## [X.Y.Z] - YYYY-MM-DD` section to `CHANGELOG.md`.
3. Stage the change, then `./scripts/release.sh X.Y.Z "<summary>"`. It refuses a version that is not newer than the
   latest tag or that lacks a changelog section, then commits as `vX.Y.Z: <summary>` and creates the annotated tag. It
   does not push. Set `RELEASE_TRAILER` to append a `Co-Authored-By` line.

To push, run `./scripts/push.sh` (in the background from Claude Code; it takes 10-20 minutes):

1. It refuses uncommitted changes to tracked files, since the report must test what goes out, and a main behind
   `origin/main`.
2. `./scripts/report.sh X.Y.Z` runs for the latest tag: all tests with coverage (Plenary specs in parallel, mini.test,
   the Python tests in `tests/bench/` and the bats tests in `tests/scripts/`), then cloc (the plugin tree's cloc is
   cached by `lazy-lock.json`), then the benchmarks, recording them as release X.Y.Z in `benchmarks/history.tsv` and
   rewriting the table in `docs/PERFORMANCE.md`. Progress goes to stderr as it happens (phases with durations, one line
   per spec file and each failure, benchmark load waits and sessions). If any test or the benchmark run fails, the report
   moves to `.reports/failed/<timestamp>/` (gitignored) with `tests.log` and `bench.log`, and nothing is committed or
   pushed. Benchmark warnings (a metric over 25% slower than its average or baseline) do not abort; mention them.
3. `scripts/report_summary.py` writes `<report dir>/summary.md`: the changelog sections since the last push, code stats,
   coverage, test counts and deltas against the previous report, and the benchmark tables. Only `summary.md` is
   committed; the rest of each report is gitignored and stays local.
4. It commits `summary.md`, `benchmarks/history.tsv` and `docs/PERFORMANCE.md` as `vX.Y.Z: report` with a
   `Report: passed` line, and runs `git push origin HEAD --follow-tags`.

`scripts/hooks/pre-push` (active through `core.hooksPath`, which `push.sh` sets) refuses a plain `git push` of main whose
tip is not a report commit. Other branches pass, and `git push --no-verify` skips it.

Benchmark baseline: `benchmarks/run --baseline` records a new one under low load (it waits up to 30 minutes for it). Run
it only when asked, or suggest it after a Neovim upgrade. See `benchmarks/README.md`.

Report data in `.reports/` and the generated `benchmarks/fixtures/` are excluded from cloc and must not be analyzed as
part of the repo.

After plugin or Neovim updates, also run the headless smoke test. Use an isolated state dir so sessions and shada stay
untouched. `SMOKE_HEALTH="rest-nvim avante"` appends those healthcheck sections to the output.

```bash
out=$(mktemp -d)
SMOKE_OUT=$out SMOKE_PLUGINS=all XDG_STATE_HOME=$out/state XDG_CACHE_HOME=$out/cache \
  nvim --headless -i NONE --cmd "luafile scripts/smoke.lua"
# $out/report.txt: deprecations, warnings, errors, :messages
# $out/checkhealth.txt: :checkhealth vim.deprecated with stack traces
```

## Core Architecture

### Entry Point & Module Loading

- **init.lua**: Main entry point that loads core modules via `vim.import()`
- **lua/core/globals/importer.lua**: Custom import system wrapper that adds `vim.import()` and `vim.reload()` functions with
  error handling
- **lua/utils/lazy/**: Plugin management system that auto-discovers config files

### Module Structure

init.lua loads, in order:

```
core.globals (importer, variables, core.options, core.neovide) → colorscheme → modules.components
  → utils.lazy (plugins) → core.keymaps, core.commands, core.abbreviations, core.autocommands
  → modules (runner, stats, devdocs2, tracker, tmux, oldfiles, tail, unicode) and some configs.*
  → deferred 100 ms: modules.alt, modules.sidebar, modules.format_cmdline, more configs.*
```

Layout of `lua/` (require paths follow the directories, e.g. `require("core.commands.scroll")`):

- **lua/core/**: the config's own startup code: `globals/`, `options/` (`user.lua` registered options, `vim.lua`
  vim options), `keymaps.lua`, `commands/`, `abbreviations.lua`, `autocommands/`, `lsp/`, `neovide.lua`
- **lua/modules/**: own plugins-in-progress, each self-contained; candidates for their own repos
- **lua/lib/**: shared libraries: `logger/`, `mapper/` (keymap helper), `lodash/`, `helpers.lua`
- **lua/plugins/**: Plugin specifications (main.lua, lsp.lua, completion.lua, dap.lua, colorscheme.lua)
- **lua/configs/**: Per-plugin configuration files (automatically loaded by lazy.nvim wrapper)
- **lua/utils/**: Utility functions and the lazy.nvim wrapper
- **lua/telescope/\_extensions/**: Custom Telescope extensions (must stay under the `telescope` namespace)

Still at the top level of `lua/`: vendored or forked plugin copies (e.g. `satellite`, `smoothcursor`, `feline`,
`quicknote`, `action-hints`) and modules that shadow an installed plugin (e.g. `mini`, `yanky`, `nvim-web-devicons`);
see TODO.md "Shadowed plugin modules". New own code goes in `core/`, `modules/` or `lib/`.

### Plugin Configuration System

The config uses a custom lazy.nvim wrapper (`lua/utils/lazy/configs.lua`) that:

1. Automatically discovers config files in `lua/configs/` matching plugin names
2. Applies config functions to plugins based on name matching
3. Tracks loaded/failed configs via state management

To add a new plugin config:

- Create `lua/configs/{plugin-name}.lua` (name normalized: lowercase, `.nvim` suffix removed)
- Return configuration table or setup function
- The wrapper automatically applies it when plugin loads

### Custom Import System

`vim.import()` is a wrapper around `require()` that:

- Provides better error reporting with vim.notify
- Can be used for hot-reloading modules during development
- Available globally after globals module loads

## Code Style

### Formatting

- **Lua**: Uses StyLua for formatting
  - Column width: 100
  - Indent: 2 spaces
  - Quote style: Auto-prefer double quotes
  - Call parentheses: Always
- **Linting**: Uses luacheck (config: .luacheck, .luarc.json)

### Filetype Customizations

See `filetype.lua` for custom filetype patterns:

- `.aliases*` → bash
- `.env*` → dotenv (treesitter: bash)
- `.env*.example` → conf
- `requirements*.txt` → requirements
- `*.log`, `*_log` → log (tree-sitter parser `parser/log.so`, grammar in `parsers/tree-sitter-log`, query in
  `queries/log/`, colors in `after/ftplugin/log.lua`)
- `/var/log/syslog*` → syslog (`syntax/syslog.vim`)

## Development Commands

### Plugin Management

```lua
-- Lazy.nvim commands (available after startup)
:Lazy               -- Open lazy.nvim UI
:Lazy sync          -- Update plugins
:Lazy clean         -- Remove unused plugins
```

### Testing & Debugging

```lua
-- Reload a module during development
:lua vim.reload('module.name')

-- Inspect loaded configs
:lua vim.print(require('utils.lazy.state'))

-- View plugin loading info
:Lazy profile
```

### Project Management

```lua
:ProjectGetRoot     -- Show project root and detection method
:ProjectDbg         -- Dump project.nvim debug data
```

Project root detection (via project_nvim):

- Detection methods: LSP, then pattern-based
- Patterns: .git, _darcs, .hg, .bzr, .svn, Makefile, package.json
- Ignores LSP: null-ls, copilot

## Key Integrations

### Telescope

Heavy Telescope usage with 30+ custom extensions in `lua/telescope/_extensions/`:

- Custom pickers for fences, devhints, variables, options, etc.
- All extensions auto-loaded by configs/telescope.lua

### LSP & Completion

- LSP configs in `lua/plugins/lsp.lua`
- Completion setup in `lua/plugins/completion.lua`
- Custom LSP handlers and utilities in various lua/configs/ files

### AI/LLM Integrations

Multiple AI plugin integrations:

- codecompanion.nvim (primary)
- avante.nvim
- gp.nvim
- `lua/llm-providers.lua` and `lua/llm-prompts.lua` are currently loaded by nothing (see TODO.md "Orphaned top-level
  modules")

### Git Workflow

Extensive git tooling:

- fugitive, gitsigns, git-conflict, lazygit, octo
- diffview.nvim for diff/merge workflows
- git-worktree.nvim integration

## Common Patterns

### Adding a New Command

1. Create file in `lua/core/commands/{name}.lua`
2. Define command with `vim.api.nvim_create_user_command()`
3. Module is auto-loaded via init.lua → commands module

### Adding a New Plugin

1. Add to `lua/plugins/main.lua` (or specific category file)
2. Optionally create `lua/configs/{plugin-name}.lua` for configuration
3. Run `:Lazy sync`

### Custom Modules

Most custom functionality is in self-contained modules under `lua/modules/`, for example:

- `runner/`: Command runner with tmux/notify output
- `stats/`: Info panels and statistics
- `tracker/`: Activity tracking
- `tail/`: Log file tailing
- `tmux/`: tmux navigation and resizing (forked from aserowy/tmux.nvim)
- `unicode/`, `glyph-guard/`: Unicode search and glyph checks
- `markdown/`: Markdown editing helpers (`prose`, `backtick`, `codeblocks`), attached from
  `after/ftplugin/markdown.lua`

Hover lives in a local plugin checkout (`~/git/hover.nvim`, loaded with `dir =` in `lua/plugins/main.lua`).

## Performance Notes

- Uses lazy loading extensively (via lazy.nvim `event`, `cmd`, `ft` options)
- Some modules deferred with `vim.defer_fn()` in init.lua (100ms, 500ms delays)
- Profile with `NVIM_PROFILE=1 nvim` and `:Lazy profile`

## Special Files

- **lazy-lock.json**: Plugin version lock file
- **projector.json**: Project-specific settings (nvim-projector)
- **scratch_config.json**: Scratch buffer configurations
- **.stylua.toml**: Lua formatter config
- **.luacheckrc**: Lua linter config
- **selene.toml**: Alternative Lua linter config
