# TODO

Each completed item is its own release (see CLAUDE.md "Versioning and releases"). Counts below
were measured on 2026-10-19 against NVIM v0.13.0-dev-1915 and v0.11.0 of this config; re-measure
before starting an item.

## 1. Update deprecated code after the Neovim update

The nvim build jumped from v0.13.0-dev-167 to v0.13.0-dev-1915. The `nvim_get_commands()`
`definition` change already broke one test. Counts exclude the vendored `lua/plenary/`.

- [x] Run `:checkhealth vim.deprecated` after a full startup to catch runtime-only usages,
      including ones coming from plugins and shadowed plugin modules
- [x] Replace deprecated APIs (hits / files):

| Deprecated                                          | Replacement                                         | Hits | Files |
| --------------------------------------------------- | --------------------------------------------------- | ---- | ----- |
| `vim.loop`                                          | `vim.uv`                                            | 127  | 77    |
| `nvim_buf_get_option` / `nvim_buf_set_option`       | `nvim_get_option_value` / `nvim_set_option_value`   | 86   | 42    |
| `nvim_win_get_option` / `nvim_win_set_option`       | `nvim_get_option_value` / `nvim_set_option_value`   | 22   | 13    |
| `nvim_get_option` / `nvim_set_option`               | `nvim_get_option_value` / `nvim_set_option_value`   | 9    | 8     |
| `nvim_err_writeln`                                  | `nvim_echo({...}, true, { err = true })`            | 28   | 14    |
| `nvim_buf_add_highlight`                            | `vim.hl.range` / `nvim_buf_set_extmark`             | 27   | 16    |
| `vim.tbl_flatten`                                   | `vim.iter(t):flatten():totable()`                   | 16   | 13    |
| `vim.lsp.get_active_clients`                        | `vim.lsp.get_clients`                               | 14   | 12    |
| `vim.lsp.buf_get_clients`                           | `vim.lsp.get_clients({ bufnr = ... })`              | 10   | 9     |
| `nvim_get_hl_by_name`                               | `nvim_get_hl(0, { name = ... })`                    | 12   | 5     |
| `vim.diagnostic.goto_next` / `goto_prev`            | `vim.diagnostic.jump({ count = +-1 })`              | 12   | 5     |
| `vim.diagnostic.disable` / `is_disabled`            | `vim.diagnostic.enable(false)` / `is_enabled()`     | 11   | 7     |
| `vim.lsp.buf.formatting`                            | `vim.lsp.buf.format`                                | 11   | 8     |
| `vim.highlight.*`                                   | `vim.hl.*`                                          | 10   | 9     |
| `vim.validate({ ... })` table form                  | `vim.validate(name, value, validator)`              | 15   | 8     |
| `client.supports_method(...)` (dot call)            | `client:supports_method(...)`                       | 7    | 5     |
| `vim.lsp.util.make_position_params()` (no encoding) | pass `win, client.offset_encoding`                  | 5    | 5     |
| `vim.tbl_islist`                                    | `vim.islist`                                        | 6    | 1     |
| `vim.str_utfindex` (old signature)                  | `vim.str_utfindex(s, encoding, index)`              | 6    | 4     |
| `nvim_exec`                                         | `nvim_exec2`                                        | 4    | 4     |
| `vim.lsp.start_client`                              | `vim.lsp.start`                                     | 3    | 3     |
| `vim.lsp.util.jump_to_location`                     | `vim.lsp.util.show_document`                        | 2    | 2     |
| `vim.region`                                        | `vim.fn.getregionpos`                               | 1    | 1     |
| `nvim-treesitter.ts_utils`, `query.get_node_text`   | `vim.treesitter.get_node_text`, `vim.treesitter.*`  | 20   | 9     |

- [x] Audit `nvim_get_commands()` consumers for the empty `definition` on Lua-callback commands
      (read `desc` instead)
- [x] Drop `vim.fn.has("nvim-0.x")` guards for versions older than the current build
- [x] Add a test or lint rule that fails on the patterns above so they don't come back

**Status (v0.13.0-v0.14.0):** done for the config repo. `tests/unit/deprecated_api_spec.lua` now fails on any of
these patterns. Not cleaned up:

- Deprecations inside third-party plugins in `lazy/`: copilot-cmp, hydra, git-conflict, bigfile, colortils,
  telescope-import, alpha, rest.nvim and a few telescope extensions. Fixing these means upstream issues or PRs.
- `~/git/telescope.nvim`: left its 180 `vim.F.if_nil` calls alone. Its CI tests stable and v0.10.4, but
  `vim.nonnil` needs 0.13, and the edit would conflict with upstream merges. They only warn until 0.15.
- `~/git/nvim-hlslens` and `~/git/what-key.nvim`: their remaining hits are in files with uncommitted work.

## 2. Remove orphaned config and code

Both counts below come from heuristics and include false positives (relative requires,
string-built module names, `.defaults` / `__init` naming conventions). Verify each candidate
by grepping and doing a startup smoke test before removing it. Move removals to
`~/.local/backup/` as in v0.5.0 - v0.7.0.

