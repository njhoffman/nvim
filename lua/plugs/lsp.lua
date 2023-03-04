local utils = require("lazy-utils")

local plugins = {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "weilbith/nvim-code-action-menu",
      "b0o/schemastore.nvim", -- for jsonls
      "smjonas/inc-rename.nvim",
      "nanotee/sqls.nvim",
      "ray-x/lsp_signature.nvim",
      "tami5/lspsaga.nvim",
      "rmagatti/goto-preview",
      "kosayoda/nvim-lightbulb",
      "mickael-menu/zk-nvim",
      { "folke/trouble.nvim", cmd = { "TroubleToggle", "Trouble" } },
      {
        "folke/lsp-colors.nvim",
        opts = { Error = "#db4b4b", Warn = "#e0af68", Info = "#0db9d7", Hint = "#10B981" },
      },
      { "folke/neodev.nvim", dependencies = { "folke/neoconf.nvim" } },
      { "jbyuki/ntangle-lsp.nvim", dependencies = { "jbyuki/ntangle-ts.nvim" } },
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("lazy.core.config").plugins["nvim-cmp"] ~= nil
        end,
      },
    },
    config = function()
      vim.dbglog("loading lsp")
      vim.import("lsp.capabilities")
      vim.import("lsp.servers")
      vim.import("lsp.config")
    end,
  },
  { dir = "~/git/fidget.nvim" },
  { "williamboman/mason.nvim", cmd = "Mason" },
  { "ray-x/go.nvim", dependencies = { "ray-x/guihua.lua" }, ft = "go", event = { "BufReadPost", "BufNewFile" } },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "ThePrimeagen/refactoring.nvim", "mason.nvim" },
  },
  { "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" } },
  {
    "stevearc/aerial.nvim",
    lazy = true, -- needs treesitter or lsp
    cmd = { "AerialToggle", "AerialNext", "AerialGo", "AerialOpen", "AerialPrev", "AerialOpenAll" },
  },
  { "SmiteshP/nvim-navic", lazy = true, dependencies = { "utilyre/barbecue.nvim", "nvim-web-devicons" } },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {
      highlight = {
        keyword = "fg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
      },
      colors = {
        warning = { "Warning" },
        info = { "Todo" },
        hint = { "#10B981" },
        default = { "Todo" },
        test = { "#794789" },
      },
      -- TODO: testing
      -- HACK: hack
      -- FIX: a fix
      -- WARN: this is a warning
      -- PERF: this is for perf
      -- NOTE: this is a note
      -- TEST: this is a test
    },
  },
  --   "narutoxy/dim.lua",
}

utils.apply_configs(plugins)
utils.print_stats("LSP", plugins)
return plugins

-- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },
