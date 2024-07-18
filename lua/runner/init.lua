-- local run_cmds = require('runner.commands.run_cmd')
-- local run_notify = require('runner.commands.run_notify')
-- local run_tmux = require('runner.commands.run_tmux')
-- local run_watchers = require('runner.commands.run_watchers')
-- local run_remote = require('runner.commands.run_remote')
-- https://github.com/Makaze/watch.nvim

local restart = require("runner.commands.restart")
local commands = require("runner.commands")

local setup = function()
  -- local Chrome = require('chrome-remote.chrome')
  -- local client = Chrome.new()
  commands.setup()
end

setup()
