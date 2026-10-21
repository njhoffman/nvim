# Custom dashboard

Replace alpha-nvim with an in-repo module. This is a draft: the open questions are tracked as
project 4 in `TODO.md`.

## Location and API

- Module `lua/modules/dashboard/` (or `lua/dashboard/` if item 3 hasn't landed yet), with no
  hard plugin dependencies. `nvim-web-devicons` and `mini.icons` are optional.
- `require("dashboard").setup(opts)` and `:Dashboard` to reopen it
- `opts.sections` is an ordered list. Each section is a function
  `(ctx) -> { lines, highlights, items }`, where `ctx` holds width, height, cwd, and a
  project root. Users can reorder, remove or add sections without touching core code.

## When it opens

- Opens on `VimEnter` only when nvim starts with no file arguments, no stdin, and an empty,
  unmodified buffer
- Never opens for `nvim -`, `nvim <file>`, `nvim -c ...`, `git commit`, man pager (`MANPAGER`),
  firenvim, or headless/embedded UIs without a UI attached
- Does not open in sessions restored by `loader_session`

## Sections (default order)

1. Header: art from `configs/alpha/headers.lua`. Pick the largest variant that fits the window
   width and fall back to a one-line title.
2. Project: root (project_nvim detection), git branch, dirty file count, ahead/behind.
   Fetched asynchronously with `vim.system`, rendered as a placeholder until it resolves.
3. Recent files: top N `oldfiles` entries under cwd (reuse `lua/oldfiles`), with icons and
   paths relative to home
4. Sessions: recent sessions from `loader_session`
5. Actions: single-key actions (new file, find file, live grep, recent, sessions, config,
   Lazy, Mason, quit)
6. Footer: startup time and loaded/total plugin counts from `lazy.stats()`, nvim version, and
   config version from `git describe --tags`

## Interaction

- `j`/`k` and arrow keys move between actionable items only. `<CR>` activates the item. Each
  item's shortcut key works directly. `q` quits when the dashboard is the last window.
- Recent files are numbered `0`-`9` for direct open
- Buffer settings: `filetype=dashboard`, `buftype=nofile`, `bufhidden=wipe`, `nomodifiable`,
  no number/sign/fold columns, statusline and tabline hidden while focused
- Re-renders on `VimResized` and `ColorScheme`, and closes when the first real buffer is entered

## Highlights

- `DashboardHeader`, `DashboardSection`, `DashboardItem`, `DashboardKey`, `DashboardPath`,
  `DashboardFooter`, `DashboardMuted`, each defined with `default = true` and linked to core
  groups so colorschemes (nord-nick) can override them

## Performance

- Synchronous render under 5 ms, measured with the existing benchmarks in `lua/import/benchmarks`
- No `require` of telescope/snacks until an action runs
- Async sections never block the first paint

## Tests

- Unit:
  - layout and centering at several widths
  - header fallback
  - item navigation skips non-actionable lines
  - recent-files filtering by cwd
  - the auto-open predicate for each excluded start mode
- Integration: headless start with no args shows the dashboard buffer; `nvim file` does not

## Removal once shipped

- The alpha-nvim spec in `plugins/main.lua`, `configs/alpha/`, `configs/startup.lua`, and the
  snacks `dashboard = { enabled = false }` entry
- Replace `alpha`/`startify` in filetype exclusion lists (lualine, feline, ultimate-autopair,
  none-ls) with `dashboard`

