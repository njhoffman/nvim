# TODO

Open work on this config, grouped by project. Each completed item is its own release (see
CLAUDE.md "Versioning and releases"). Counts were measured on 2026-10-19 against NVIM
v0.13.0-dev-1915; re-measure before starting an item. Specs and reference notes live in
[docs/](docs/README.md).

Items: `- [ ] **Title.** (pN) [category] summary`, with details on indented lines. Priority is
(p1) high, (p2) normal or (p3) low; categories are bug, feature, refactor, docs, test, chore
and perf. `(due YYYY-MM-DD)` adds a deadline. `/todo`, `/todo-pop` and `scripts/todo-status`
read this file.

## 1. Update deprecated code after the Neovim update

- [x] **Deprecated API migration.** (p1) [chore] Replaced every deprecated API in the config
      and added `tests/unit/deprecated_api_spec.lua` to keep them out (v0.13.0 - v0.14.0).
      The table and what was left upstream are in `docs/reference/deprecated-apis.md`.

## 2. Remove orphaned config and code

Both counts below come from heuristics and include false positives (relative requires,
string-built module names, `.defaults` / `__init` naming conventions). Verify each candidate
by grepping and doing a startup smoke test before removing it. Move removals to
`~/.local/backup/` as in v0.5.0 - v0.7.0.

- [ ] **Unreferenced Lua modules.** (p2) [chore] 103 candidates out of 1,566, concentrated in
      `configs/` (31), `telescope/` (11), `utils/` (10), `frecency/` (7), `tracker/` (5),
      `notifications/` (4), `logger/` (4)
- [ ] **Configs without a plugin spec.** (p2) [chore] 117 of 300 `lua/configs/` entries, e.g.
      `nvim-lsp-installer`, `kommentary`, `nvim-comment`, `nvim-tree`, `wilder`, `stabilize`,
      `heirline-example`, `luasnip-example`, `hydra/reference2`, `feline/reference`, `tmp/`.
      Delete the dead ones; move the `*-example` and `reference` files to `docs/reference/`.
- [ ] **Disabled plugin specs.** (p2) [chore] The 31 `enabled = false` and 1 `cond = false`
      specs: delete the spec and its config unless it's kept on purpose (then add a reason
      comment)
- [ ] **Upstream defaults copies.** (p3) [docs] `*.defaults.lua` copies of upstream plugin
      defaults (avante, helpview, mini-diff, mini-files, mini-jump2d, mini-visits, neo-tree,
      neocodeium, nvim-colorizer, navbuddy, oil, yazi) are loaded by nothing. Move the ones
      worth keeping to `docs/reference/plugin-defaults/` and delete the rest.
- [ ] **Committed scratch space.** (p3) [chore] `scratch/` and `lua/configs/tmp/`: move them
      out of the repo or gitignore them
- [ ] **Commented-out code blocks.** (p3) [refactor] e.g. `configs/alpha/init.lua` 131-200.
      Delete them, or move blocks kept as future implementations to `docs/reference/`.

## 3. Simplify folder structure and config setup

- [ ] **Shadowed plugin modules.** (p1) [bug] These `lua/` directories have the same module
      name as an installed plugin, so whichever comes first on the runtimepath wins and plugin
      updates silently diverge: `plenary` (500K vendored copy), `nvim-web-devicons`, `mini`,
      `telescope`, `yanky`, `frecency`, `file_history`, `import`, `helpview`, `nerdy`,
      `reactive`, `baleia`, `bars`, `lazy`, `u`, `utils` (collides with `text-case.nvim`).
      Options for each: upstream the change, use a fork in the spec (as done for telescope and
      hover.nvim), or rename the local module.
- [ ] **Standard layout for `lua/`.** (p2) [refactor] 83 top-level `lua/` entries. Group them
      along common Neovim config practice: `lua/core/` (globals, options, keymaps, commands,
      autocommands), `lua/plugins/` (specs), `lua/configs/` (plugin config), `lua/modules/`
      (own plugins-in-progress such as runner, stats, tracker, watcher, tail, unicode,
      glyph-guard, registers, quicknote, tmux). Move content between files where a module is
      split oddly. Candidates for extraction into their own repos (like hover.nvim) live in
      modules/.
- [ ] **Overlapping option files.** (p2) [refactor] `config.lua`, `settings.lua`,
      `user-options.lua`, `vim-options.lua` and `helpers.lua`: merge them into one options
      module plus utils
- [ ] **Two loaders.** (p2) [refactor] Clarify `loader.lua` + `loader/` against the
      `init.lua` -> `vim.import()` chain, or document why both exist
