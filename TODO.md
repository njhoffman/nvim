# TODO

Open work on this config, grouped by project. Each completed item is released (see CLAUDE.md "Versioning and
releases"); related items can be combined into one release. Counts were measured on 2026-10-19 against NVIM
v0.13.0-dev-1915; re-measure before starting an item. Specs and reference notes live in [docs/](docs/README.md).

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
removing it. Move removals to `~/.local/backup/nvim/`, keeping their repo paths (v0.21.0 on; earlier releases used
`~/.local/backup/nvim-refactor/` and `~/.local/backup/telescope/`).

- [x] **Unreferenced Lua modules.** (p2) [chore] v0.21.0 moved 275 modules that nothing requires to the backup,
      among them `colorschemes/nord-nvim/` (57), `utils/` (27), `stats/` (17), `tracker/` (13) and the unloaded
      `configs/hydra`, `codecompanion` and `chrome-remote` submodules. Kept: modules loaded by a string-built name
      (`tracker/sources`, `satellite/handlers`, `configs/telescope/actions`), overrides of installed-plugin modules
      (`lazy/`, `u/`, `yanky/storage/sqlite.lua`, ...) and LuaLS type files.
- [x] **Configs without a plugin spec.** (p2) [chore] v0.21.0 moved the 87 configs that lazy matches to no spec and
      nothing requires, plus the 10 unreferenced `*-example` / `reference` files, to the backup.
- [x] **Disabled plugin specs.** (p2) [chore] v0.21.0 removed 27 disabled specs and backed up their configs (spec text
      in `~/.local/backup/nvim/lua/plugins/removed-disabled-specs.lua`). Kept with a reason comment: lualine, windline,
      quicknote, markpan.
- [ ] **Upstream defaults copies.** (p3) [docs] `*.defaults.lua` copies of upstream plugin defaults (avante, helpview,
      mini-diff, mini-files, mini-jump2d, mini-visits, neo-tree, neocodeium, nvim-colorizer, navbuddy, oil, yazi) are
      loaded by nothing. Move the ones worth keeping to `docs/reference/plugin-defaults/` and delete the rest.
- [ ] **Committed scratch space.** (p3) [chore] `scratch/`: move it out of the repo or gitignore it
      (`lua/configs/tmp/` went to the backup in v0.21.0)
- [ ] **Commented-out code blocks.** (p3) [refactor] v0.31.3 removed 355 blocks of 5+ lines (about 5,000 lines) that parse
      as Lua or are clearly code, outside vendored copies, `*.defaults.lua` and the in-progress `tracker` and `runner`;
      disabled plugin specs moved to `docs/reference/commented-out-plugin-specs.md`, the rest is in
      `~/.local/backup/nvim/commented-code-2026-11-04.md`. Left: about 2,200 lines of mixed notes and code that need
      reading, and blocks under 5 lines, kept on purpose as option toggles.
- [ ] **`lib/mapper/utils.lua` does not parse.** (p3) [bug] Line 6-7 has a statement after `return`, and nothing requires
      the file. Fix or back it up.
- [ ] **Orphaned top-level modules.** (p2) [chore] Nothing requires `lua/quickfix/`, `lua/notifications/` (only a
      commented-out line in `init.lua`), `lua/histories/`, `lua/watcher/`, `lua/winsizer/`, `lua/llm-prompts.lua` or
      `lua/llm-providers.lua` (used only by `llm-prompts`). Found during the `lua/` layout refactor, which left them in
      place. Move the ones worth keeping to `lua/modules/` and wire them up, back up the rest.

## 3. Simplify folder structure and config setup

- [ ] **Shadowed plugin modules.** (p1) [bug] These `lua/` directories have the same module name as an installed plugin,
      so whichever comes first on the runtimepath wins and plugin updates silently diverge: `nvim-web-devicons`, `mini`,
      `telescope`, `yanky`, `frecency`, `file_history`, `import`, `helpview`, `nerdy`, `reactive`, `baleia`, `bars`,
      `lazy`, `u`, `utils` (collides with `text-case.nvim`). Options for each: upstream the change, use a fork in the
      spec (as done for telescope and hover.nvim), or rename the local module. The vendored `plenary` copy went to the
      backup in v0.23.0.
- [x] **Standard layout for `lua/`.** (p2) [refactor] 83 top-level `lua/` entries. Group them along common Neovim config
      practice: `lua/core/` (globals, options, keymaps, commands, autocommands), `lua/plugins/` (specs), `lua/configs/`
      (plugin config), `lua/modules/` (own plugins-in-progress such as runner, stats, tracker, watcher, tail, unicode,
      glyph-guard, registers, quicknote, tmux). Move content between files where a module is split oddly. Candidates for
      extraction into their own repos (like hover.nvim) live in modules/.
      Done in v0.25.0-v0.27.0: `core/` (plus `lsp/`), `modules/` (17 modules and `markdown/`), `lib/` (logger, mapper,
      lodash, helpers); 81 -> 49 top-level entries. Left in place on purpose: vendored copies and shadowing modules
      (see "Shadowed plugin modules") and the orphans in project 2.
- [x] **Overlapping option files.** (p2) [refactor] `config.lua`, `settings.lua`, `user-options.lua`, `vim-options.lua`
      and `helpers.lua`: merge them into one options module plus utils
      Done: `config.lua` and `settings.lua` were unused and went to the backup (v0.25.0); the other two are
      `core/options/{user,vim}.lua` behind `core.options`; `helpers.lua` is `lib/helpers.lua` (v0.27.0).
- [ ] **Local plugins require config modules.** (p3) [refactor] `~/git/convey.nvim` requires `mapper`
      (`lua/convey/init.lua:64`, `views/status.lua:455`) and `~/git/what-key.nvim` requires `logger`
      (`lua/what-key/logger/init.lua:10`), both modules of this config, now `lib.mapper` / `lib.logger`.
      `core/globals/init.lua` aliases the old names with `package.preload` so they keep loading. Make both plugins
      `pcall` the require and fall back to `vim.keymap.set` / `vim.notify`, then drop the aliases.
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
- [x] **Update CLAUDE.md architecture.** (p3) [docs] Rewrite "Core Architecture" after the restructure; its init.lua
      load order and "Custom Modules" still list `devbox` and `hover`, which no longer exist under `lua/`
      Done in v0.27.0 for the new layout; revisit after "Two loaders" and "Shadowed plugin modules".

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
- [x] **Commit only report summaries.** (p2) [chore] Since v0.20.1 only `.reports/<timestamp>/summary.md` is tracked;
      the raw data is gitignored and stays local for deltas. 108 raw files (21 MB) were untracked; their blobs stay in
      history.
- [x] **report.sh hides why tests failed.** (p2) [bug] Since v0.20.0 a failed run moves the report to
      `.reports/failed/<timestamp>/` (with `tests.log`), prints failing tests and `Timeout:` lines, and shows each
      spec file's result live (`progress:` lines, `TEST_TIMEOUT` per file).
- [x] **Startup budget.** (p3) [perf] Startup and per-filetype render times are recorded with every release by
      `benchmarks/run` (via `scripts/report.sh X.Y.Z`), against the average of the previous 10 releases and a low-load
      baseline; table in `docs/PERFORMANCE.md`.
- [x] **Record a benchmark baseline.** (p2) [chore] Recorded 2026-11-02 at load 0.95 (10 sessions, v0.20.1): startup
      ready 1062 ms, settled 6460 ms, Markdown render 313-353 ms. Repeat after Neovim upgrades.
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
      in `lua/core/commands/scroll.lua`. Since v0.16.3, `lua/modules/jumpguard` lists a deleted file buffer again when it's entered
      and appends each return (and each failed `jump_scroll`) to `~/.local/state/nvim/jumpguard.log` with the jumplist,
      the deletion and the last messages. Next occurrence: read that log, then fix the cause.
- [x] **Snacks overrides telescope keymaps.** (p1) [bug] `lua/core/lsp/keymaps.lua` bound buffer-local `<C-t>` / `<M-T>` to
      Snacks diagnostics pickers on LSP attach, shadowing the global telescope `<C-t>`. They now open telescope
      diagnostics (buffer / workspace), covered by `tests/unit/lsp_keymaps_spec.lua` (v0.16.2). `<C-S-t>` has no
      mapping.
- [x] **prettierd formatters are no-ops.** (p1) [bug] The `prettierd` override and its `_js`/`_toml`/`_vue`/
      `_packagejson` variants in `lua/configs/conform.lua` passed no file, so nothing was formatted. They're removed in
      v0.20.2: conform's built-in `prettierd` formats css, html, json, yaml, js/ts, vue, Markdown and the rest; toml is
      left to taplo, and width/plugins come from prettier configs (`tests/unit/conform_config_spec.lua`).
- [ ] **neovim-tips writes into the config dir.** (p3) [bug] Loading `saxon1964/neovim-tips` creates
      `neovim_tips/user_tips.md` in `~/.config/nvim` (seen in the smoke test). Set its `user_file` option to a path
      under `stdpath("data")`.
- [ ] **action-hints errors are not contained.** (p3) [bug] `throttle` in `lua/action-hints/utils.lua` wraps `pcall`
      around `vim.schedule_wrap(...)`, which only schedules the callback; errors inside a provider still surface on
      every cursor move. `pcall` the provider inside the scheduled function and log failures once.
- [ ] **nvim.run errors in a non-interactive shell.** (p3) [bug] `nvim` is an alias for the zsh function `nvim.run`,
      so even `nvim --version` from a script or Claude Code's shell printed `mkdir: cannot create directory '/saved'`
      and `'/restart'`, bfs errors on those paths and `Failed to --listen: permission denied: "/nvim_15_@23_cerus"`.
      Its session and socket helpers build paths from a variable that is empty there. Not this repo's code: the fix
      belongs in the shell config, guarding the empty prefix.
- [x] **Most gitops pickers error.** (p2) [bug] v0.31.1: 8 of the 14 `:Telescope gitops <picker>` exports failed when
      called, and bare `:Telescope gitops` had no export. `modules.gitops.mappings` now includes `mappings/actions.lua`,
      `utils.git` has `get_repo`, `base_branch` returns one value, and bare `:Telescope gitops` opens the picker menu.
      `tests/unit/gitops_spec.lua` opens every export in a scratch repo.

## 7. Docs and code consistency

- [x] **Consolidate documentation into `docs/`.** (p2) [docs] v0.22.0 moved the markdown and keymap dumps from
      `doc/` and `lua/` to `docs/reference/`, indexed in `docs/README.md`. `doc/helpfiles/` stays: it is the source
      dir of `lua/core/commands/help.lua` (`_name.txt` is its naming convention, not drafts).
- [x] **Remove implemented or stale specs.** (p2) [docs] v0.22.0 moved `doc/specs/` to the backup; the open
      ExportColorscheme work is now in "Highlight exporters" (project 9).
- [ ] **Duplicate help files.** (p3) [chore] `doc/helpfiles/` has near-copies whose tags differ: `_devhints-bash.txt` /
      `devhints-bash.txt`, `_lua-regex.txt` / `lua-regex.txt`, `_keybinds-checklist.txt` / `extended-keys.txt`, and
      `template.txt` (a filled-in `_template.txt`). `doc/ack-test.txt` duplicates `doc/helpfiles/ack-test.txt`, and
      `doc/mini-surround.txt` and `doc/noice.nvim.txt` are copies of the plugins' own help, so `doc/tags` defines
      their tags twice. Keep one of each.
- [ ] **Help export bugs.** (p3) [bug] `export_help_files` in `lua/core/commands/help.lua` checks `cfg.dir_help`, which
      doesn't exist (so it always calls mkdir), compares the full glob path to `'_template.txt'` (so the template is
      always exported), and runs `:helptags` once per file. Fix the checks and run `:helptags` once at the end.
