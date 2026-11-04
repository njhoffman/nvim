-- lazy plugin
-- -- [339] = {
-- --     [1] = "andrewferrier/debugprint.nvim",
-- --     _ = { installed = true, loaded = { event = "VeryLazy", time = 598385 } },
-- --     event = { [1] = "VeryLazy" }, lazy = true, name = "debugprint.nvim",
-- --     dir = "/home/nicholas/.local/share/nvim/lazy/debugprint.nvim",
-- --     url = "https://github.com/andrewferrier/debugprint.nvim.git" },

local output = require('modules.stats.output')
local stats_plugins = function(argsi, state)
  vim.dbglog('STATS CONFIG', state.lazy)
end

return { stats_plugins = stats_plugins }