- [ ] **Competing implementations.** (p2) [refactor] Pick one per role:
  - statusline: bars (active), feline, lualine, heirline-example
  - dashboard: alpha (active), `configs/startup.lua`, snacks dashboard (disabled); replaced by
    project 4
  - pickers: telescope and snacks. The old note said to migrate telescope mappings to Snacks;
    project 6 now makes telescope win on conflicts. Decide which one owns picker keys.
- [ ] **Root clutter.** (p3) [chore] `unicode_table.txt`, `glyphs.json` (also
      `lua/glyphs.json`), `pnpm-lock.yaml`, `pyproject.toml`, `directives.lua`, `matchup.lua`;
      plus `parser/` + `parsers/` + `tree-sitter-spidercode/` for one parser
- [ ] **Lint/format configs.** (p3) [chore] `.luacheckrc`, `selene.toml`, `.lua-format`,
      `.stylua.toml`: keep StyLua plus one linter
- [ ] **Update CLAUDE.md architecture.** (p3) [docs] Rewrite "Core Architecture" after the
      restructure

## 4. Custom dashboard

Replace alpha-nvim with an in-repo module; the draft spec is `docs/specs/dashboard.md`.
Resolve these before implementing.

- [ ] **Header art.** (p2) [feature] Keep `big_header`, or make new art?
- [ ] **Session source.** (p2) [feature] `loader_session` only, or also
      `persisted`/`resession` if installed?
- [ ] **Actions and keys.** (p2) [feature] Final list of actions and their keys
- [ ] **Non-git project info.** (p2) [feature] Should project info show for non-git
      directories?

## 5. Additional suggestions

- [ ] **Track `lazy-lock.json`.** (p1) [chore] It's gitignored, so tags don't pin plugin
      versions and an older release can't be reproduced. Track it now that the config has its
      own repo.
- [ ] **CI.** (p2) [chore] Add a GitHub Actions workflow that runs `scripts/run_tests.sh all`
      and `stylua --check` on push and tags, with a pinned nvim nightly so upstream breakage
      like the `nvim_get_commands()` change shows up as a CI failure instead of a local
      surprise.
- [ ] **Faster coverage.** (p3) [perf] Build cluacov against LuaJIT; the pure-Lua hook makes
      `scripts/report.sh` take about 3 minutes.
- [ ] **Coverage targets.** (p3) [test] Add tests for the least-covered modules that tests
      already load: `project_nvim/root.lua` (8.6%), `components/diagnostics.lua` (12.8%),
      `utils/core.lua` (13.9%).
- [ ] **`scripts/run_tests.sh` cleanup.** (p3) [chore] `set -e` makes the `if [ $? -eq 0 ]`
      checks after each nvim call dead code; restructure it to use the exit status directly.
- [ ] **Commit only report summaries.** (p2) [chore] Each release commits a
      `.reports/<timestamp>/` folder of about 27k lines (mostly `coverage.txt`), which bloats
      history. Commit only `summary.md` and gitignore the rest; keep the latest full report
      locally so `scripts/report.sh` can still compute deltas.
- [ ] **Startup budget.** (p3) [perf] Record `--startuptime` in `scripts/report.sh` and track
      it across releases alongside cloc and coverage.
- [ ] **Health check.** (p3) [feature] Add `lua/health/config.lua` for `:checkhealth config`:
      failed configs from `utils.lazy.state`, missing external tools, shadowed modules.
- [ ] **nvim-hlslens lens templating.** (p3) [feature] Template the lens virtual text with
      default / near / nearest modes and rename the HlSearch groups, in the `~/git/nvim-hlslens`
      fork. Draft in `docs/reference/hlslens-templating.md`.

## 6. Bugs

- [x] **action-hints code action range crash.** (p1) [bug] Visual selections touching an empty
      line passed column -1 to `vim.lsp.util.make_given_range_params`, so `vim.range.mark`
      threw "index out of range" from a scheduled callback. `range_from_selection` in
      `lua/action-hints/providers/codeactions.lua` now uses `getregionpos()` and clamps columns.
- [ ] **Reopening a deleted buffer with Ctrl-O.** (p1) [bug] After deleting a buffer, `<C-o>`
      to jump back gives "buffer not found", and when the file does reopen it is missing from
      the tabline. Check the bdelete command in use (`lua/commands/buffer.lua`, bufferline or
      the bars tabline) against how the jumplist keeps entries for wiped buffers: `:bwipeout`
      drops the buffer number the jumplist points at, `:bdelete` keeps it unlisted, and an
      unlisted buffer that is reloaded is not shown until `buflisted` is set again.
- [ ] **Snacks overrides telescope keymaps.** (p1) [bug] Some telescope mappings are now bound
      by Snacks, e.g. `<C-t>` / `<C-S-t>` open a Snacks picker instead of telescope. Find
      where Snacks sets picker keys (snacks spec `keys`, `picker` config, or a keymaps file
      that loads after `configs/telescope.lua`) and make telescope's mappings take precedence.
