# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim-tmux integration module, forked from [aserowy/tmux.nvim](https://github.com/aserowy/tmux.nvim). Provides seamless navigation, resizing, and clipboard sync between Neovim splits and tmux panes.

## Refactoring Status

Most functionality works in committed code. Active refactoring in the working directory:
- `resize/resize.lua`: `get_state()` returns nil (missing return statement), `M.to()` references undefined `step_size` variable, and only handles up/down — left/right cases not implemented
- `keymaps.lua`: Large blocks of commented-out code from the old approach; `resize()` helper has a broken `vim.tbl_get` call for determining axis

## Architecture

**Entry point**: `init.lua` — exposes public API (move_*, resize_*, post_yank, sync_registers) and orchestrates setup in order: tmux wrapper -> config -> copy -> navigation -> resize.

**Feature modules** (each has `init.lua` + implementation file):
- `navigation/` — Determines whether to move within nvim, switch tmux pane, cycle to opposite edge, or delegate to i3
- `resize/` — Resizes nvim splits or tmux panes, with mini.animate integration (auto-disables during resize)
- `copy.lua` — Syncs vim registers (0-9, *, +, unnamed) with tmux buffers

**Infrastructure modules**:
- `wrapper/tmux.lua` — All tmux interaction via `io.popen` over the tmux socket (`$TMUX` env var). Direction mapping: hjkl -> LDUR (tmux flags)
- `wrapper/nvim.lua` — Thin wrapper over vim.fn.winnr and vim.cmd.wincmd
- `layout/` — Parses tmux's `window_layout` format string into pane geometry, then checks if a pane is at a border
- `configuration/` — Deep-merges user options over defaults, validates tmux version requirements
- `log/` — Multi-channel logging (file at `~/.cache/nvim/tmux.nvim.log`, vim.notify)
- `version/` — Semantic version parsing and comparison for tmux version checks

## Direction Convention

The codebase uses vim-style hjkl directions internally. The tmux wrapper translates to tmux flags: `h->L, j->D, k->U, l->R`. Navigation module also maps to i3 directions: `h->left, j->down, k->up, l->right`.

## External Dependencies

- `mapper` module (required by `keymaps.lua`) — external keymap utility, not part of this module

## Testing

No tests exist yet for this module. The parent Neovim config has test infrastructure:
- Framework: Plenary (unit) and Mini.test (integration)
- Runner: `~/.config/nvim/scripts/run_tests.sh [unit|integration|all]`
- Test location: `~/.config/nvim/tests/`
