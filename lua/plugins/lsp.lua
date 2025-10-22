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
      -- https://github.com/rshkarin/mason-nvim-lint
      -- https://github.com/zapling/mason-conform.nvim
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
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
      { "weilbith/nvim-code-action-menu" },
      "aznhe21/actions-preview.nvim",
      { "artemave/workspace-diagnostics.nvim" },
      "b0o/schemastore.nvim", -- for jsonls
      { "yarospace/dev-tools.nvim" },
      {
        "rachartier/tiny-code-action.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- optional picker via telescope
        { "nvim-telescope/telescope.nvim" },
        -- optional picker via fzf-lua
        { "ibhagwan/fzf-lua" },
        -- .. or via snacks { "folke/snacks.nvim", opts = { terminal = {}, }
      },
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
      { "Exafunction/windsurf.nvim", event = "BufEnter" },
      "rmagatti/goto-preview",
      "kosayoda/nvim-lightbulb",
      "mickael-menu/zk-nvim",
      "dnlhc/glance.nvim",
      { "folke/lazydev.nvim", ft = "lua" },
      { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
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
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    -- keys = {
    --   {
    --     "<leader>xx",
    --     "<cmd>Trouble diagnostics toggle<cr>",
    --     desc = "Diagnostics (Trouble)",
    --   },
    --   {
    --     "<leader>xX",
    --     "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    --     desc = "Buffer Diagnostics (Trouble)",
    --   },
    --   {
    --     "<leader>cs",
    --     "<cmd>Trouble symbols toggle focus=false<cr>",
    --     desc = "Symbols (Trouble)",
    --   },
    --   {
    --     "<leader>cl",
    --     "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    --     desc = "LSP Definitions / references / ... (Trouble)",
    --   },
    --   {
    --     "<leader>xL",
    --     "<cmd>Trouble loclist toggle<cr>",
    --     desc = "Location List (Trouble)",
    --   },
    --   {
    --     "<leader>xQ",
    --     "<cmd>Trouble qflist toggle<cr>",
    --     desc = "Quickfix List (Trouble)",
    --   },
    -- },
  },
}

utils.apply_configs(plugins)

return plugins