- [ ] **action-hints errors are not contained.** (p3) [bug] `throttle` in
      `lua/action-hints/utils.lua` wraps `pcall` around `vim.schedule_wrap(...)`, which only
      schedules the callback; errors inside a provider still surface on every cursor move.
      `pcall` the provider inside the scheduled function and log failures once.

## 7. Docs and code consistency

- [ ] **Consolidate documentation into `docs/`.** (p2) [docs] Keep `doc/` for vim help files
      only. Move markdown and notes there into `docs/`: `doc/*.md`, `doc/specs/`,
      `doc/helpfiles/_*.txt` drafts, `lua/commands/README_colorscheme_export.md`,
      `lua/commands/tips/notes.md`, `lua/configs/bars/COMPONENTS.md`,
      `lua/configs/ultimate-autopair/reference.md`, `lua/configs/vimade/NOTES.md`,
      `lua/smoothie/*.md`, `lua/utils/escape/setup.md`, `neovim_tips/`. Index each in
      `docs/README.md`.
- [ ] **Remove implemented or stale specs.** (p2) [docs] `doc/specs/main.md`,
      `doc/specs/scratch.md` and `doc/specs/todo.md` are old task prompts (feline -> lualine
      migration, silence command); delete the ones already done and fold anything still open
      into this file.
- [ ] **Fold sub-TODO files into this one.** (p2) [docs] `lua/configs/bars/TODO.md`,
      `lua/configs/vimade/TODO.md` and `lua/histories/TODO.md` hold open work that `/todo`
      doesn't see. Move open items here, move design notes to `docs/`, and delete the files.
- [ ] **Triage TODO/FIXME comments.** (p2) [chore] 248 in `lua/` outside plenary, mostly
      `configs/` (68 files) and `telescope/` (20). Turn real work into items here and delete
      the rest.
- [ ] **Consistent comments, style and structure.** (p2) [refactor] Make module layout and
      comments consistent: a one-line header comment per module, short comments on non-obvious
      code only, StyLua across the tree, and one structure for plugin configs (spec in
      `plugins/`, options in `configs/<name>.lua`). Do this per directory after project 3.

## 8. Editing behavior

- [ ] **Shift by 2 spaces.** (p2) [bug] `<<` / `>>` shift by 4. Find what sets `shiftwidth`
      (global options, ftplugins, editorconfig, or `vim-sleuth`/`guess-indent` detection) and
      make the default 2. Visual-mode `<` / `>` should shift only the selected block and keep
      the selection (`vnoremap < <gv`, `> >gv`).
- [ ] **Wrap code blocks in markdown.** (p3) [feature] A quicker way to wrap a visual selection
      or the current paragraph in a fenced block, prompting for the language (e.g. a
      mini.surround / nvim-surround custom surrounding or a dedicated keymap).
- [ ] **Consistent hard wrapping.** (p2) [feature] Typing wraps automatically at `textwidth`,
      but joining, pasting and moving text leave lines too long or too short, and fixing them
      by hand makes it worse. Options: reformat the paragraph after `J`/paste/move (`gw` on the
      changed range), `formatoptions+=a` per filetype for prose, or a formatter on save
      (prettier `proseWrap`, `mdformat --wrap`). Decide per filetype; code comments only need
      `formatoptions+=c` with a reformat key.

## 9. Integrations plugin

Sync this config's highlights and keymaps out to other tools, so key choices and colors stay
the same across the terminal environment.

- [ ] **Plugin skeleton.** (p2) [feature] A module under `lua/modules/integrations/` (see
      project 3) with one exporter per target and `:Integrations export <target>`. Reuse the
      existing colorscheme export (`lua/commands/README_colorscheme_export.md`).
- [ ] **Highlight exporters.** (p2) [feature] Export the active highlights to other formats,
      starting with a bat / sublime `.tmTheme`, then tmux and fzf colors.
- [ ] **Keymap compatibility report.** (p2) [feature] Compare nvim keymaps with zsh (zle and
      fzf widgets) and tmux bindings, list mismatches for the same action (file picker on
      `<C-p>` in nvim should be the fzf file widget in zsh; window navigation keys should
      match tmux pane navigation), and suggest changes.
- [ ] **AI-assisted analysis.** (p3) [feature] Use the existing LLM setup (codecompanion /
      `lua/llm-config.lua`) to map actions across tools whose bindings can't be matched by
      name, and to review other projects' keymaps for ways to make them more like nvim.
- [ ] **Generate integration code.** (p3) [feature] For the common targets (zsh, tmux, fzf,
      bat, lazygit), write the config snippets automatically from the report, for review
      before they land in `~/.shell` or `~/.tmux.conf`.
