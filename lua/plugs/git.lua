local utils = require("utils.lazy")
local plugins = {
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } },
  {
    "akinsho/git-conflict.nvim",
    cmd = { "GitConflictListQf", "GitConflictNextConflict" },
    event = { "BufReadPost", "BufNewFile" },
  },
  { "pwntester/octo.nvim", cmd = "Octo", dependencies = "nvim-tree/nvim-web-devicons" },
  { "kdheepak/lazygit.nvim", cmd = "LazyGit" },
  { "lewis6991/gitsigns.nvim", event = "BufReadPost", dependencies = "nvim-lua/plenary.nvim" },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Ggrep", "GMove", "GDelete", "Gspilt", "Gstatus", "Gwrite", "Gread", "Gdiffsplit", "Gedit" },
    dependencies = { { "tpope/vim-rhubarb", cmd = "GBrowse" } },
  },
}

utils.apply_configs(plugins)
return plugins
