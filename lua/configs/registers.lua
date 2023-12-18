-- Call :Registers
-- Press " in normal or visual mode
-- Press CtrlR in insert mode
-- Use the Up and Down or CtrlP and CtrlN or CtrlJ and CtrlK keys to select the register you want to use and press Enter to apply it, or type the register you want to apply, which is one of the following:
-- " 0-9 a-z : . % # = * + _ /

---@field show string Which registers to show and in what order. Default is `"*+\"-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:"`.
---@field show_empty boolean Show the registers which aren't filled in a separate line. Default is `true`.
---@field bind_keys bind_keys_options|boolean Which keys to bind, `true` maps all keys and `false` maps no keys.
---@field events events_options Functions that will be called when certain events happen.
---@field symbols symbols_options Symbols used to replace text in the previous buffer.
---@field window window_options Floating window
---@field sign_highlights sign_highlights_options Highlights for the sign section of the window

-- bind_keys["j"] = registers.move_cursor_down()
-- bind_keys["k"] = registers.move_cursor_up()
-- TODO: fix j/k mappings, add live preview for paste/insert, add line count

local init_window = function(default_options)
  -- -- ⌜⌟⌜⌝ ┘｢｣  ┒┑┓┏┌┍┎ 🭼 🭿 └ ┕ ┖ ┗   ⎡ ⎣ ⎤ ⎦ ˨   ◝ ◟ ◞ ╰ 「」ꜚ﹁ ⇱ ﹂｢｣ ╮ ╯╰ ╭ 𛲖─ ━ ━ ─ ＿ ⎽⎯🭻▁
  -- -- border = { "↖", "─", "╮", "│", "╯", "─", "╰", "│" },
  -- -- border = { "↖", "─", "╮", "│", "│", "_", "│", "│" },
  -- border = { '╭', '─', '╮', '│', '│', '_', '│', '│' },
  -- zindex = 2,
  -- style = 'minimal',
  -- -- title = "Hover",
  -- -- titlepos = 'Center'
end

local registers = require('registers')
local preview = require('registers.preview')
local ui = require('registers.ui')

-- '*+"-/_=#%.0123456789abcdefghilmnopqrstuvwxyz:',
local layout_1 = function(win_opts)
  -- local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local new_reg = '*+"%0123456789abcgpwy:'
  local new_opts = vim.tbl_deep_extend('force', win_opts, {
    relative = 'win', -- editor, win, cursor, mouse
    anchor = 'NE', -- NW (default), SW, SE, NE
    row = 7,
    -- row = vim.api.nvim_win_get_height(0) - 1,
    -- row = cursor_row,
    col = vim.api.nvim_win_get_width(0),
  })
  return new_opts, new_reg
end

local layout_2 = function(win_opts)
  local new_reg = '*+"-/_=#%.0123456789abcdefghilmnopqrstuvwxyz:'
  local new_opts = vim.tbl_deep_extend('force', win_opts, {
    relative = 'win', -- editor, win, cursor, mouse
    anchor = 'SE',
    row = vim.api.nvim_win_get_height(0) - 1,
    col = vim.api.nvim_win_get_width(0),
  })
  return new_opts, new_reg
end

local layout_3 = function(win_opts)
  local new_reg = '*+"%01234abcpwy:'
  local new_opts = vim.tbl_deep_extend('force', win_opts, {
    relative = 'win', -- editor, win, cursor, mouse
    anchor = 'SE',
    row = vim.api.nvim_win_get_height(0) - 1,
    col = vim.api.nvim_win_get_width(0),
  })
  return new_opts, new_reg
end