- [ ] **Fold sub-TODO files into this one.** (p2) [docs] `lua/configs/bars/TODO.md`, `lua/configs/vimade/TODO.md` and
      `lua/histories/TODO.md` hold open work that `/todo` doesn't see. Move open items here, move design notes to
      `docs/`, and delete the files.
- [x] **Triage TODO/FIXME comments.** (p2) [chore] v0.31.2: comments in own code moved to "Ideas from old code comments"
      below, stale ones deleted. What remains: comments from upstream in vendored copies (frecency, egrepify, undo,
      find_pickers, lsp_lines, structlog and others), linked `HACK` notes, and the ones inside dead code.
- [ ] **Consistent comments, style and structure.** (p2) [refactor] v0.31.4 ran StyLua over own code and v0.31.5 added
      one-line headers in `lua/core`, `lua/lib` and `lua/modules`. `lua/configs` and the Telescope extensions get no
      headers on purpose: their filenames already say what they are. Left: 12 files StyLua cannot parse because they
      use `goto` (this build only has Lua 5.1 syntax; `stylua --check` lists them), 17 files v0.31.4 did not format
      (13 in `modules/tmux`, 2 in `lib/lodash`, 2 in `modules/devdocs2`), and one structure for plugin configs (spec in
      `plugins/`, options in `configs/<name>.lua`), to do per directory after project 3.
