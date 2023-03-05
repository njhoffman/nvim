local utils = require("lazy-utils")

local plugins = {
  { dir = "~/git/fidget.nvim", event = "LspAttach" },
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
    event = "BufReadPost",
    cmd = { "AerialToggle", "AerialNext", "AerialGo", "AerialOpen", "AerialPrev", "AerialOpenAll" },
    config = function()
      require("aerial").setup({
        backends = {
          ["_"] = { "lsp", "treesitter", "markdown", "man" },
          markdown = { "treesitter" },
        },
        filter_kind = {
          ["_"] = {
            "Class",
            "Constructor",
            "Enum",
            "EnumMember",
            "Event",
            "Field",
            "Function",
            "Interface",
            "Key",
            "Method",
            "Module",
            "Namespace",
            "Operator",
            -- "Package", -- this catches for/if ??
            "Property",
            "Struct",
            "Variable",
          },
          -- markdown = { "String" },
        },
      })
    end,
  },
  { "SmiteshP/nvim-navic", lazy = true, dependencies = { "utilyre/barbecue.nvim", "nvim-web-devicons" } },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {
      highlight = {
        -- keyword = "fg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        multiline = true, -- enable multine todo comments
        multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = "fg", -- "fg" or "bg" or empty
        keyword = "fg", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = "fg", -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      colors = {
        warning = { "Warning" },
        info = { "TodoMsg" },
        hint = { "#10B981" },
        default = { "TodoMsg" },
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
