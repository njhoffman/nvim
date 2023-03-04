local utils = require("lazy-utils")

local plugins = {
  { dir = "~/git/which-key.nvim" },
  { "romainl/vim-qf", ft = "qf" },
  { "jbyuki/quickmath.nvim", cmd = "Quickmath" },
  { "kevinhwang91/nvim-bqf", cmd = { "BqfEnable", "BqfToggle" }, ft = "qf" },
  {
    "sindrets/diffview.nvim",
    cmd = { "Diffview", "DiffviewLog", "DiffviewOpen", "DiffviewToggleFiles", "DiffviewFileHistory" },
  },
  { "nvim-colortils/colortils.nvim", cmd = "Colortils" },
  { "joeysino/vim-plugin-AnsiEsc", cmd = "AnsiEsc" },
  { "folke/zen-mode.nvim", cmd = "ZenMode" },
  { "tversteeg/registers.nvim", cmd = "Registers" },
  { "mbbill/undotree", cmd = { "UndotreeToggle", "UndotreeFocus", "UndotreeShow" } },
  { "folke/twilight.nvim", cmd = { "Twilight", "TwilightEnable" } },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
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
  },
  {
    "rcarriga/nvim-notify",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local notify = require("notify")
      notify.setup({
        icons = { DEBUG = "", ERROR = "", INFO = "", HINT = "", TRACE = "✎", WARN = "" },
        -- render = "simple",
      })
      vim.notify = notify

      local vim_notify = vim.notify
      vim.notify = function(msg, ...)
        if msg:match("warning: multiple different client offset_encodings") then
          return
        end
        vim_notify(msg, ...)
      end

      vim.keymap.set("n", "<esc>", function()
        notify.dismiss()
        vim.cmd.noh()
      end)
      vim.lsp.handlers["window/showMessage"] = function(_, method, params, _)
        vim.notify(method.message, params.type)
      end
    end,
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
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    cmd = { "UfoEnable", "UfoAttach", "UfoEnableFold" },
  },
  { "t-troebst/perfanno.nvim", cmd = { "PerfLoadFlat", "PerfLoadCallGraph", "PerfLoadFlameGraph" } },
  { "nacro90/numb.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "ivyl/vim-bling", event = { "BufReadPost", "BufNewFile" } },
  { "romainl/vim-cool", event = { "BufReadPost", "BufNewFile" } },
  { "petertriho/nvim-scrollbar", event = { "BufReadPost", "BufNewFile" } },
  { "edluffy/specs.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "RRethy/vim-illuminate", event = { "BufReadPost", "BufNewFile" }, dependencies = { "neovim/nvim-lspconfig" } },
  { "TaDaa/vimade", event = { "BufReadPost", "BufNewFile" } },
  { "goolord/alpha-nvim", event = "VimEnter", dependencies = "kyazdani42/nvim-web-devicons" },

  {
    "m4xshen/smartcolumn.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help", "text", "markdown" },
      custom_colorcolumn = {},
      limit_to_window = false,
      limit_to_line = false,
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    dependencies = "MunifTanjim/nui.nvim",
    opts = {
      input = {
        win_options = {
          winblend = 10,
        },
        select = {
          backend = { "nui", "telescope" },
          -- telescope = require('telescope.themes').get_ivy({...})
        },
      },
    },
  },
  { "phaazon/hop.nvim", branch = "v2", event = "VeryLazy" },
  { "tpope/vim-rhubarb", event = "VeryLazy" },
  { "kevinhwang91/nvim-hlslens", event = "VeryLazy" },
  { "RRethy/vim-hexokinase", event = "VeryLazy", build = "make hexokinase" },
  { "anuvyklack/hydra.nvim", event = "VeryLazy" },
  { "MunifTanjim/nui.nvim", event = "VeryLazy" },
}

utils.apply_configs(plugins)
utils.print_stats("UI", plugins)
return plugins

--
-- { "edluffy/hologram.nvim", cond = os.getenv("KITTY_WINDOW_ID") ~= nil
-- ["nvim-highlight-colors"] = { "brenoprata10/nvim-highlight-color" },
-- ["vim-hexokinase"]     = { "RRethy/vim-hexokinase", run = "make hexokinase" },
-- ["startup.nvim"] = {
--   use = {"startup-nvim/startup.nvim", requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"}}
-- },
-- ["icon-picker.nvim"] = { "ziontee113/icon-picker.nvim"}
-- ["vim-visual-multi"] = { "mg979/vim-visual-multi" },
-- ["wilder.nvim"] = {
--   "gelguy/wilder.nvim",
--   rocks = { "luarocks-fetch-gitrec", "pcre2" },
--   requires = { "romgrk/fzy-lua-native", "kyazdani42/nvim-web-devicons" }
-- }
-- ["nvim-tree.lua"] = { "kyazdani42/nvim-tree.lua" },
-- ["codewindow.nvim"] = { "gorbit99/codewindow.nvim" },
-- https://github.com/anuvyklack/windows.nvim
-- ["yank-history"] = {"yazgoo/yank-history"},
-- ["vim-mundo"] = { "simnalamburt/vim-mundo" },
-- https://github.com/gbprod/yanky.nvim
