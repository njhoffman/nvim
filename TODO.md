# TODO

Open work on this config, grouped by project. Each completed item is its own release (see CLAUDE.md "Versioning and
releases"). Counts were measured on 2026-10-19 against NVIM v0.13.0-dev-1915; re-measure before starting an item. Specs
and reference notes live in [docs/](docs/README.md).

Items: `- [ ] **Title.** (pN) [category] summary`, with details on indented lines. Priority is (p1) high, (p2) normal or
(p3) low; categories are bug, feature, refactor, docs, test, chore and perf. `(due YYYY-MM-DD)` adds a deadline.
`/todo`, `/todo-pop` and `scripts/todo-status` read this file.

Reviewed: 2026-11-01

## 1. Update deprecated code after the Neovim update

- [x] **Deprecated API migration.** (p1) [chore] Replaced every deprecated API in the config and added
      `tests/unit/deprecated_api_spec.lua` to keep them out (v0.13.0 - v0.14.0). The table and what was left upstream
      are in `docs/reference/deprecated-apis.md`.

## 2. Remove orphaned config and code

Both counts below come from heuristics and include false positives (relative requires, string-built module names,
`.defaults` / `__init` naming conventions). Verify each candidate by grepping and doing a startup smoke test before
removing it. Move removals to `~/.local/backup/` as in v0.5.0 - v0.7.0.

- [ ] **Unreferenced Lua modules.** (p2) [chore] 103 candidates out of 1,566, concentrated in `configs/` (31),
      `telescope/` (11), `utils/` (10), `frecency/` (7), `tracker/` (5), `notifications/` (4), `logger/` (4)
- [ ] **Configs without a plugin spec.** (p2) [chore] 117 of 300 `lua/configs/` entries, e.g. `nvim-lsp-installer`,
      `kommentary`, `nvim-comment`, `nvim-tree`, `wilder`, `stabilize`, `heirline-example`, `luasnip-example`,
      `hydra/reference2`, `feline/reference`, `tmp/`. Delete the dead ones; move the `*-example` and `reference` files
      to `docs/reference/`.
- [ ] **Disabled plugin specs.** (p2) [chore] The 31 `enabled = false` and 1 `cond = false` specs: delete the spec and
      its config unless it's kept on purpose (then add a reason comment)
- [ ] **Upstream defaults copies.** (p3) [docs] `*.defaults.lua` copies of upstream plugin defaults (avante, helpview,
      mini-diff, mini-files, mini-jump2d, mini-visits, neo-tree, neocodeium, nvim-colorizer, navbuddy, oil, yazi) are
      loaded by nothing. Move the ones worth keeping to `docs/reference/plugin-defaults/` and delete the rest.
- [ ] **Committed scratch space.** (p3) [chore] `scratch/` and `lua/configs/tmp/`: move them out of the repo or
      gitignore them
- [ ] **Commented-out code blocks.** (p3) [refactor] e.g. `configs/alpha/init.lua` 131-200. Delete them, or move blocks
      kept as future implementations to `docs/reference/`.

## 3. Simplify folder structure and config setup

- [ ] **Shadowed plugin modules.** (p1) [bug] These `lua/` directories have the same module name as an installed plugin,
      so whichever comes first on the runtimepath wins and plugin updates silently diverge: `plenary` (500K vendored
      copy), `nvim-web-devicons`, `mini`, `telescope`, `yanky`, `frecency`, `file_history`, `import`, `helpview`,
      `nerdy`, `reactive`, `baleia`, `bars`, `lazy`, `u`, `utils` (collides with `text-case.nvim`). Options for each:
      upstream the change, use a fork in the spec (as done for telescope and hover.nvim), or rename the local module.
- [ ] **Standard layout for `lua/`.** (p2) [refactor] 83 top-level `lua/` entries. Group them along common Neovim config
      practice: `lua/core/` (globals, options, keymaps, commands, autocommands), `lua/plugins/` (specs), `lua/configs/`
      (plugin config), `lua/modules/` (own plugins-in-progress such as runner, stats, tracker, watcher, tail, unicode,
      glyph-guard, registers, quicknote, tmux). Move content between files where a module is split oddly. Candidates for
      extraction into their own repos (like hover.nvim) live in modules/.
- [ ] **Overlapping option files.** (p2) [refactor] `config.lua`, `settings.lua`, `user-options.lua`, `vim-options.lua`
      and `helpers.lua`: merge them into one options module plus utils
- [ ] **Two loaders.** (p2) [refactor] Clarify `loader.lua` + `loader/` against the `init.lua` -> `vim.import()` chain,
      or document why both exist
- [ ] **Competing implementations.** (p2) [refactor] Pick one per role:
  - statusline: bars (active), feline, lualine, heirline-example
  - dashboard: alpha (active), `configs/startup.lua`, snacks dashboard (disabled); replaced by project 4
  - pickers: telescope and snacks. The old note said to migrate telescope mappings to Snacks; project 6 now makes
    telescope win on conflicts. Decide which one owns picker keys.
- [ ] **Root clutter.** (p3) [chore] `unicode_table.txt`, `glyphs.json` (also `lua/glyphs.json`), `pnpm-lock.yaml`,
      `pyproject.toml`, `directives.lua`, `matchup.lua`; plus `parser/` + `parsers/` + `tree-sitter-spidercode/` for one
      parser; also `plugin_udpates.txt`, a 4,092-line `:Lazy update` log from 2026-10-19 (7 failed builds, e.g.
      oxocarbon's fennel rock), which belongs outside the repo
- [ ] **Lint/format configs.** (p3) [chore] `.luacheckrc`, `selene.toml`, `.lua-format`, `.stylua.toml`: keep StyLua
      plus one linter
- [ ] **Update CLAUDE.md architecture.** (p3) [docs] Rewrite "Core Architecture" after the restructure

## 4. Custom dashboard

Replace alpha-nvim with an in-repo module; the draft spec is `docs/specs/dashboard.md`. Resolve these before
implementing.

- [ ] **Header art.** (p2) [feature] Keep `big_header`, or make new art?
- [ ] **Session source.** (p2) [feature] `loader_session` only, or also `persisted`/`resession` if installed?
- [ ] **Actions and keys.** (p2) [feature] Final list of actions and their keys
- [ ] **Non-git project info.** (p2) [feature] Should project info show for non-git directories?

## 5. Additional suggestions

- [x] **Track `lazy-lock.json`.** (p1) [chore] Tracked since v0.16.1, so each tag pins the plugin versions it was
      released with.
- [ ] **CI.** (p2) [chore] Add a GitHub Actions workflow that runs `scripts/run_tests.sh all` and `stylua --check` on
      push and tags, with a pinned nvim nightly so upstream breakage like the `nvim_get_commands()` change shows up as a
      CI failure instead of a local surprise.
- [ ] **Faster coverage.** (p3) [perf] Spec files run in parallel since v0.20.0 (unit coverage run 14 min -> 4.6 min),
      so the wall time is now the slowest spec under the pure-Lua hook: `unicode_search_spec` (263 s) and
      `deprecated_api_spec` (250 s); the next is 16 s. `deprecated_api_spec` scans files as text and covers nothing in
      `lua/`, so it could run without coverage; for the other, build cluacov against LuaJIT or trim the spec's data.
- [ ] **Coverage targets.** (p3) [test] Add tests for the least-covered modules that tests already load:
      `project_nvim/root.lua` (8.6%), `components/diagnostics.lua` (12.8%), `utils/core.lua` (13.9%).
- [x] **`scripts/run_tests.sh` cleanup.** (p3) [chore] Rewritten in v0.20.0 without `set -e`; each runner checks the
      exit status directly.
- [ ] **Commit only report summaries.** (p2) [chore] Each release commits a `.reports/<timestamp>/` folder of about 27k
      lines (mostly `coverage.txt`), which bloats history. Commit only `summary.md` and gitignore the rest; keep the
      latest full report locally so `scripts/report.sh` can still compute deltas.
- [x] **report.sh hides why tests failed.** (p2) [bug] Since v0.20.0 a failed run moves the report to
      `.reports/failed/<timestamp>/` (with `tests.log`), prints failing tests and `Timeout:` lines, and shows each
      spec file's result live (`progress:` lines, `TEST_TIMEOUT` per file).
- [x] **Startup budget.** (p3) [perf] Startup and per-filetype render times are recorded with every release by
      `benchmarks/run` (via `scripts/report.sh X.Y.Z`), against the average of the previous 10 releases and a low-load
      baseline; table in `docs/PERFORMANCE.md`.
- [ ] **Record a benchmark baseline.** (p2) [chore] Run `benchmarks/run --baseline` once the machine is quiet (load <=
      1.2 on 8 CPUs; it was 11 when the harness landed), so release tables get a "vs baseline" column. Repeat after
      Neovim upgrades.
- [ ] **Slow startup.** (p2) [perf] About 2-3 s to `UIEnter` and 8-11 s until idle in `benchmarks/run` (load ~10).
      Headless `--startuptime`: `init.lua` 2.1 s, of which `utils.helptags` 253 ms (via `commands.help`), `keymaps` 150
      ms, `configs.project` 91 ms, `configs.telescope` 70 ms, `devdocs2` 66 ms, and 432 ms in init.lua itself. After the
      dashboard draws, the main loop blocks for 0.1-1.5 s stretches over about 4.5 s, then an animation flushes at ~30
      fps for about 2 s. Defer helptags generation, profile the rest.
- [ ] **Hardcoded home paths.** (p3) [chore] 22 files under `lua/` hardcode `/home/nicholas` (e.g. `tail/utils.lua`,
      `configs/kiwi.lua`, `configs/copilot-lua.lua`, `project_nvim/root.lua`, the telescope fork `dir` in
      `plugins/main.lua`). Use `vim.env.HOME` / `vim.fn.expand("~")`; the old `~/.asdf/shims/node` path no longer
      exists.
- [ ] **Health check.** (p3) [feature] Add `lua/health/config.lua` for `:checkhealth config`: failed configs from
      `utils.lazy.state`, missing external tools, shadowed modules.
- [ ] **nvim-hlslens lens templating.** (p3) [feature] Template the lens virtual text with default / near / nearest
      modes and rename the HlSearch groups, in the `~/git/nvim-hlslens` fork. Draft in
      `docs/reference/hlslens-templating.md`.

## 6. Bugs

- [x] **satellite freezes large Markdown buffers.** (p1) [bug] `lua/satellite/util.lua` measured the bar with
      `nvim_win_text_height`, which ran the treesitter highlighter (with injections) over the whole buffer. It now uses
      its fold-aware row count (`use_text_height = false`), with the fold row offset fixed. Render: large.md 5058 -> 423
      ms, code.md 3007 -> 574 ms, medium.md 1136 -> 436 ms, small.md 645 -> 386 ms (v0.17.1).
- [x] **action-hints code action range crash.** (p1) [bug] Visual selections touching an empty line passed column -1 to
      `vim.lsp.util.make_given_range_params`, so `vim.range.mark` threw "index out of range" from a scheduled callback.
      `range_from_selection` in `lua/action-hints/providers/codeactions.lua` now uses `getregionpos()` and clamps
      columns.
- [ ] **Reopening a deleted buffer with Ctrl-O.** (p1) [bug] After deleting a buffer, `<C-o>` to jump back gives "buffer
      not found", and when the file does reopen it is missing from the tabline. Not reproduced headless (full config;
      `:bdelete`, `QuickClose`, `BufferDelete`, `BufferClose`, then `<C-o>`): the file reopens listed and in barbar.
      `<C-o>` / `<C-i>` belong to convey.nvim (`~/git/convey.nvim`, `keepjumps buffer N`), which shadows `jump_scroll`
      in `lua/commands/scroll.lua`. Since v0.16.3, `lua/jumpguard` lists a deleted file buffer again when it's entered
      and appends each return (and each failed `jump_scroll`) to `~/.local/state/nvim/jumpguard.log` with the jumplist,
      the deletion and the last messages. Next occurrence: read that log, then fix the cause.
- [x] **Snacks overrides telescope keymaps.** (p1) [bug] `lua/lsp/keymaps.lua` bound buffer-local `<C-t>` / `<M-T>` to
      Snacks diagnostics pickers on LSP attach, shadowing the global telescope `<C-t>`. They now open telescope
      diagnostics (buffer / workspace), covered by `tests/unit/lsp_keymaps_spec.lua` (v0.16.2). `<C-S-t>` has no
      mapping.
- [ ] **prettierd formatters are no-ops.** (p1) [bug] `formatters.prettierd` (and `prettierd_js`, `prettierd_toml`,
      `prettierd_vue`) in `lua/configs/conform.lua` set `stdin = false` with no `$FILENAME` argument, so prettierd gets
      neither the file nor its path: it exits 0 and nothing changes. Saving `a{color:red;background:blue}` in a .css
      file leaves it as is. Use `args = { "$FILENAME" }, stdin = true` (as `prettierd_md` does); prettierd ignores
      `--print-width`, so widths come from prettier configs. Affects css, scss, less, sass, graphql, handlebars, html,
      json, yaml, toml, js/ts and vue.
- [ ] **action-hints errors are not contained.** (p3) [bug] `throttle` in `lua/action-hints/utils.lua` wraps `pcall`
      around `vim.schedule_wrap(...)`, which only schedules the callback; errors inside a provider still surface on
      every cursor move. `pcall` the provider inside the scheduled function and log failures once.

## 7. Docs and code consistency

- [ ] **Consolidate documentation into `docs/`.** (p2) [docs] Keep `doc/` for vim help files only. Move markdown and
      notes there into `docs/`: `doc/*.md`, `doc/specs/`, `doc/helpfiles/_*.txt` drafts,
      `lua/commands/README_colorscheme_export.md`, `lua/commands/tips/notes.md`, `lua/configs/bars/COMPONENTS.md`,
      `lua/configs/ultimate-autopair/reference.md`, `lua/configs/vimade/NOTES.md`, `lua/smoothie/*.md`,
      `lua/utils/escape/setup.md`, `neovim_tips/`. Index each in `docs/README.md`.
- [ ] **Remove implemented or stale specs.** (p2) [docs] `doc/specs/main.md`, `doc/specs/scratch.md` and
      `doc/specs/todo.md` are old task prompts (feline -> lualine migration, silence command); delete the ones already
      done and fold anything still open into this file.
- [ ] **Fold sub-TODO files into this one.** (p2) [docs] `lua/configs/bars/TODO.md`, `lua/configs/vimade/TODO.md` and
      `lua/histories/TODO.md` hold open work that `/todo` doesn't see. Move open items here, move design notes to
      `docs/`, and delete the files.
- [ ] **Triage TODO/FIXME comments.** (p2) [chore] 248 in `lua/` outside plenary, mostly `configs/` (68 files) and
      `telescope/` (20). Turn real work into items here and delete the rest.
- [ ] **Consistent comments, style and structure.** (p2) [refactor] Make module layout and comments consistent: a
      one-line header comment per module, short comments on non-obvious code only, StyLua across the tree, and one
      structure for plugin configs (spec in `plugins/`, options in `configs/<name>.lua`). Do this per directory after
      project 3.
- [ ] **Stale `lua/tmux/CLAUDE.md`.** (p3) [docs] "Refactoring Status" lists `step_size`, `get_state()` and a broken
      `vim.tbl_get` in `resize/` and `keymaps.lua`, none of which exist any more, and "Testing" says no tests exist
      while `tests/unit/tmux_*_spec.lua` has five specs. Rewrite both sections; note that tmux next-3.9 prints
      `window_layout` as JSON, which `layout/parse.lua` handles alongside the classic format.

## 8. Editing behavior

- [x] **Shift by 2 spaces.** (p2) [bug] `<<` / `>>` shifted Markdown by 4: the runtime `ftplugin/markdown.vim` sets
      `shiftwidth=4` unless `g:markdown_recommended_style` is 0, which `vim-options.lua` now sets (v0.17.2). The global
      default was already 2 and visual `<` / `>` already keep the selection (`keymaps.lua`). Other filetypes with their
      own recommended style (e.g. Python's 4) are unchanged on purpose.
- [x] **Wrap code blocks in markdown.** (p3) [feature] Visual `` ` `` in Markdown toggles a code span (charwise, one
      line) or a ``` fence (linewise or multi-line), keeping the selection; on a wrapped selection it unwraps
      (`lua/md_backtick.lua`, v0.18.0). No language prompt.
- [ ] **Empty nested list item renders as a heading.** (p3) [bug] Starting an indented line with `-` under a list item
      styles the line above as an H2 until text follows the dash. This is CommonMark: a line of only `-` under paragraph
      text is a setext H2 underline, and an empty list item can't interrupt a paragraph. render-markdown
      `heading.setext = false` isn't enough on its own: treesitter's markdown `highlights.scm` still captures
      `setext_h2_underline` as `@markup.heading.2`, and about 98 files in `~/zettelkasten` use real setext headings.
      Options: a markdown-local `-` / `o` mapping that inserts a dash, a space and a placeholder until text is typed, or
      a render-markdown custom handler that skips setext H2s whose underline is a single `-` inside a list item.
- [x] **Consistent hard wrapping.** (p2) [feature] Markdown: prettierd reflows prose on save (`proseWrap`/`printWidth`
      120 from `~/.prettierrc.yml`, or a project's prettier config), typing wraps even on lines that were already too
      long (`formatoptions` without `l`), and `J` joins and reflows the paragraph with `gw` (`lua/md_prose.lua`,
      `after/ftplugin/markdown.lua`, v0.19.0). Repo Markdown was reflowed once in v0.19.0.

## 9. Integrations plugin

Sync this config's highlights and keymaps out to other tools, so key choices and colors stay the same across the
terminal environment.

- [ ] **Plugin skeleton.** (p2) [feature] A module under `lua/modules/integrations/` (see project 3) with one exporter
      per target and `:Integrations export <target>`. Reuse the existing colorscheme export
      (`lua/commands/README_colorscheme_export.md`).
- [ ] **Highlight exporters.** (p2) [feature] Export the active highlights to other formats, starting with a bat /
      sublime `.tmTheme`, then tmux and fzf colors.
- [ ] **Keymap compatibility report.** (p2) [feature] Compare nvim keymaps with zsh (zle and fzf widgets) and tmux
      bindings, list mismatches for the same action (file picker on `<C-p>` in nvim should be the fzf file widget in
      zsh; window navigation keys should match tmux pane navigation), and suggest changes.
- [ ] **AI-assisted analysis.** (p3) [feature] Use the existing LLM setup (codecompanion / `lua/llm-config.lua`) to map
      actions across tools whose bindings can't be matched by name, and to review other projects' keymaps for ways to
      make them more like nvim.
- [ ] **Generate integration code.** (p3) [feature] For the common targets (zsh, tmux, fzf, bat, lazygit), write the
      config snippets automatically from the report, for review before they land in `~/.shell` or `~/.tmux.conf`.
