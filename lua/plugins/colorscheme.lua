local utils = require('utils.lazy')

local plugins = {
  -- navarasu/onedark.nvim
  -- projekt0n/github-nvim-theme
  { 'rebelot/kanagawa.nvim', event = 'User ColorSchemeLoad' },
  { 'marko-cerovac/material.nvim', event = 'User ColorSchemeLoad' },
  { 'EdenEast/nightfox.nvim', event = 'User ColorSchemeLoad' },
  { 'folke/tokyonight.nvim', event = 'User ColorSchemeLoad', opts = { style = 'moon' } },
  { 'catppuccin/nvim', event = 'User ColorSchemeLoad', name = 'catppuccin' },
  {
    'jesseleite/nvim-noirbuddy',
    event = 'User ColorSchemeLoad',
    dependencies = {
      'tjdevries/colorbuddy.nvim',
      branch = 'dev',
    },
  },
  {
    'nyoom-engineering/oxocarbon.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'bluz71/vim-moonfly-colors',
    event = 'User ColorSchemeLoad',
  },
  {
    'bluz71/vim-nightfly-colors',
    event = 'User ColorSchemeLoad',
  },
  {
    'Everblush/nvim',
    name = 'Everblush.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'rockerBOO/boo-colorscheme-nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'phha/zenburn.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'JoosepAlviste/palenightfall.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'yonlu/omni.vim',
    event = 'User ColorSchemeLoad',
  },
  {
    'lighthaus-theme/vim-lighthaus',
    event = 'User ColorSchemeLoad',
  },
  {
    'Abstract-IDE/Abstract-cs',
    event = 'User ColorSchemeLoad',
  },
  {
    'Mofiqul/dracula.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'mcchrish/zenbones.nvim',
    event = 'User ColorSchemeLoad',
    dependencies = {
      'rktjmp/lush.nvim',
    },
  },
  {
    'LunarVim/horizon.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'LunarVim/synthwave84.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'katawful/kat.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'rose-pine/neovim',
    event = 'User ColorSchemeLoad',
  },
  {
    'hachy/eva01.vim',
    event = 'User ColorSchemeLoad',
  },
  {
    'igorgue/danger',
    event = 'User ColorSchemeLoad',
  },
  {
    'arturgoms/moonbow.nvim',
    event = 'User ColorSchemeLoad',
  },
  {
    'ellisonleao/gruvbox.nvim',
    event = 'User ColorSchemeLoad',
    opts = {
      palette_overrides = {},
    },
  },
  {
    'projekt0n/github-nvim-theme',
    config = function()
      require('github-theme').setup({})
    end,
  },
  {
    -- Tons of awesome color schemes in base16. Really nice!
    'RRethy/nvim-base16',
    event = 'User ColorSchemeLoad',
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
