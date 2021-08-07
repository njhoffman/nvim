-- Call :Registers
-- Press " in normal or visual mode
-- Press CtrlR in insert mode
-- Use the Up and Down or CtrlP and CtrlN or CtrlJ and CtrlK keys to select the register you want to use and press Enter to apply it, or type the register you want to apply, which is one of the following:
-- " 0-9 a-z : . % # = * + _ /
--
-- vim.g.registers_return_symbol        = "\n" --'⏎' by default
-- vim.g.registers_tab_symbol           = "\t" --'·' by default
-- vim.g.registers_space_symbol         = "." -- ' ' by default
-- vim.g.registers_register_key_sleep   = 1 --0 by default, seconds to wait before closing the window when a register key is pressed
-- vim.g.registers_show_empty_registers = 0 --1 by default, an additional line with the registers without content
-- vim.g.registers_trim_whitespace      = 0 --1 by default, don't show whitespace at the begin and end of the registers
-- vim.g.registers_hide_only_whitespace = 1 --0 by default, don't show registers filled exclusively with whitespace
vim.g.registers_window_border = "rounded" -- 'none' by default, can be 'none', 'single','double', 'rounded', 'solid', or 'shadow' (requires Neovim 0.5.0+)
vim.g.registers_window_min_height = 10 -- 3 by default, minimum height of the window when there is the cursor at the bottom
vim.g.registers_window_max_width = 50 -- 100 by default, maximum width of the window
