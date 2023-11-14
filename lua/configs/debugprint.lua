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

vim.keymap.set('n', 'god', function()
  require('debugprint').deleteprints()
end, { desc = 'delete all debug statements in buffer' })

vim.keymap.set('n', 'goD', function()
  require('debugprint').deleteprints()
end, { desc = 'delete all debug statements in project' })

-- Note: setting `expr=true` and returning the value are essential
vim.keymap.set({ 'n', 'v' }, 'goi', function()
  return require('debugprint').debugprint({ variable = true })
end, { expr = true, desc = 'debug inspect variable below' })

vim.keymap.set({ 'n', 'v' }, 'goI', function()
  return require('debugprint').debugprint({ variable = true, above = true })
end, { expr = true, desc = 'debug inspect variable above' })

vim.keymap.set('n', 'goo', function()
  return require('debugprint').debugprint({ motion = true })
end, { expr = true, desc = 'debug inspect variable below with operator' })

vim.keymap.set('n', 'goO', function()
  return require('debugprint').debugprint({ motion = true, above = true })
end, { expr = true, desc = 'debug inspect variable above with operator' })

vim.keymap.set('n', 'gop', function()
  return require('debugprint').debugprint()
end, { expr = true, desc = 'debug print plain line below' })

vim.keymap.set('n', 'goP', function()
  return require('debugprint').debugprint({ above = true })
end, { expr = true, desc = 'debug print plain line above' })

vim.keymap.set('n', 'got', function()
  return require('debugprint').debugprint()
end, { expr = true, desc = 'print numbered timer below' })

vim.keymap.set('n', 'goT', function()
  return require('debugprint').debugprint({ above = true })
end, { expr = true, desc = 'print named timer below' })

vim.api.nvim_create_user_command('DeleteDebugs', function(opts)
  -- Note: you must set `range=true` and pass through opts for ranges to work
  require('debugprint').deleteprints(opts)
end, { range = true, desc = 'delete all debug statements' })

local contextprint = require('debugprint.contextprint')

contextprint.setup({ log = {
  typescript = 'console.log',
} })

vim.keymap.set('n', 'goc', function()
  local tmp = 3
  contextprint.add_statement()
end, { expr = true, desc = 'contextprint' })

-- require('contextprint').setup({
--     separator_char = "#",  // Global
--     <filetype> = {
--         separator = "#", // filetype specific
--         query = [[ <language specific queries> ]],
--         log = function(contents) to return print statement to insert
--         type_defaults = vim.tbl_extend to change name defaults
--     }
-- })
