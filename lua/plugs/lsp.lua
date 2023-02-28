local utils = require("lazy-utils")

local plugins = {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      vim.dbglog("loading lsp")
      vim.import("lsp.capabilities")
      vim.import("lsp.globals")
      vim.import("lsp.servers")
      vim.import("lsp.config")
    end,
  },
  { dir = "~/git/fidget.nvim" },
  { "ray-x/go.nvim", dependencies = { "ray-x/guihua.lua" } },
  { "SmiteshP/nvim-navic", dependencies = { "utilyre/barbecue.nvim", "nvim-web-devicons" } },
  { "jose-elias-alvarez/null-ls.nvim", dependencies = { "nvim-lua/plenary.nvim", "ThePrimeagen/refactoring.nvim" } },
  { "nanotee/sqls.nvim", dependencies = { "nvim-lspconfig" } },
  --   "narutoxy/dim.lua",
  { "mickael-menu/zk-nvim" },
  { "ray-x/lsp_signature.nvim" },
  { "b0o/schemastore.nvim" }, -- for jsonls
  { "mfussenegger/nvim-lint" },
  { "stevearc/aerial.nvim" },
  { "folke/neodev.nvim", dependencies = { "folke/neoconf.nvim" } },
  { "folke/lsp-colors.nvim" },
  { "kosayoda/nvim-lightbulb" },
  { "tami5/lspsaga.nvim" },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
  },
  { "weilbith/nvim-code-action-menu" },
  { "folke/trouble.nvim", cmd = { "TroubleToggle", "Trouble" } },
  { "jbyuki/ntangle-lsp.nvim", dependencies = { "jbyuki/ntangle-ts.nvim", "neovim/nvim-lspconfig" } },
}

utils.apply_configs(plugins)
utils.print_stats("LSP", plugins)
return plugins

-- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },
