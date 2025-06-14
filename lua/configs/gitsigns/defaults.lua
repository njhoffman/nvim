--   on_attach = {
--     type = 'function',
--     description = [[
--       Callback called when attaching to a buffer. Mainly used to setup keymaps.
--       The buffer number is passed as the first argument.
--
--       This callback can return `false` to prevent attaching to the buffer.
--
--       Example: >lua
--         on_attach = function(bufnr)
--           if vim.api.nvim_buf_get_name(bufnr):match(<PATTERN>) then
--             -- Don't attach to specific buffers whose name matches a pattern
--             return false
--           end
--
--           -- Setup keymaps
--           vim.api.nvim_buf_set_keymap(bufnr, 'n', 'hs', '<cmd>lua require"gitsigns".stage_hunk()<CR>', {})
--           ... -- More keymaps
--         end
-- <
--     ]],
--   },
--
--   watch_gitdir = {
--     type = 'table',
--     deep_extend = true,
--     default = {
--       enable = true,
--       follow_files = true,
--     },
--     description = [[
--       When opening a file, a libuv watcher is placed on the respective
--       `.git` directory to detect when changes happen to use as a trigger to
--       update signs.
--
--       Fields: ~
--         • `enable`:
--             Whether the watcher is enabled.
--
--         • `follow_files`:
--             If a file is moved with `git mv`, switch the buffer to the new location.
--     ]],
--   },
--
--   diff_opts = {
--     type = 'table',
--     deep_extend = true,
--     default_change = function(callback)
--       vim.api.nvim_create_autocmd('OptionSet', {
--         group = vim.api.nvim_create_augroup('gitsigns.config.diff_opts', {}),
--         pattern = 'diffopt',
--         callback = callback,
--       })
--     end,
--     default = parse_diffopt,
--     default_help = "derived from 'diffopt'",
--     description = [[
--       Diff options. If the default value is used, then changes to 'diffopt' are
--       automatically applied.
--
--       Fields: ~
--         • algorithm: string
--             Diff algorithm to use. Values:
--             • "myers"      the default algorithm
--             • "minimal"    spend extra time to generate the
--                            smallest possible diff
--             • "patience"   patience diff algorithm
--             • "histogram"  histogram diff algorithm
--         • internal: boolean
--             Use Neovim's built in xdiff library for running diffs.
--         • indent_heuristic: boolean
--             Use the indent heuristic for the internal
--             diff library.
--         • vertical: boolean
--             Start diff mode with vertical splits.
--         • linematch: integer
--             Enable second-stage diff on hunks to align lines.
--             Requires `internal=true`.
--        • ignore_blank_lines: boolean
--             Ignore changes where lines are blank.
--        • ignore_whitespace_change: boolean
--             Ignore changes in amount of white space.
--             It should ignore adding trailing white space,
--             but not leading white space.
--        • ignore_whitespace: boolean
--            Ignore all white space changes.
--        • ignore_whitespace_change_at_eol: boolean
--             Ignore white space changes at end of line.
--     ]],
--   },
--
--   base = {
--     type = 'string',
--     default_help = 'index',
--     description = [[
--       The object/revision to diff against.
--       See |gitsigns-revision|.
--     ]],
--   },
--
--   count_chars = {
--     type = 'table',
--     default = {
--       [1] = '1', -- '₁',
--       [2] = '2', -- '₂',
--       [3] = '3', -- '₃',
--       [4] = '4', -- '₄',
--       [5] = '5', -- '₅',
--       [6] = '6', -- '₆',
--       [7] = '7', -- '₇',
--       [8] = '8', -- '₈',
--       [9] = '9', -- '₉',
--       ['+'] = '>', -- '₊',
--     },
--     description = [[
--       The count characters used when `signs.*.show_count` is enabled. The
--       `+` entry is used as a fallback. With the default, any count outside
--       of 1-9 uses the `>` character in the sign.
--
--       Possible use cases for this field:
--         • to specify unicode characters for the counts instead of 1-9.
--         • to define characters to be used for counts greater than 9.
--     ]],
--   },
--
--   status_formatter = {
--     type = 'function',
--     --- @param status Gitsigns.StatusObj
--     --- @return string
--     default = function(status)
--       local added, changed, removed = status.added, status.changed, status.removed
--       local status_txt = {}
--       if added and added > 0 then
--         table.insert(status_txt, '+' .. added)
--       end
--       if changed and changed > 0 then
--         table.insert(status_txt, '~' .. changed)
--       end
--       if removed and removed > 0 then
--         table.insert(status_txt, '-' .. removed)
--       end
--       return table.concat(status_txt, ' ')
--     end,
--     description = [[
--       Function used to format `b:gitsigns_status`.
--     ]],
--   },
--
--   max_file_length = {
--     type = 'number',
--     default = 40000,
--     description = [[
--       Max file length (in lines) to attach to.
--     ]],
--   },
--
--   preview_config = {
--     type = 'table',
--     deep_extend = true,
--     default = {
--       style = 'minimal',
--       relative = 'cursor',
--       row = 0,
--       col = 1,
--     },
--     description = [[
--       Option overrides for the Gitsigns preview window. Table is passed directly
--       to `nvim_open_win`.
--     ]],
--   },
--
--   auto_attach = {
--     type = 'boolean',
--     default = true,
--     description = [[
--       Automatically attach to files.
--     ]],
--   },
--
--   attach_to_untracked = {
--     type = 'boolean',
--     default = false,
--     description = [[
--       Attach to untracked files.
--     ]],
--   },
--
--   update_debounce = {
--     type = 'number',
--     default = 100,
--     description = [[
--       Debounce time for updates (in milliseconds).
--     ]],
--   },
--
--   current_line_blame = {
--     type = 'boolean',
--     default = false,
--     description = [[
--       Adds an unobtrusive and customisable blame annotation at the end of
--       the current line.
--
--       The highlight group used for the text is `GitSignsCurrentLineBlame`.
--     ]],
--   },
--
--   current_line_blame_opts = {
--     type = 'table',
--     deep_extend = true,
--     default = {
--       virt_text = true,
--       virt_text_pos = 'eol',
--       virt_text_priority = 100,
--       delay = 1000,
--       use_focus = true,
--     },
--     description = [[
--       Options for the current line blame annotation.
--
--       Fields: ~
--         • virt_text: boolean
--           Whether to show a virtual text blame annotation.
--         • virt_text_pos: string
--           Blame annotation position. Available values:
--             `eol`         Right after eol character.
--             `overlay`     Display over the specified column, without
--                           shifting the underlying text.
--             `right_align` Display right aligned in the window.
--         • delay: integer
--           Sets the delay (in milliseconds) before blame virtual text is
--           displayed.
--         • ignore_whitespace: boolean
--           Ignore whitespace when running blame.
--         • virt_text_priority: integer
--           Priority of virtual text.
--         • use_focus: boolean
--           Enable only when buffer is in focus
--         • extra_opts: string[]
--           Extra options passed to `git-blame`.
--     ]],
--   },
--
--           • `<abbrev_sha>`
--           • `<orig_lnum>`
--           • `<final_lnum>`
--           • `<author>`
--           • `<author_mail>`
--           • `<author_time>` or `<author_time:FORMAT>`
--           • `<author_tz>`
--           • `<committer>`
--           • `<committer_mail>`
--           • `<committer_time>` or `<committer_time:FORMAT>`
--           • `<committer_tz>`
--           • `<summary>`
--           • `<previous>`
--           • `<filename>`

--         For `<author_time:FORMAT>` and `<committer_time:FORMAT>`, `FORMAT` can
--         be any valid date format that is accepted by `os.date()` with the
--         addition of `%R` (defaults to `%Y-%m-%d`):
--
--           • `%a`  abbreviated weekday name (e.g., Wed)
--           • `%A`  full weekday name (e.g., Wednesday)
--           • `%b`  abbreviated month name (e.g., Sep)
--           • `%B`  full month name (e.g., September)
--           • `%c`  date and time (e.g., 09/16/98 23:48:10)
--           • `%d`  day of the month (16) [01-31]
--           • `%H`  hour, using a 24-hour clock (23) [00-23]
--           • `%I`  hour, using a 12-hour clock (11) [01-12]
--           • `%M`  minute (48) [00-59]
--           • `%m`  month (09) [01-12]
--           • `%p`  either "am" or "pm" (pm)
--           • `%S`  second (10) [00-61]
--           • `%w`  weekday (3) [0-6 = Sunday-Saturday]
--           • `%x`  date (e.g., 09/16/98)
--           • `%X`  time (e.g., 23:48:10)
--           • `%Y`  full year (1998)
--           • `%y`  two-digit year (98) [00-99]
--           • `%%`  the character `%´
--           • `%R`  relative (e.g., 4 months ago)
--
--       When a function:
--         Parameters: ~
--           {name}       Git user name returned from `git config user.name` .
--           {blame_info} Table with the following keys:
--                          • `abbrev_sha`: string
--                          • `orig_lnum`: integer
--                          • `final_lnum`: integer
--                          • `author`: string
--                          • `author_mail`: string
--                          • `author_time`: integer
--                          • `author_tz`: string
--                          • `committer`: string
--                          • `committer_mail`: string
--                          • `committer_time`: integer
--                          • `committer_tz`: string
--                          • `summary`: string
--                          • `previous`: string
--                          • `filename`: string
--                          • `boundary`: true?
--
--                        Note that the keys map onto the output of:
--                          `git blame --line-porcelain`
--
--         Return: ~
--           The result of this function is passed directly to the `opts.virt_text`
--           field of |nvim_buf_set_extmark| and thus must be a list of
--           [text, highlight] tuples.
--     ]],
--   },
--
--   current_line_blame_formatter_nc = {
--     type = { 'string', 'function' },
--     default = ' <author>',
--     description = [[
--       String or function used to format the virtual text of
--       |gitsigns-config-current_line_blame| for lines that aren't committed.
--
--       See |gitsigns-config-current_line_blame_formatter| for more information.
--     ]],
--   },
--
--   trouble = {
--     type = 'boolean',
--     default = function()
--       local has_trouble = pcall(require, 'trouble')
--       return has_trouble
--     end,
--     default_help = 'true if installed',
--     description = [[
--       When using setqflist() or setloclist(), open Trouble instead of the
--       quickfix/location list window.
--     ]],
--   },
--
--   _git_version = {
--     type = 'string',
--     default = 'auto',
--     description = [[
--       Version of git available. Set to 'auto' to automatically detect.
--     ]],
--   },
--
--   _verbose = {
--     type = 'boolean',
--     default = false,
--     description = [[
--       More verbose debug message. Requires debug_mode=true.
--     ]],
--   },
--
--   _test_mode = {
--     description = 'Enable test mode',
--     type = 'boolean',
--     default = false,
--   },
--
--   word_diff = {
--     type = 'boolean',
--     default = false,
--     description = [[
--       Highlight intra-line word differences in the buffer.
--       Requires `config.diff_opts.internal = true` .
--
--       Uses the highlights:
--         • For word diff in previews:
--           • `GitSignsAddInline`
--           • `GitSignsChangeInline`
--           • `GitSignsDeleteInline`
--         • For word diff in buffer:
--           • `GitSignsAddLnInline`
--           • `GitSignsChangeLnInline`
--           • `GitSignsDeleteLnInline`
--         • For word diff in virtual lines (e.g. show_deleted):
--           • `GitSignsAddVirtLnInline`
--           • `GitSignsChangeVirtLnInline`
--           • `GitSignsDeleteVirtLnInline`
--     ]],
--   },
--
local defaultSettings = {

  signs = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "▁" },
    topdelete = { text = "▔" },
    changedelete = { text = "~" },
    untracked = { text = "┆" },
  },
  signs_staged = {
    add = { text = "┃" },
    change = { text = "┃" },
    delete = { text = "▁" },
    topdelete = { text = "▔" },
    changedelete = { text = "~" },
  },
  attach_to_untracked = false,
  auto_attach = true,
  base = "",
  culhl = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_formatter = " <author>, <author_time:%R> - <summary> ",
  current_line_blame_formatter_nc = " <author> ", -- non-committed lines
  debug_mode = false,
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  show_deleted = false,
  sign_priority = 6,
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  signs_staged_enable = true,
  update_debounce = 100,
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  preview_config = {
    -- Options passed to nvim_open_win
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
  trouble = function()
    -- open trouble instead of qflist
    local has_trouble = pcall(require, "trouble")
    return has_trouble
  end,
  _git_version = "auto",
  _new_sign_calc = false,
  _refresh_staged_on_update = false,
  _test_mode = false,
  _threaded_diff = true,
  _verbose = false,
  on_attach = function(bufnr) end,
  -- Asynchronous hook called before attaching to a buffer. Mainly used to configure detached worktrees.
  _on_attach_pre = function(bufnr, callback) end,

  watch_gitdir = {
    enable = true,
    follow_files = true,
  },

  status_formatter = nil, -- Use default
}

-- Revision notation
-- Object        Meaning ~
-- @             Version of file in the commit referenced by @ aka HEAD
-- main          Version of file in the commit referenced by main
-- main^         Version of file in the parent of the commit referenced by main
-- main~         "
-- main~1        "
-- main...other  Version of file in the merge base of main and other
-- @^            Version of file in the parent of HEAD
-- @~2           Version of file in the grandparent of HEAD
-- 92eb3dd       Version of file in the commit 92eb3dd
-- :1            The file's common ancestor during a conflict
-- :2            The alternate file in the target branch during a conflict

-- • `GitSignsAdd`   (for normal text signs)
-- • `GitSignsAddNr` (for signs when `config.numhl == true`)
-- • `GitSignsAddLn `(for signs when `config.linehl == true`)
-- • `GitSignsAddCul `(for signs when `config.culhl == true`)
-- • For word diff in previews:
--   • `GitSignsAddInline`
--   • `GitSignsChangeInline`
--   • `GitSignsDeleteInline`
-- • For word diff in buffer:
--   • `GitSignsAddLnInline`
--   • `GitSignsChangeLnInline`
--   • `GitSignsDeleteLnInline`
-- • For word diff in virtual lines (e.g. show_deleted):
--   • `GitSignsAddVirtLnInline`
--   • `GitSignsChangeVirtLnInline`
--   • `GitSignsDeleteVirtLnInline`

return defaultSettings
