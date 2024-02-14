local noice_stats = function()
  -- https://github.com/folke/noice.nvim/issues/359
  -- {
  --     function() return require("noice").api.status.command.get() end,
  --     cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
  --     color = fg("Statement")
  -- },
  -- ["cmdline.skipped"] = { count = 17634, event = "cmdline.skipped" },
  -- ["msg.skipped"] = { count = 7592, event = "msg.skipped" },
  -- redraw = { count = 704, event = "redraw" },
  -- ["router.update"] = { count = 1384, event = "router.update" },
  -- ["router.update.updated"] = { count = 1310, event = "router.update.updated" }
  local stats = require('noice.util.stats')._stats
  stats.history = #require('noice.message.manager')._history

  require('import.commands.state').get_mod_status()
  require('import.commands.state').get_failure_count()
  require('import.commands.state').get_success_count()

  stats.notify_pending = #require('notify').pending()
  stats.notify_history = #require('notify').history()
  stats.lazy_stats = require('lazy').stats()
  stats.lazy_configs = require('stats.commands.lazy.configs').stats
  stats.lazy_plugins = require('stats.commands.lazy.plugins').stats_plugins
  -- {
  --       require("noice").api.status.message.get_hl,
  --       cond = require("noice").api.status.message.has,
  --     },
  --     {
  --       require("noice").api.status.command.get,
  --       cond = require("noice").api.status.command.has,
  --       color = { fg = "#ff9e64" },
  --     },
  --     {
  --       require("noice").api.status.mode.get,
  --       cond = require("noice").api.status.mode.has,
  --       color = { fg = "#ff9e64" },
  --     },
  --     {
  --       require("noice").api.status.search.get,
  --       cond = require("noice").api.status.search.has,
  --       color = { fg = "#ff9e64" },
  --     },
end
