local utils = require("utils.lazy")

local plugins = {
  -- navarasu/onedark.nvim
  -- projekt0n/github-nvim-theme
  { "rebelot/kanagawa.nvim", lazy = true },
  { "marko-cerovac/material.nvim", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "folke/tokyonight.nvim", lazy = true, opts = { style = "moon" } },
  { "catppuccin/nvim", lazy = true, name = "catppuccin" },
  {
    "jesseleite/nvim-noirbuddy",
    lazy = true,
    dependencies = {
      "tjdevries/colorbuddy.nvim",
      branch = "dev",
    },
  },
  {
    "nyoom-engineering/oxocarbon.nvim",
    lazy = true,
  },
  {
    "bluz71/vim-moonfly-colors",
    lazy = true,
  },
  {
    "bluz71/vim-nightfly-colors",
    lazy = true,
  },
  {
    "Everblush/nvim",
    lazy = true,
  },
  {
    "rockerBOO/boo-colorscheme-nvim",
    lazy = true,
  },
  {
    "phha/zenburn.nvim",
    lazy = true,
  },
  {
    "JoosepAlviste/palenightfall.nvim",
    lazy = true,
  },
  {
    "yonlu/omni.vim",
    lazy = true,
  },
  {
    "lighthaus-theme/vim-lighthaus",
    lazy = true,
  },
  {
    "Abstract-IDE/Abstract-cs",
    lazy = true,
  },
  {
    "Mofiqul/dracula.nvim",
    lazy = true,
  },
  {
    "mcchrish/zenbones.nvim",
    lazy = true,
    dependencies = {
      "rktjmp/lush.nvim",
    },
  },
  {
    "LunarVim/horizon.nvim",
    lazy = true,
  },
  {
    "LunarVim/synthwave84.nvim",
    lazy = true,
  },
  {
    "katawful/kat.nvim",
    lazy = true,
  },
  {
    "rose-pine/neovim",
    lazy = true,
  },
  {
    "hachy/eva01.vim",
    lazy = true,
  },
  {
    "igorgue/danger",
    lazy = true,
  },
  {
    "arturgoms/moonbow.nvim",
    lazy = true,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {
      palette_overrides = {},
    },
  },
  {
    -- Tons of awesome color schemes in base16. Really nice!
    "RRethy/nvim-base16",
    lazy = true,
  },
}

utils.apply_configs(plugins)
return plugins

-- { "edluffy/hologram.nvim", cond = os.getenv("KITTY_WINDOW_ID") ~= nil
-- ["nvim-highlight-colors"] = { "brenoprata10/nvim-highlight-color" },
-- ["icon-picker.nvim"] = { "ziontee113/icon-picker.nvim"}
-- ["vim-visual-multi"] = { "mg979/vim-visual-multi" },
-- ["wilder.nvim"] = {
--   "gelguy/wilder.nvim",
--   rocks = { "luarocks-fetch-gitrec", "pcre2" },
--   requires = { "romgrk/fzy-lua-native", "nvim-tree/nvim-web-devicons" }
-- }
-- ["codewindow.nvim"] = { "gorbit99/codewindow.nvim" },
-- https://github.com/anuvyklack/windows.nvim
-- ["yank-history"] = {"yazgoo/yank-history"},
-- https://github.com/gbprod/yanky.nvim
