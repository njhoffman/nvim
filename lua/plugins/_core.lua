local utils = require("utils.lazy")

local plugins = {
  { "folke/lazy.nvim", lazy = false },
  -- colorscheme components should load first
  {
    "rktjmp/lush.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<Leader>cs",
        function()
          vim.api.nvim_exec_autocmds("User", { pattern = "ColorSchemeLoad" })
          require("telescope.builtin").colorscheme()
        end,
        noremap = true,
      },
    },
    config = function()
      vim.cmd("colorscheme nord-nick")
    end,
  },
  {
    "m4xshen/hardtime.nvim",
    enabled = false,
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  },
  {
    "folke/noice.nvim",
    branch = "release-please--branches--main--components--noice.nvim",
    lazy = false,
  },
  { "famiu/bufdelete.nvim" },
  { "nvim-tree/nvim-web-devicons", dependencies = { "DaikyXendo/nvim-material-icon" } },
  {
    -- 'njhoffman/barbecue.nvim',
    -- dir = '~/git/barbecue.nvim',
    "utilyre/barbecue.nvim",
    event = "VeryLazy",
    -- branch = "master",
    name = "barbecue",
    dependencies = { "SmiteshP/nvim-navic", "nvim-tree/nvim-web-devicons" },
  },
  {
    "b0o/incline.nvim",
    enabled = false,
    event = "VeryLazy",
  },
  {
    -- 'njhoffman/nvim-notify.nvim',
    -- name = 'nvim-notify',
    -- dir = '~/git/nvim-notify',
    "rcarriga/nvim-notify",
    lazy = false,
  },
  {
    -- https://github.com/tamton-aquib/keys.nvim
    "folke/which-key.nvim",
    dir = "~/git/which-key.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  -- { 'freddiehaddad/feline.nvim', branch = 'main', event = 'VimEnter', lazy = false, },
}

utils.apply_configs(plugins)

return plugins
