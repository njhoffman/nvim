local utils = require("lazy-utils")

local plugins = {
  { "andrewferrier/debugprint.nvim" },
  { "tpope/vim-repeat" },
  { "Konfekt/vim-alias" },
  { "gbprod/substitute.nvim" },
  { "kwkarlwang/bufjump.nvim" },
  { "andymass/vim-matchup" },
  { "chaoren/vim-wordmotion" },
  { "psliwka/vim-smoothie", commit = "10fd0aa" }, -- f2aaab1
  { "idbrii/vim-searchsavvy" },
  { dir = "~/git/clever-f.vim" }, -- rhysd/clever-f.vim
  { "AckslD/nvim-FeMaco.lua" },
  { "iamcco/markdown-preview.nvim", build = "cd app && yarn install", },
  {
    "njhoffman/neuron.nvim",
    {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  { "machakann/vim-sandwich" },
  { "chentoast/marks.nvim" },
  { "chiefnoah/neuron-v2.vim" },
}
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },

utils.apply_configs(plugins)
utils.print_stats('Motion', plugins)
return plugins
