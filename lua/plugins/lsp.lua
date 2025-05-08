local utils = require("utils.lazy")

--   "pmizio/typescript-tools.nvim",
-- "RRethy/vim-illuminate",
-- 'zeioth/garbage-day.nvim',
-- https://github.com/onsails/diaglist.nvim
-- https://github.com/mfussenegger/nvim-jdtls
-- https://github.com/jmbuhr/otter.nvim
-- "KostkaBrukowa/definition-or-references.nvim",
-- "Chaitanyabsprip/fastaction.nvim",
-- { 'Wansmer/symbol-usage.nvim', event = 'LspAttach' },
-- { "jose-elias-alvarez/typescript.nvim" },
-- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },

local plugins = {
  { "bassamsdata/namu.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = { inlay_hints = { enabled = true } },
    event = { "BufReadPost", "BufNewFile", "LspAttach" },
    dependencies = {
      -- Core package manager – last 1.x commit (May 2 2025)
      { "williamboman/mason.nvim", commit = "4da89f3" }, -- v1.‑series
      -- LSP bridge – latest 1.x release tag (Feb 15 2025)
      { "williamboman/mason-lspconfig.nvim", commit = "1a31f82" }, -- v1.32.0
      { "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "125551" },
      "weilbith/nvim-code-action-menu",
      {
        "adoyle-h/lsp-toggle.nvim",
        config = function()
          require("lsp-toggle").setup({
            create_cmds = true, -- Whether to create user commands
            telescope = true, -- Whether to load telescope extensions
          })
        end,
      },
      "aznhe21/actions-preview.nvim",
      { "artemave/workspace-diagnostics.nvim" },
      "b0o/schemastore.nvim", -- for jsonls
      {
        "piersolenski/wtf.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        keys = {
          {
            "gWw",
            mode = { "n", "x" },
            function()
              require("wtf").ai()
            end,
            desc = "Debug diagnostic with AI",
          },
          {
            mode = { "n" },
            "gWW",
            function()
              require("wtf").search()
            end,
            desc = "Search diagnostic with Google",
          },
        },
      },
      "nanotee/sqls.nvim",
      "tami5/lspsaga.nvim",
      { "Exafunction/codeium.nvim", event = "BufEnter" },
      "rmagatti/goto-preview",
      "kosayoda/nvim-lightbulb",
      "mickael-menu/zk-nvim",
      "dnlhc/glance.nvim",
      { "folke/lazydev.nvim", ft = "lua" },
      { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
      { "folke/trouble.nvim", cmd = { "TroubleToggle", "Trouble" } },
      {
        "folke/lsp-colors.nvim",
        opts = { Error = "#db4b4b", Warn = "#e0af68", Info = "#0db9d7", Hint = "#10B981" },
      },
      { "jbyuki/ntangle-lsp.nvim", dependencies = { "jbyuki/ntangle-ts.nvim" } },
    },
    config = function()
      vim.import("lsp.capabilities")
      vim.import("lsp.config")
      vim.import("lsp.servers")
      vim.import("lsp.lines")
      vim.import("configs.definition-or-references")
    end,
  },
  { "james1236/backseat.nvim", cmd = { "Backseat", "BackseatAsk", "BackseatClear" } },
  {
    "SmiteshP/nvim-navbuddy",
    dir = "~/git/nvim-navbuddy",
    event = { "VeryLazy" },
    dependencies = { "neovim/nvim-lspconfig", "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
  },
  { "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" } },
  {
    "stevearc/aerial.nvim",
    event = { "BufReadPre", "BufNewFile", "LspAttach" },
    cmd = { "AerialToggle", "AerialNext", "AerialGo", "AerialOpen", "AerialPrev", "AerialOpenAll" },
    dependencies = { "nvim-web-devicons" },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTrouble", "TodoTelescope" },
  },
}

utils.apply_configs(plugins)

return plugins
