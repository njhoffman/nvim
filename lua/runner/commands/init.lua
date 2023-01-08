local run_cmd = require('runner.commands.run_cmd')
local run_notify = require('runner.commands.run_notify')
local run_tmux = require('runner.commands.run_tmux')
local run_watchers = require('runner.commands.run_watchers')
local run_remote = require('runner.commands.run_remote')
local restart = require('runner.commands.restart')

local setup_commands = function()
  local cmd = vim.api.nvim_create_user_command
  cmd('Run', run_cmd, {
    nargs = '?', desc = 'Run command through preconfigured interpreter'
  })
  cmd('RunNotify', run_notify, { nargs = '?', desc = 'Run command with output to notifications' })
  cmd('RunTmux', run_tmux, { nargs = '?', desc = 'Run command with output to tmux window' })
  cmd('RunWatchers', run_watchers, { nargs = '?', desc = 'Configure automatic commands to trigger on file write' })
  cmd('RunRemote', run_remote, { nargs = '?', desc = 'Run command with output to remote nvim instance' })
  cmd("RestartTarget", restart.restart_target, { desc = "Reload and run commands on external vim instance" })
  -- cmd("RemoteAssign", remote.assign_target, { desc = "Assign an available vim instance remote target" })
  -- cmd("RemoteSend", remote.run_command, { nargs = '?', desc = "Run single command provided as an argument on remote target" })
  -- cmd("RemoteScript", remote.run_script, { desc = "Run script provided as an argument on remote target" })
  -- cmd("RemoteWatch", remote.watch_file, { desc = "Watch and run file on write (current buffer if no argument given)" })
  -- cmd("RemoteWatched", remote.view_watched, { desc = "View list of watched files for remote execution" })
end

return { setup = setup_commands }
