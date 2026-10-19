# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a heavily customized Neovim configuration written in Lua (~282k lines). It uses lazy.nvim for plugin management with an extensive collection of plugins and custom modules.

## Git Configuration

This directory is its own git repository (`origin` = `git@github.com:njhoffman/nvim.git`, branch `main`).
Use plain `git` commands from `~/.config/nvim`. The old `~/.cfg` bare repo no longer tracks this directory.

### Versioning and releases

The config uses semver with annotated `vX.Y.Z` tags and a Keep a Changelog `CHANGELOG.md`.
Every verified, completed change is released automatically: commit, bump, tag, push.

Bump rules (pre-1.0):

- **patch**: bug fixes, formatting, small cleanups, test-only changes
- **minor**: new features or modules, refactors, removals, anything breaking
- **major**: only when explicitly requested (1.0.0)

Release steps:

1. `./scripts/report.sh` runs all tests with coverage, then cloc. It prints the report directory
   (`.reports/<timestamp>/`). If any test fails it aborts: do not commit, tag or push.
2. Write `<report dir>/summary.md`: code stats, coverage, counts of installed plugins and tests,
   and deltas against the previous report.
3. Add a `## [X.Y.Z] - YYYY-MM-DD` section to `CHANGELOG.md`.
4. Stage the change, the report directory and `CHANGELOG.md`, then
   `./scripts/release.sh X.Y.Z "<summary>"`. It refuses a version that is not newer than the
   latest tag or that lacks a changelog section, then commits as `vX.Y.Z: <summary>`, creates the
   annotated tag and runs `git push origin HEAD --follow-tags`. Set `RELEASE_TRAILER` to append a
   `Co-Authored-By` line.

Report data in `.reports/` is excluded from cloc and must not be analyzed as part of the repo.

## Core Architecture

### Entry Point & Module Loading

- **init.lua**: Main entry point that loads core modules via `vim.import()`
- **lua/globals/importer.lua**: Custom import system wrapper that adds `vim.import()` and `vim.reload()` functions with error handling
- **lua/utils/lazy/**: Plugin management system that auto-discovers config files

### Module Structure

The configuration is organized into top-level modules loaded in init.lua:

```
init.lua loads in order:
  globals → keymaps → commands → abbreviations → autocommands
  → devbox → runner → stats → tracker → configs → hover
```

Key directories:

- **lua/plugins/**: Plugin specifications (main.lua, lsp.lua, completion.lua, dap.lua, colorscheme.lua)
- **lua/configs/**: Per-plugin configuration files (automatically loaded by lazy.nvim wrapper)
- **lua/commands/**: Custom user commands and command utilities
- **lua/autocommands/**: Autocommand definitions
- **lua/keymaps/**: Keymap definitions
- **lua/utils/**: Utility functions and helper modules
- **lua/telescope/_extensions/**: Custom Telescope extensions

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
- Custom LLM config in `lua/llm-config.lua`, `lua/llm-providers.lua`, `lua/llm-prompts.lua`

### Git Workflow

Extensive git tooling:

- fugitive, gitsigns, git-conflict, lazygit, octo
- diffview.nvim for diff/merge workflows
- git-worktree.nvim integration

## Common Patterns

### Adding a New Command

1. Create file in `lua/commands/{name}.lua`
2. Define command with `vim.api.nvim_create_user_command()`
3. Module is auto-loaded via init.lua → commands module

### Adding a New Plugin

1. Add to `lua/plugins/main.lua` (or specific category file)
2. Optionally create `lua/configs/{plugin-name}.lua` for configuration
3. Run `:Lazy sync`

### Custom Modules

Most custom functionality is in self-contained modules:

- `lua/watcher/`: File watching system
- `lua/runner/`: Command runner with tmux/notify output
- `lua/stats/`: Info panels and statistics
- `lua/devbox/`: Development environment utilities
- `lua/tracker/`: Activity tracking
- `lua/tail/`: Log file tailing
- `lua/hover/`: Hover information system

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
