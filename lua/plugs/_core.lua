local utils = require("utils.lazy")
local plugins = {
  { "folke/lazy.nvim", lazy = false, version = "*" },
  -- colorscheme components should load first
  {
    "rktjmp/lush.nvim",
    lazy = false,
    config = function()
      vim.cmd("colorscheme nord-nick")
    end,
  },
  { "freddiehaddad/feline.nvim", lazy = false, event = "VeryLazy" },
  { "romgrk/barbar.nvim", lazy = false, event = "VeryLazy", dependencies = "nvim-tree/nvim-web-devicons" },
  { "rcarriga/nvim-notify", lazy = false, event = "VimEnter" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- no lazy loading to enable netrw override
    lazy = false,
    cmd = { "NeoTreeFocusToggle", "NeoTreeShowToggle" },
    event = "VimEnter",
    branch = "v2.x",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
  },
  { "folke/which-key.nvim", lazy = true, event = "VeryLazy" },
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

return plugins
