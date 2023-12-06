local keymaps = require('configs.debugprint.keymaps')
local myobject = {}

local lua = {
  left = 'vim.dbglog("',
  right = '")',
  mid_var = '", ',
  right_var = ')',
  -- left = "print('",
  -- right = "')",
  -- mid_var = "' .. vim.inspect(",
  -- right_var = "))",
}
-- require('debugprint').add_custom_filetypes({ my_fileformat, ... })
-- require('debugprint').setup({ filetypes = { my_fileformat, another_of_my_fileformats, ... }})

require('debugprint').setup({
  move_to_debugline = true,
  create_keymaps = false,
  create_commands = false,
  display_counter = true,
  display_snippet = false,
  filetypes = { lua = lua },
})

keymaps.setup_debugprint()
keymaps.setup_printing_press()
