local keymaps = require('configs.debugprint.keymaps')

-- TODO: add capability to do premotions before output of debug line '%'
-- TODO: custom output with function
-- TODO: insert on print message action

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
-- marker is 0x1fa9a 🪚
require('debugprint').setup({
  print_tag = '🪚' .. ' ',
  move_to_debugline = true,
  create_keymaps = false,
  create_commands = false,
  display_counter = true,
  display_snippet = false,
  filetypes = { lua = lua },
})

vim.api.nvim_create_user_command('DeleteDebugs', function(opts)
  -- Note: you must set `range=true` and pass through opts for ranges to work
  require('debugprint').deleteprints(opts)
end, { range = true, desc = ' delete all debug statements' })

keymaps.setup_debugprint()
keymaps.setup_printing_press()
