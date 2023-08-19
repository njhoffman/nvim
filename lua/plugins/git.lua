local utils = require('utils.lazy')
local plugins = {
  { 'rbong/vim-flog', cmd = { 'Flog', 'Flogsplit' } },
  {
    'f-person/git-blame.nvim',
    init = function()
      vim.g.gitblame_enabled = 0
    end,
  },
  { 'ThePrimeagen/git-worktree.nvim', event = 'VeryLazy' },
  { 'napisani/nvim-github-codesearch', build = 'make' },
  { 'akinsho/git-conflict.nvim', version = '*', lazy = false },
  { 'pwntester/octo.nvim', cmd = 'Octo', dependencies = 'nvim-tree/nvim-web-devicons' },
  { 'kdheepak/lazygit.nvim', cmd = 'LazyGit' },
  { 'lewis6991/gitsigns.nvim', event = 'BufReadPost', dependencies = 'nvim-lua/plenary.nvim' },
  { 'rhysd/git-messenger.vim' },
  {
    'tpope/vim-fugitive',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'Git', 'Ggrep', 'GMove', 'GDelete', 'Gspilt', 'Gstatus', 'Gwrite', 'Gread', 'Gdiffsplit', 'Gedit' },
    dependencies = { { 'tpope/vim-rhubarb', cmd = 'GBrowse' } },
  },
}

utils.apply_configs(plugins)
return plugins