- [ ] Unreferenced Lua modules: 103 candidates out of 1,566, concentrated in `configs/` (31),
      `telescope/` (11), `utils/` (10), `frecency/` (7), `tracker/` (5), `notifications/` (4),
      `logger/` (4)
- [ ] `lua/configs/` entries with no matching plugin spec: 117 out of 300 candidates, e.g.
      `nvim-lsp-installer`, `kommentary`, `nvim-comment`, `nvim-tree`, `wilder`, `stabilize`,
      `heirline-example`, `luasnip-example`, `hydra/reference2`, `feline/reference`, `tmp/`
- [ ] The 31 `enabled = false` and 1 `cond = false` plugin specs: delete the spec and its config
      unless it's being kept on purpose (then add a reason comment)
- [ ] `*.defaults.lua` copies of upstream plugin defaults (avante, helpview, mini-diff,
      mini-files, mini-jump2d, mini-visits, neo-tree, neocodeium, nvim-colorizer, navbuddy, oil,
      yazi): decide whether to keep these as reference or delete them
- [ ] `scratch/` and `lua/configs/tmp/` are committed scratch space: move them out of the repo
      or gitignore them
- [ ] Commented-out code blocks (e.g. `configs/alpha/init.lua` 131-200)

## 3. Simplify folder structure and config setup

- [ ] **Shadowed plugin modules.** These `lua/` directories have the same module name as an
      installed plugin, so whichever comes first on the runtimepath wins and plugin updates
      silently diverge: `plenary` (500K vendored copy), `nvim-web-devicons`, `mini`,
      `telescope`, `yanky`, `frecency`, `file_history`, `import`, `helpview`, `nerdy`,
      `reactive`, `baleia`, `bars`, `lazy`, `u`, `utils` (collides with `text-case.nvim`).
      Options for each: upstream the change, use a fork in the spec (as done for telescope and
      hover.nvim), or rename the local module.
- [ ] **83 top-level `lua/` entries.** Group them into a few namespaces, e.g. `lua/core/`
      (globals, options, keymaps, commands, autocommands), `lua/plugins/` (specs),
      `lua/configs/` (plugin config), `lua/modules/` (own plugins-in-progress such as runner,
      stats, tracker, watcher, tail, unicode, glyph-guard, registers, quicknote, tmux).
      The candidates for extraction into their own repos (like hover.nvim) live in modules/.
- [ ] **Overlapping option files.** `config.lua`, `settings.lua`, `user-options.lua`,
      `vim-options.lua` and `helpers.lua`: merge them into one options module plus utils
- [ ] **Two loaders.** Clarify `loader.lua` + `loader/` against the `init.lua` -> `vim.import()`
      chain, or document why both exist
- [ ] **Competing implementations**, pick one per role:
  - statusline: bars (active), feline, lualine, heirline-example
  - dashboard: alpha (active), `configs/startup.lua`, snacks dashboard (disabled); replaced by
    item 4
  - pickers: telescope and snacks (see the existing Snacks note below)
- [ ] **Root clutter.** `unicode_table.txt`, `glyphs.json` (also `lua/glyphs.json`),
      `pnpm-lock.yaml`, `pyproject.toml`, `directives.lua`, `matchup.lua`; plus
      `parser/` + `parsers/` + `tree-sitter-spidercode/` for one parser
- [ ] **Lint/format configs.** `.luacheckrc`, `selene.toml`, `.lua-format`, `.stylua.toml`:
      keep StyLua plus one linter
- [ ] Update CLAUDE.md "Core Architecture" after the restructure

## 4. Custom dashboard

Replace alpha-nvim with an in-repo module. The spec below is a draft; resolve the open
questions before implementing.

### Spec

**Location and API**