- [ ] **Stale `lua/modules/tmux/CLAUDE.md`.** (p3) [docs] "Refactoring Status" lists `step_size`, `get_state()` and a broken
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
      (`lua/modules/markdown/backtick.lua`, v0.18.0). No language prompt.
- [ ] **Empty nested list item renders as a heading.** (p3) [bug] Starting an indented line with `-` under a list item
      styles the line above as an H2 until text follows the dash. This is CommonMark: a line of only `-` under paragraph
      text is a setext H2 underline, and an empty list item can't interrupt a paragraph. render-markdown
      `heading.setext = false` isn't enough on its own: treesitter's markdown `highlights.scm` still captures
      `setext_h2_underline` as `@markup.heading.2`, and about 98 files in `~/zettelkasten` use real setext headings.
      Options: a markdown-local `-` / `o` mapping that inserts a dash, a space and a placeholder until text is typed, or
      a render-markdown custom handler that skips setext H2s whose underline is a single `-` inside a list item.
- [x] **Consistent hard wrapping.** (p2) [feature] Markdown: prettierd reflows prose on save (`proseWrap`/`printWidth`
      120 from `~/.prettierrc.yml`, or a project's prettier config), typing wraps even on lines that were already too
      long (`formatoptions` without `l`), and `J` joins and reflows the paragraph with `gw` (`lua/modules/markdown/prose.lua`,
      `after/ftplugin/markdown.lua`, v0.19.0). Repo Markdown was reflowed once in v0.19.0.

## 9. Integrations plugin

Sync this config's highlights and keymaps out to other tools, so key choices and colors stay the same across the
terminal environment.

- [ ] **Plugin skeleton.** (p2) [feature] A module under `lua/modules/integrations/` (see project 3) with one exporter
      per target and `:Integrations export <target>`. Reuse the existing colorscheme export
      (`docs/reference/colorscheme-export.md`).
- [ ] **Highlight exporters.** (p2) [feature] Export the active highlights to other formats, starting with a bat /
      sublime `.tmTheme`, then tmux and fzf colors. Open from the old `doc/specs/todo.md`: `bat cache --build` fails
      on the generated theme with "'Dockerfile (with bash)' ... has unresolved context reference ByScope { scope:
      <source.json> ... }"; after export, write a report of two Lua tables, the highlight -> scope map used and the map
      of a full theme (catppuccin or tokyonight) with a best-guess match per scope or `""`, so missing highlights are
      easy to add.
