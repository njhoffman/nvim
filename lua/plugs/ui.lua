local utils = require("lazy-utils")

local plugins = {
  { dir = "~/git/which-key.nvim" },
  {
    "m4xshen/smartcolumn.nvim",
    opts = {
      colorcolumn = 120,
      disabled_filetypes = { "help", "text", "markdown" },
      custom_colorcolumn = {},
      limit_to_window = false,
      limit_to_line = false,
    },
  },
  { "anuvyklack/hydra.nvim" },
  { "nacro90/numb.nvim" },
  { "rmagatti/goto-preview" },
  { "goolord/alpha-nvim", dependencies = "kyazdani42/nvim-web-devicons" },
  { "sindrets/diffview.nvim" },
  { "smjonas/live-command.nvim" },
  { "kevinhwang91/nvim-bqf" },
  { "kevinhwang91/nvim-ufo", dependencies = "kevinhwang91/promise-async" },
  { "t-troebst/perfanno.nvim" },
  { "jbyuki/quickmath.nvim" },
  { "tversteeg/registers.nvim" },
  { "nvim-colortils/colortils.nvim" },
  { "mbbill/undotree" },
  { "romainl/vim-qf" },
  { "svermeulen/vim-yoink" },
  { "MunifTanjim/nui.nvim" },
  { "stevearc/dressing.nvim", dependencies = "MunifTanjim/nui.nvim" },
  { "kevinhwang91/nvim-hlslens" },
  { "rcarriga/nvim-notify" },
  { "petertriho/nvim-scrollbar" },
  { "edluffy/specs.nvim" },
  { "luukvbaal/stabilize.nvim" },
  { "folke/twilight.nvim" },
  { "gerw/vim-HiLinkTrace" },
  { "ivyl/vim-bling" },
  { "romainl/vim-cool" },
  { "RRethy/vim-hexokinase", build = "make hexokinase" },
  { "norcalli/nvim-colorizer.lua" },
  { "joeysino/vim-plugin-AnsiEsc" },
  { "TaDaa/vimade" },
  { "folke/zen-mode.nvim" },
  { "phaazon/hop.nvim" },
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "neovim/nvim-lspconfig" },
    -- opts = { delay = 200 },
    -- config = function(_, opts)
  },
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
