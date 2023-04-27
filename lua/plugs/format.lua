local utils = require('utils.lazy')

local plugins = {
  -- alignment
  { 'echasnovski/mini.align', version = false, event = 'VeryLazy' },
  -- { "junegunn/vim-easy-align", cmd = "EasyAlign", event = { "BufReadPost", "BufNewFile" } }, -- tommcdo/vim-lion
  -- { 'hrsh7th/nvim-pasta' },
  { 'dhruvasagar/vim-table-mode', event = 'VeryLazy', ft = { 'markdown', 'pandoc', 'vimwiki' } },
  { 'jkramer/vim-checkbox', event = 'VeryLazy', ft = { 'markdown', 'pandoc', 'vimwiki' } },
  { 'monaqa/dial.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'nicwest/vim-camelsnek', event = 'VeryLazy' },
  { 'johmsalas/text-case.nvim', event = 'VeryLazy' },
  { 'numToStr/Comment.nvim', event = 'VeryLazy' },
}

utils.apply_configs(plugins)
return plugins

-- https://github.com/Furkanzmc/zettelkasten.nvim
-- https://github.com/phaazon/mind.nvim
-- https://github.com/mickael-menu/zk-nvim
