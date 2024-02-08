local commands = require('tail.commands')

-- vim.cmd([[
--   command! TailStart lua commands.start_tail()
--   command! TailStop lua tail.stop_tail()
-- ]])

vim.api.nvim_create_user_command(
  'TailStart',
  commands.start_tail,
  { desc = 'Start tailing the current file                                  ' }
)

vim.api.nvim_create_user_command(
  'TailStop',
  commands.stop_tail,
  { desc = 'Stop tailing the current file                                    ' }
)
