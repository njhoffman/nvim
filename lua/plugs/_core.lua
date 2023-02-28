local utils = require("lazy-utils")
local plugins = {
  { "folke/lazy.nvim", version = "*" },
  {
    "rktjmp/lush.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd("colorscheme nord-nick")
    end,
  },
  { "freddiehaddad/feline.nvim" },
  { "romgrk/barbar.nvim", dependencies = "kyazdani42/nvim-web-devicons" },
}

utils.apply_configs(plugins)
utils.print_stats("Core", plugins)

return plugins

-- require("lazy.core.util").try(function()
--   if type(M.colorscheme) == "function" then
--     M.colorscheme()
--   else
--     vim.cmd.colorscheme(M.colorscheme)
--   end
-- end, {
--   msg = "Could not load your colorscheme",
--   on_error = function(msg)
--     require("lazy.core.util").error(msg)
--     vim.cmd.colorscheme("habamax")
--   end,
