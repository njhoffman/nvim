local remote = vim.import('remote.init')
local script = vim.import('scripts.notify-test')

local cmd = vim.api.nvim_create_user_command

cmd("RemoteAssign",
  remote.assign_target, {
  desc = "Assign an available vim instance remote target"
})

cmd("RemoteSend",
  remote.run_command, {
  nargs = '?',
  desc = "Run single command provided as an argument on remote target"
})

-- lua require("plenary.reload").reload_module "plenary"
cmd("RemoteCommands",
  function(props)
    remote.run_commands(props, script.notify_cmds)
  end,
  { desc = "Run list of commands on remote target" }
)

cmd("RemoteScript",
  remote.run_script, {
  desc = "Run script provided as an argument on remote target"
})

cmd("RemoteWatch",
  remote.watch_file, {
  desc = "Watch and run file on write (current buffer if no argument given)"
})

cmd("RemoteWatched",
  remote.view_watched, {
  desc = "View list of watched files for remote execution"
})
