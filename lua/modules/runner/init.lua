-- local run_cmds = require('modules.runner.commands.run_cmd')
-- local run_notify = require('modules.runner.commands.run_notify')
-- local run_tmux = require('modules.runner.commands.run_tmux')
-- local run_watchers = require('modules.runner.commands.run_watchers')
-- local run_remote = require('modules.runner.commands.run_remote')
-- https://github.com/Makaze/watch.nvim

local restart = require("modules.runner.commands.restart")
local commands = require("modules.runner.commands")

local setup = function()
  -- local Chrome = require('chrome-remote.chrome')
  -- local client = Chrome.new()
  commands.setup()
end

setup()
