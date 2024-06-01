local handlers = require('runner.handlers')

local setup_commands = function()
  local cmd = vim.api.nvim_create_user_command

  -- cmd('Run', handlers.run_cmd, {
  --   nargs = '?',
  --   desc = 'Run command through preconfigured interpreter',
  -- })

  -- cmd('RunVisual', handlers.run_visual, {
  --   nargs = '?',
  --   desc = 'Run a the visual selected portion of a script',
  -- })
  --
  cmd('RunFile', handlers.file, {
    nargs = '?',
    desc = 'Run/execute a file based on filetype',
  })
  --
  -- cmd('RunSelect', handlers.run_file, {
  --   nargs = '?',
  --   desc = 'Reassign command and run through preconfigured interpreter',
  -- })
end

return { setup = setup_commands }
