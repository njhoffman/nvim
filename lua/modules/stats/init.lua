local stats_map = require("modules.stats.commands-stats")
-- local watch_map = require('modules.stats.commands-watch')
-- local track_map = require('modules.stats.commands-track')

local stats = require("modules.stats.commands")
vim.api.nvim_create_user_command("Stats", stats.command, {
  desc = "Internal stats output and monitoring",
  complete = stats.completion(stats_map),
  nargs = "*",
})