- Module `lua/modules/dashboard/` (or `lua/dashboard/` if item 3 hasn't landed yet), with no
  hard plugin dependencies. `nvim-web-devicons` and `mini.icons` are optional.
- `require("dashboard").setup(opts)` and `:Dashboard` to reopen it
- `opts.sections` is an ordered list. Each section is a function
  `(ctx) -> { lines, highlights, items }`, where `ctx` holds width, height, cwd, and a
  project root. Users can reorder, remove or add sections without touching core code.

**When it opens**

- Opens on `VimEnter` only when nvim starts with no file arguments, no stdin, and an empty,
  unmodified buffer
- Never opens for `nvim -`, `nvim <file>`, `nvim -c ...`, `git commit`, man pager (`MANPAGER`),
  firenvim, or headless/embedded UIs without a UI attached
- Does not open in sessions restored by `loader_session`

**Sections (default order)**

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

**Interaction**

- `j`/`k` and arrow keys move between actionable items only. `<CR>` activates the item. Each
  item's shortcut key works directly. `q` quits when the dashboard is the last window.
- Recent files are numbered `0`-`9` for direct open
- Buffer settings: `filetype=dashboard`, `buftype=nofile`, `bufhidden=wipe`, `nomodifiable`,
  no number/sign/fold columns, statusline and tabline hidden while focused
- Re-renders on `VimResized` and `ColorScheme`, and closes when the first real buffer is entered

**Highlights**

- `DashboardHeader`, `DashboardSection`, `DashboardItem`, `DashboardKey`, `DashboardPath`,
  `DashboardFooter`, `DashboardMuted`, each defined with `default = true` and linked to core
  groups so colorschemes (nord-nick) can override them

**Performance**

- Synchronous render under 5 ms, measured with the existing benchmarks in `lua/import/benchmarks`
- No `require` of telescope/snacks until an action runs
- Async sections never block the first paint

**Tests**

- Unit:
  - layout and centering at several widths
  - header fallback
  - item navigation skips non-actionable lines
  - recent-files filtering by cwd
  - the auto-open predicate for each excluded start mode
- Integration: headless start with no args shows the dashboard buffer; `nvim file` does not

**Removal once shipped**

- The alpha-nvim spec in `plugins/main.lua`, `configs/alpha/`, `configs/startup.lua`, and the
  snacks `dashboard = { enabled = false }` entry
- Replace `alpha`/`startify` in filetype exclusion lists (lualine, feline, ultimate-autopair,
  none-ls) with `dashboard`

### Open questions

- [ ] Header art: keep `big_header`, or make new art?
- [ ] Session source: `loader_session` only, or also `persisted`/`resession` if installed?
- [ ] Final list of actions and their keys
- [ ] Should project info show for non-git directories?

## 5. Additional suggestions

- [ ] **Track `lazy-lock.json`.** It's gitignored, so tags don't pin plugin versions and an older
      release can't be reproduced. Track it now that the config has its own repo.
- [ ] **CI.** Add a GitHub Actions workflow that runs `scripts/run_tests.sh all` and
      `stylua --check` on push and tags, with a pinned nvim nightly so upstream breakage like
      the `nvim_get_commands()` change shows up as a CI failure instead of a local surprise.
- [ ] **Faster coverage.** Build cluacov against LuaJIT; the pure-Lua hook makes
      `scripts/report.sh` take about 3 minutes.
- [ ] **Coverage targets.** Add tests for the least-covered modules that tests already load:
      `project_nvim/root.lua` (8.6%), `components/diagnostics.lua` (12.8%),
      `utils/core.lua` (13.9%).
- [ ] **`scripts/run_tests.sh` cleanup.** `set -e` makes the `if [ $? -eq 0 ]` checks after each
      nvim call dead code; restructure it to use the exit status directly.
- [ ] **Startup budget.** Record `--startuptime` in `scripts/report.sh` and track it across
      releases alongside cloc and coverage.
- [ ] **Health check.** Add `lua/health/config.lua` for `:checkhealth config`: failed configs from
      `utils.lazy.state`, missing external tools, shadowed modules.

## Existing notes

### nvim-hlslens

I want to enable templating the hlslens virtual text.
There will be three modes:

- default: base template that can be shared between all modes
- near: template for the virtual text lens of of matches that are near the cursor but not the nearest
- nearest: template for the virtual text lens of of the nearest match

HlSearchNear CurSearch rename to HlSearchCur
HlSearchLens WildMenu rename to HlSearchLens
HlSearchLensNear CurSearch rename to HlSearchLensCur

HlSearch IncSearch rename to HlSearch

```lua

  render = render_formats(formats.default, formats.nearest, formats.near),
local styles = {
  bubble = { { "", "HlSearchReversed" }, { "", "HlSearchReversed" } },
  arrow = {
    { "", "HlSearchReversed" },
    { "", "HlSearchReversed" },
  },
  none = {
    { " ", "Ignore" },
    { " ", "Ignore" }, -- = padding
  },
}

local lens_style = "bubble" -- bubble/arrows/none
local render_formats = function(default_fmt, nearest_fmt, near_fmt)
  return function(render, plist, nearest, idx, r_idx)
    if nearest then
      return override_lens_2(render, plist, nearest, idx, r_idx)
    else
      return override_lens(render, plist, nearest, idx, r_idx)
    end
  end
end

local formats = {
  default = {
    { "", "HlSearchReversed" },
    { "%icon%", "HlSearchIcon" },
    { " " },
    { "%index%", "HlSearchIndex" },
    { "/", "HlSearch" },
    { "%total%", "HlSearchTotal" },
    { "", "HlSearchReversed" },
  },
  nearest = {
    { "", "HlSearchReversed" },
    { "%indicator%", "HlSearchIndicator}" },
    { " " },
    { "%index%", "HlSearchIndex" },
    { "", "HlSearchReversed" },
  },
  near = {
    { "", "HlSearchReversed" },
    { "%indicator%", "HlSearchIndicator}" },
    { " " },
    { "%index%", "HlSearchIndex" },
    { "", "HlSearchReversed" },
  },
}
```

### Snacks.nvim

- Migrate as much as possible of my telescope configuration to Snacks.nvim (escpecially the mappings)
