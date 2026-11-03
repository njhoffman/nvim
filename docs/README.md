# docs

Reference material for this config: notes, specs and code worth keeping to read, not to load. Nothing under `docs/` is
on the runtimepath. Vim help files (`:help` tags) stay in `doc/`.

- [PERFORMANCE.md](PERFORMANCE.md): startup and rendering benchmarks of the latest release, against the average of the
  previous 10 releases and the baseline (see `benchmarks/`).
- [specs/](specs/): designs for work not yet built.
  - [dashboard.md](specs/dashboard.md): in-repo replacement for alpha-nvim (TODO.md project 4).
- [reference/](reference/): records of finished work and code kept for reference.
  - [deprecated-apis.md](reference/deprecated-apis.md): the v0.13.0 - v0.14.0 deprecated API migration and what was left
    upstream.
  - [hlslens-templating.md](reference/hlslens-templating.md): lens templating draft for the nvim-hlslens fork.
  - [keymaps/](reference/keymaps/): Neovim's default keymaps from `index.txt` (`default_keymaps.md`, `.lua`), a dump
    of this config's keymaps (`keymaps_dump.lua`) and notes on extended keys in terminals and tmux
    (`extended_keys.md`).
  - [smoothie/](reference/smoothie/): the smoothie scroller's Lua port spec, benchmarking system and notes.
  - [colorscheme-export.md](reference/colorscheme-export.md): `:ColorschemeExport` usage and its bat theme mappings.
  - [bars-components.md](reference/bars-components.md): components of the bars statusline.
  - [vimade-notes.md](reference/vimade-notes.md): performance comparison of tint.nvim and vimade.
  - [ultimate-autopair.md](reference/ultimate-autopair.md): ultimate-autopair behavior notes.
  - [escape-nvim.md](reference/escape-nvim.md): help text of the vendored escape module (`lua/utils/escape/`).
  - [vim-mappings-notes.md](reference/vim-mappings-notes.md): old vim mapping notes (2021).

Personal help files are written in `doc/helpfiles/` (`_name.txt` sources, `_template.txt` for new ones) and exported
to `stdpath("data")/site/doc` by `lua/core/commands/help.lua`; they stay in `doc/`.

Adding reference code: put it in `reference/<topic>.md` (or `reference/<topic>/` for several files), one fenced block
per snippet with a one-line description above it, and link it here.