registers.setup({
  show = '*+"%0123456789abcgpwy:',
  layouts = { layout_1, layout_2, layout_3 },
  bind_keys = {
    -- registers._bind_global_key('normal', '"', 'n'),
    -- registers._bind_global_key('visual', '"', 'x'),
    -- registers._bind_global_key('insert', '<C-R>', 'i'),
    -- When pressing a key of the register, wait for another key press before closing the window
    -- { keep_open_until_keypress = true }
    -- Always paste the register when selecting with Enter
    -- ['<CR>'] = require('registers').apply_register({ mode = 'paste' }),
    -- Show the window when pressing " in normal mode, applying the selected register as part of a motion, which is the default behavior of Neovim
    normal = ui.show_window({ mode = 'paste' }),
    -- Show the window when pressing " in visual mode, applying the selected register as part of a motion, which is the default behavior of Neovim
    visual = ui.show_window({ mode = 'motion' }),
    -- Show the window when pressing <C-R> in insert mode, inserting the selected register, which is the default behavior of Neovim
    insert = ui.show_window({ mode = 'insert' }),
    -- Move the cursor in the registers window down when pressing <C-n>
    ['<C-n>'] = ui.move_cursor_down(),
    -- Move the cursor in the registers window up when pressing <C-p>
    ['<C-p>'] = ui.move_cursor_up(),
    ['<C-j>'] = ui.move_cursor_down(),
    ['<C-k>'] = ui.move_cursor_up(),
  },
  events = {
    -- When a register line is highlighted, show a preview in the main buffer with how the register will be applied, but only if the register will be inserted or pasted
    on_register_highlighted = preview.preview_register({ { if_mode = { 'insert', 'paste' } } }),
  },
  window_border = 'rounded',
  window = {
    border = 'rounded',
    transparency = 10,
    max_width = 60,
  },
  symbol_options = {
    newline = ' ⏎',
    -- {newline?}                  (string)  Symbol to show for a line break character, can not be the `"\\n"` symbol, use `"\\\\n"` (two backslashes) instead. Default is `"⏎"`.
    -- {space?}                    (string)  Symbol to show for a space character. Default is `" "`.
    -- {tab?}                      (string)  Symbol to show for a tab character. Default is `"·"`.
    -- {register_type_charwise?}   (string)  Symbol to show next to the sign to signify that the register will be applied in a character by character way. Default is `"ᶜ"`.
    -- {register_type_linewise?}   (string)  Symbol to show next to the sign to signify that the register will be applied in a line by line way. Default is `"ˡ"`.
    -- {register_type_blockwise?}  (string)  Symbol to show next to the sign to signify that the register will be applied as a horizontal block, ignoring line endings. Default is `"ᵇ"`.
  },
  --stylua: ignore
  sign_highlights = {
    cursorlinesign   = 'CursorLine',
    signcolumn       = 'SignColumn',
    cursorline       = 'Visual',
    selection        = 'Constant',
    default          = 'Function',
    unnamed          = 'Statement',
    read_only        = 'Type',
    expression       = 'Exception',
    black_hole       = 'Error',
    alternate_buffer = 'Operator',
    last_search      = 'Tag',
    delete           = 'Special',
    yank             = 'Delimiter',
    history          = 'Number',
    named            = 'Todo',
    register_preview = 'RegistersPreview',
    -- {cursorline?}        (string)  Default is `"Visual"`.
    -- {selection?}        *+.  "Constant".
    -- {default?}          ".   "Function".
    -- {unnamed?}          \\.  "Statement".
    -- {read_only?}        :.%. "Type".
    -- {alternate_buffer?} #.   "Type".
    -- {expression?}       =.   "Exception".
    -- {black_hole?}       _.   "Error".
    -- {last_search?}      /.   "Operator".
    -- {delete?}           -.   "Special".
    -- {yank?}             0.   "Delimiter".
    -- {history?}          1-9. "Number".
    -- {named?}            a-z. "Todo".
  },
})

-- -- Define a custom for opening the register window when pressing "r"
-- vim.api.nvim_set_keymap("n", "r", "", {
--   -- The "paste" argument means that when a register is selected it will automatically be pasted
--   callback = require("registers").show_window({ mode = "paste" }),
--   -- This is required for the registers window to function
--   expr = true
-- })