- [ ] **Keymap compatibility report.** (p2) [feature] Compare nvim keymaps with zsh (zle and fzf widgets) and tmux
      bindings, list mismatches for the same action (file picker on `<C-p>` in nvim should be the fzf file widget in
      zsh; window navigation keys should match tmux pane navigation), and suggest changes.
- [ ] **AI-assisted analysis.** (p3) [feature] Use the existing LLM setup (codecompanion, `lua/configs/codecompanion/`)
      to map actions across tools whose bindings can't be matched by name, and to review other projects' keymaps for
      ways to make them more like nvim.
- [ ] **Generate integration code.** (p3) [feature] For the common targets (zsh, tmux, fzf, bat, lazygit), write the
      config snippets automatically from the report, for review before they land in `~/.shell` or `~/.tmux.conf`.

## 10. Ideas from old code comments

Collected from `TODO` comments in the code on 2026-11-04 (v0.31.2). Nothing here has been checked for still being wanted;
drop what no longer is.

- [ ] **Keymap ideas.** (p3) [feature] `core/keymaps.lua`: detect fold lines for the variable at the old line 82; tell vim
      and Lua apart and strip comments in the line-execute mapping; visual `<C-u>` / `<C-w>`; a which-key screen for the
      command line; operator mapping with shift/ctrl enter in visual mode; disable `<C-V>` in alacritty; return to the
      original position after select all; save the last visual selection before undo; swap and toggle `_` and `|`; a
      git-dir precheck for git mappings. `oil.open_float` did not work from a `<cmd>` mapping.
