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

---@field show string Which registers to show and in what order. Default is `"*+\"-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:"`.
---@field show_empty boolean Show the registers which aren't filled in a separate line. Default is `true`.
---@field bind_keys bind_keys_options|boolean Which keys to bind, `true` maps all keys and `false` maps no keys.
---@field events events_options Functions that will be called when certain events happen.
---@field symbols symbols_options Symbols used to replace text in the previous buffer.
---@field window window_options Floating window
---@field sign_highlights sign_highlights_options Highlights for the sign section of the window

local registers = require("registers")

local default_options = registers.default_options()
local bind_keys = default_options.bind_keys
-- bind_keys["j"] = registers.move_cursor_down()
-- bind_keys["k"] = registers.move_cursor_up()
vim.dbglog(bind_keys)
registers.setup({
  show = '*+"-/_=#%.0123456789abcdefghijklmnopqrstuvwxyz:',
  bind_keys = bind_keys,
  window = {
    border = "rounded",
    transparency = 20,
    max_width = 50,
  },
})

-- Helper function for setting the keymap for all buffer modes
local set_keymap_all_modes = function(key, callback)
  local map_options = {
    nowait = true,
    noremap = true,
    silent = true,
    callback = callback,
  }

  vim.api.nvim_buf_set_keymap(registers._buffer, "n", key, "", map_options)
  vim.api.nvim_buf_set_keymap(registers._buffer, "i", key, "", map_options)
  vim.api.nvim_buf_set_keymap(registers._buffer, "x", key, "", map_options)
end

-- if registers._key_should_be_bound("k") then
--   set_keymap_all_modes("k", registers.move_cursor_up)
-- end

-- if registers._key_should_be_bound("j") then
--   set_keymap_all_modes("j", registers.move_cursor_down)
-- end
