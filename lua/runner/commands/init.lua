local run_cmd = require('runner.commands.run_cmd')
local run_notify = require('runner.commands.run_notify')
local run_tmux = require('runner.commands.run_tmux')
local run_watchers = require('runner.commands.run_watchers')
local run_remote = require('runner.commands.run_remote')


local setup_commands = function()
  vim.api.nvim_create_user_command('Run', run_cmd, {
    nargs = '?',
    desc = 'Run command through preconfigured interpreter',
  })

  vim.api.nvim_create_user_command('RunNotify', run_notify, {
    nargs = '?',
    desc = 'Run command with output to notifications',
  })

  vim.api.nvim_create_user_command('RunTmux', run_tmux, {
    nargs = '?',
    desc = 'Run command with output to tmux window',
  })

  vim.api.nvim_create_user_command('RunWatchers', run_watchers, {
    nargs = '?',
    desc = 'Configure automatic commands to trigger on file write',
  })

  vim.api.nvim_create_user_command('RunRemote', run_remote, {
    nargs = '?',
    desc = 'Run command with output to remote nvim instance',
  })
end

return { setup = setup_commands }
