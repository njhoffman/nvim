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
  { "freddiehaddad/feline.nvim", priority = 1001 },
  { "romgrk/barbar.nvim", priority = 1002, event = "VeryLazy", dependencies = "kyazdani42/nvim-web-devicons" },
  {
    "rcarriga/nvim-notify",
    -- event = { "BufReadPost", "BufNewFile" },
    priority = 1003, -- make sure to load this before all the other start plugins
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("lazy-utils")
      if not Util.is_loaded("noice.nvim") and false then
        Util.on_very_lazy(function()
          vim.notify = require("notify")
        end)
      end
    end,
  },
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    event = "VeryLazy",
  },
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