- [ ] **Command ideas.** (p3) [feature] `core/commands/`: attach buffer commands to the alternate service; toggle search
      and very magic modes in the command line and reopen it to show a notification; resume the visual selection after
      switching; handle `[-]` and `[ ]` in the Markdown autocmd; start page as last buffer; more `<C-S->` window keys.
      `help.lua`: editing a helpfile opens its source, export on save, consistent tag prefixes.
- [ ] **Autocommand and startup ideas.** (p3) [feature] Build helptags in `doc/` automatically; bring back the indented
      lines toggle (pandoc vs markdown); handle startup messages and `v:errmsg`.
- [ ] **Use the Lua API for abbreviations.** (p3) [refactor] `core/abbreviations.lua` and `utils/core.lua` `ftAbbr` still
      call `inoreabbrev`; `vim.keymap.set("ia", ...)` has been available since Neovim 0.10.
- [ ] **Noice ideas.** (p3) [feature] `configs/noice/`: popup with previous messages collapsed; scrolling and prepending
      in multiline views; enter on shift+enter, clear on ctrl+enter; a hotkey to toggle notify/popup/split views; a
      cmdline-and-popup preset; live eval (lua, shell, json, html, sql, git, chrome-remote, awk/grep/sed) with stackable
      data sources, help and examples; set the syntax to the filetype on the route at `routes.lua:84`.
- [ ] **Mini plugin ideas.** (p3) [feature] align: a column alignment step and a help screen. bracketed: dynamic `[[` and
      `]]`. move: replace it and unimpaired with a custom command that adds lines at the end of the file. operators:
      shift/ctrl enter in visual mode. surround: yank-surround text object, `n`/`N` traversal. visits: project and
      worktree data.
- [ ] **Other plugin config ideas.** (p3) [feature] barbecue: gradient arrows, right-hand orientation. bigfile: custom vim
      options. debugprint: motions before the output line, custom output function, insert on print. hydra: mini-surround
      search and autopair fast-wrap heads, a map with a virtual text handler, popup windows that are not notify.
      cmp: `<C-p>` / `<C-n>` with no words after the cursor, prefer this source over `nvim_lsp` on duplicates. dbee:
      autocmd on main window close. reactive: a different cursorline for the first which-key `d`. recall: more filter
      keys. registers: `j`/`k`, live paste preview, line count. substitute: a `Subs` description. all-recent: buffers per
      project. leaderf: directory options, alternate-file highlighting and last-edited time. which-key picker: function
      names as descriptions. tiny-glimmer: other paste keys. treesj: go to the first parenthesis on a non-toggleable node,
      hover with the node format. matchup: `<C-%>` as `[%`. yanky: `gcp`/`gbp` with indent, `gc<`/`gb<` inline.
- [ ] **Plugin config problems.** (p3) [bug] `vimade`: detect when it did not load, and why (`vimade/utils.lua`).
      `nvim-github-codesearch`: escape characters, highlight labels, the `per_page` problem. `projects` Telescope
      extension: a highlight sync problem.
- [ ] **Module ideas.** (p3) [feature] gitops: search all history (`git grep foo $(git rev-list --all)`). registers:
      optional hover output, keep the source filetype, an option at `ui.lua:226`. runner restart: keep the mode line at
      the bottom. sidebar: calculate the width, move global keymaps to config. stats info panel: more configuration
      points such as `selection_strategy`. projects: lock the project directory until the original buffer changes it.
      A plugin with a persistent mode (`plugins/main.lua`).
- [ ] **Library ideas.** (p3) [feature] logger: truncating, banner and time format options; only keys and max values in
      the inspect parser; pull message strings out of keyed objects in `notify.lua`; tmux pane width and a clearing
      function in `sinks.lua`. lodash: merge descriptions and examples with lookups. helptags: ignore tag comments starting
      with `;`. options picker: only show `option_str`. quality-of-life: treesitter for pattern and flags. devhints:
      pixels and percentages in `hintsbox.lua`.

