local utils = require("utils.lazy")

-- https://github.com/onsails/diaglist.nvim

local plugins = {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = true },
    },
    event = { "BufReadPost", "BufNewFile", "LspAttach" },
    dependencies = {
      { "williamboman/mason.nvim", cmd = "Mason" },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "weilbith/nvim-code-action-menu",
      -- "Chaitanyabsprip/fastaction.nvim",
      {
        "adoyle-h/lsp-toggle.nvim",
        config = function()
          require("lsp-toggle").setup({
            create_cmds = true, -- Whether to create user commands
            telescope = true, -- Whether to load telescope extensions
          })
        end,
      },
      "SmiteshP/nvim-navic",
      "aznhe21/actions-preview.nvim",
      "RRethy/vim-illuminate",
      {
        "artemave/workspace-diagnostics.nvim",
        enabled = false,
        config = function()
          require("workspace-diagnostics").setup({})
          --[[ workspace_files = function()
              return { 'index.js', 'lib/banana.js' }
            end ]]
        end,
      },
      -- 'zeioth/garbage-day.nvim',
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
      "KostkaBrukowa/definition-or-references.nvim",
      "nanotee/sqls.nvim",
      "tami5/lspsaga.nvim",
      { "Exafunction/codeium.nvim", event = "BufEnter" },
      -- { 'Wansmer/symbol-usage.nvim', event = 'LspAttach' },
      "rmagatti/goto-preview",
      "kosayoda/nvim-lightbulb",
      "mickael-menu/zk-nvim",
      "dnlhc/glance.nvim",
      -- ft = {'javascript','javascriptreact','javascript.jsx','typescript','typescriptreact','typescript.tsx'}
      -- { "jose-elias-alvarez/typescript.nvim" },
      -- {
      --   "pmizio/typescript-tools.nvim",
      --   enabled = false,
      --   dependencies = { "nvim-lua/plenary.nvim" },
      -- },
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            "lazy.nvim",
            { path = "luvit-meta/library", words = { "vim%.uv" } },
            { path = "LazyVim", words = { "LazyVim" } },
            -- "~/projects/my-awesome-lib",
            -- "luvit-meta/library",
            -- { path = "wezterm-types", mods = { "wezterm" } },
            -- { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
          },
        },
      },
      { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
      {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
      },
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
  {
    "james1236/backseat.nvim",
    cmd = { "Backseat", "BackseatAsk", "BackseatClear" },
  },
  {
    "SmiteshP/nvim-navbuddy",
    dir = "~/git/nvim-navbuddy",
    event = { "VeryLazy" },
    dependencies = { "neovim/nvim-lspconfig", "SmiteshP/nvim-navic", "MunifTanjim/nui.nvim" },
  },
  -- https://github.com/jmbuhr/otter.nvim
  -- {
  { "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" } },
  {
    "stevearc/aerial.nvim",
    event = { "BufReadPre", "BufNewFile", "LspAttach" },
    cmd = { "AerialToggle", "AerialNext", "AerialGo", "AerialOpen", "AerialPrev", "AerialOpenAll" },
    dependencies = { "nvim-web-devicons" },
  },
  -- https://github.com/mfussenegger/nvim-jdtls
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTrouble", "TodoTelescope" },
  },
}

utils.apply_configs(plugins)

return plugins
