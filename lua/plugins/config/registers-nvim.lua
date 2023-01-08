-- Call :Registers
-- Press " in normal or visual mode
-- Press CtrlR in insert mode
-- Use the Up and Down or CtrlP and CtrlN or CtrlJ and CtrlK keys to select the register you want to use and press Enter to apply it, or type the register you want to apply, which is one of the following:
-- " 0-9 a-z : . % # = * + _ /

-- -- Define a custom for opening the register window when pressing "r"
-- vim.api.nvim_set_keymap("n", "r", "", {
--   -- The "paste" argument means that when a register is selected it will automatically be pasted
--   callback = require("registers").show_window({ mode = "paste" }),
--   -- This is required for the registers window to function
--   expr = true
-- })

local registers = require("registers")

registers.setup({
  window = {
    border = "rounded",
    transparency = 20,
    max_width = 50,
  },
})
