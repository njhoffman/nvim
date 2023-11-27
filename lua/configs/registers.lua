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

local registers = require('registers')
registers.setup({
  -- show = '*+"-/_=#%.0123456789abcdefghilmnopqrstuvwxyz:',
  show = '*+"%0123456789abcpwy:',
  bind_keys = {
    -- registers._bind_global_key('normal', '"', 'n'),
    -- registers._bind_global_key('visual', '"', 'x'),
    -- registers._bind_global_key('insert', '<C-R>', 'i'),
    -- When pressing a key of the register, wait for another key press before closing the window
    -- { keep_open_until_keypress = true }
    -- Always paste the register when selecting with Enter
    -- ['<CR>'] = require('registers').apply_register({ mode = 'paste' }),
    -- Show the window when pressing " in normal mode, applying the selected register as part of a motion, which is the default behavior of Neovim
    normal = registers.show_window({ mode = 'paste' }),
    -- Show the window when pressing " in visual mode, applying the selected register as part of a motion, which is the default behavior of Neovim
    visual = registers.show_window({ mode = 'motion' }),
    -- Show the window when pressing <C-R> in insert mode, inserting the selected register, which is the default behavior of Neovim
    insert = registers.show_window({ mode = 'insert' }),
    -- Move the cursor in the registers window down when pressing <C-n>
    ['<C-n>'] = registers.move_cursor_down(),
    -- Move the cursor in the registers window up when pressing <C-p>
    ['<C-p>'] = registers.move_cursor_up(),
    -- Move the cursor in the registers window down when pressing <C-j>
    ['j'] = registers.move_cursor_down(),
    -- Move the cursor in the registers window up when pressing <C-k>
    ['k'] = registers.move_cursor_up(),
  },
  events = {
    -- When a register line is highlighted, show a preview in the main buffer with how the register will be applied, but only if the register will be inserted or pasted
    on_register_highlighted = registers.preview_highlighted_register({ { if_mode = { 'insert', 'paste' } } }),
  },
  window_border = 'rounded',
  window = {
    border = 'rounded',
    transparency = 30,
    max_width = 100,
  },
  symbol_options = {
    -- {newline?}                  (string)  Symbol to show for a line break character, can not be the `"\\n"` symbol, use `"\\\\n"` (two backslashes) instead. Default is `"⏎"`.
    -- {space?}                    (string)  Symbol to show for a space character. Default is `" "`.
    -- {tab?}                      (string)  Symbol to show for a tab character. Default is `"·"`.
    -- {register_type_charwise?}   (string)  Symbol to show next to the sign to signify that the register will be applied in a character by character way. Default is `"ᶜ"`.
    -- {register_type_linewise?}   (string)  Symbol to show next to the sign to signify that the register will be applied in a line by line way. Default is `"ˡ"`.
    -- {register_type_blockwise?}  (string)  Symbol to show next to the sign to signify that the register will be applied as a horizontal block, ignoring line endings. Default is `"ᵇ"`.
  },
  sign_highlights = {
    -- `require("registers").setup({ sign_highlights = {...} })`
    -- Fields:
    --     {cursorline?}        (string)  Highlight group for when the cursor is over the line. Default is `"Visual"`.
    --     {selection?}         (string)  Highlight group for the selection registers, `*+`. Default is `"Constant"`.
    --     {default?}           (string)  Highlight group for the default register, `"`. Default is `"Function"`.
    --     {unnamed?}           (string)  Highlight group for the unnamed register, `\\`. Default is `"Statement"`.
    --     {read_only?}         (string)  Highlight group for the read only registers, `:.%`. Default is `"Type"`.
    --     {alternate_buffer?}  (string)  Highlight group for the alternate buffer register, `#`. Default is `"Type"`.
    --     {expression?}        (string)  Highlight group for the expression register, `=`. Default is `"Exception"`.
    --     {black_hole?}        (string)  Highlight group for the black hole register, `_`. Default is `"Error"`.
    --     {last_search?}       (string)  Highlight group for the last search register, `/`. Default is `"Operator"`.
    --     {delete?}            (string)  Highlight group for the delete register, `-`. Default is `"Special"`.
    --     {yank?}              (string)  Highlight group for the yank register, `0`. Default is `"Delimiter"`.
    --     {history?}           (string)  Highlight group for the history registers, `1-9`. Default is `"Number"`.
    --     {named?}             (string)  Highlight group for the named registers, `a-z`. Default is `"Todo"`.
  },
})

-- -- Define a custom for opening the register window when pressing "r"
-- vim.api.nvim_set_keymap("n", "r", "", {
--   -- The "paste" argument means that when a register is selected it will automatically be pasted
--   callback = require("registers").show_window({ mode = "paste" }),
--   -- This is required for the registers window to function
--   expr = true
-- })
