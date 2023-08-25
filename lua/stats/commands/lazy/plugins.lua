-- lazy plugin
-- -- [339] = {
-- --     [1] = "andrewferrier/debugprint.nvim",
-- --     _ = { installed = true, loaded = { event = "VeryLazy", time = 598385 } },
-- --     event = { [1] = "VeryLazy" }, lazy = true, name = "debugprint.nvim",
-- --     dir = "/home/nicholas/.local/share/nvim/lazy/debugprint.nvim",
-- --     url = "https://github.com/andrewferrier/debugprint.nvim.git" },

local output = require('stats.output')
local stats_plugins = function(argsi, state)
  vim.dbglog('STATS CONFIG', state.lazy)
  -- zenburn = {
  --     [1] = "phha/zenburn.nvim",
  --     _ = { installed = true },
  --     dir = "/home/nicholas/.local/share/nvim/lazy/zenburn.nvim",
  --     event = { [1] = "User ColorSchemeLoad" },
  --     lazy = true,
  --     name = "zenburn.nvim",
  --     url = "https://github.com/phha/zenburn.nvim.git" }
  -- loaded = { plugin = "cmp_luasnip", time = 7339086 },
end

return { stats_plugins = stats_plugins }
