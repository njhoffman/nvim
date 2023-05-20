local utils = require('utils.lazy')

local plugins = {

  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
      -- https://github.com/David-Kunz/markid
      'RRethy/nvim-treesitter-endwise',
      'theHamsta/nvim-treesitter-pairs',
      'RRethy/nvim-treesitter-textsubjects',
      'HiPhish/nvim-ts-rainbow2',
      'jbyuki/tree-sitter-ntangle',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/playground',
      'romgrk/nvim-treesitter-context',
      -- /mfussenegger/nvim-treehopper
      -- https://github.com/David-Kunz/markid
      'windwp/nvim-ts-autotag',
    },
  },
  { 'echasnovski/mini.surround', event = { 'BufRead' }, version = false },
  -- matching
  -- { "andymass/vim-matchup", dependencies = { "theHamsta/nvim-treesitter-pairs" } },
  -- pairs
  { 'echasnovski/mini.pairs', event = 'InsertEnter' },
  -- { 'windwp/nvim-autopairs', event = 'InsertEnter', enabled = false, dependencies = { 'nvim-cmp' } },
  -- textobjects
  { 'echasnovski/mini.ai', event = { 'BufReadPost', 'BufNewFile' }, version = false },
  { 'chrisgrieser/nvim-various-textobjs', event = { 'BufReadPost', 'BufNewFile' } },
  -- split/join
  { 'echasnovski/mini.splitjoin', event = { 'BufReadPost', 'BufNewFile' }, version = false },
  { 'Wansmer/treesj', event = { 'BufReadPost', 'BufNewFile' }, lazy = false, dependencies = { 'nvim-treesitter' } },
  -- traversal/swapping
  { 'mizlan/iswap.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'ziontee113/SelectEase', event = 'VeryLazy' },
  { 'chrisgrieser/nvim-spider', event = 'VeryLazy' },
  { 'echasnovski/mini.move', event = 'VeryLazy' },
  -- alignment
  { 'echasnovski/mini.align', version = false, event = 'VeryLazy' },
  -- { 'hrsh7th/nvim-pasta' },
  { 'dhruvasagar/vim-table-mode', event = 'VeryLazy', ft = { 'markdown', 'pandoc', 'vimwiki' } },
  { 'echasnovski/mini.doc', version = false, event = 'VeryLazy' },
  { 'echasnovski/mini.bracketed', event = 'VeryLazy', version = false },
  { 'jkramer/vim-checkbox', event = 'VeryLazy', ft = { 'markdown', 'pandoc', 'vimwiki' } },
  { 'nicwest/vim-camelsnek', event = 'VeryLazy' },
  -- formatting
  { 'johmsalas/text-case.nvim', event = 'VeryLazy' },
  { 'echasnovski/mini.comment', version = false, event = 'VeryLazy' },
  { 'numToStr/Comment.nvim', event = 'VeryLazy' },
  { 'andrewferrier/debugprint.nvim', event = 'VeryLazy' },
  { 'ecthelionvi/NeoComposer.nvim', event = 'VeryLazy', dependencies = { 'kkharji/sqlite.lua', 'telescope.nvim' } },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  { 'smjonas/live-command.nvim', cmd = { 'Reg', 'Norm' }, event = 'VeryLazy' },
  { 'Konfekt/vim-alias', event = 'VeryLazy' },
  {
    'psliwka/vim-smoothie',
    commit = '10fd0aa',
    init = function()
      vim.g.smoothie_break_on_reverse = 0
      vim.g.smoothie_enabled = 1
      vim.g.smoothie_no_default_mappings = 1
      vim.g.smoothie_experimental_mappings = 0
      vim.g.smoothie_update_interval = 20
      vim.g.smoothie_speed_constant_factor = 10
      vim.g.smoothie_speed_linear_factor = 10
      vim.g.smoothie_speed_exponentiation_factor = 0.9
      vim.g.redraw_at_finish = 1
      vim.g.smoothie_minimum_speed = 0.9
    end,
  }, -- f2aaab1
  { dir = '~/git/clever-f.vim' }, -- rhysd/clever-f.vim
}
utils.apply_configs(plugins)
return plugins

-- { "chentoast/marks.nvim" },
-- { "inkarkat/vim-UnconditionalPaste",
-- requires = "inkarkat/vim-ingo-library" },
