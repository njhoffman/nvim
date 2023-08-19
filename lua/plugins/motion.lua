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
      'lukas-reineke/headlines.nvim',
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
  {
    'sustech-data/wildfire.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'ziontee113/query-secretary',
    dependencies = { 'nvim-treesitter' },
    keys = { '<leader><BS>' },
  },
  { 'gbprod/substitute.nvim', event = { 'VeryLazy' } },
  {
    'ckolkey/ts-node-action',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter', 'null-ls.nvim' },
  },
  { 'echasnovski/mini.surround', event = { 'VeryLazy' } },
  -- matching
  -- { "andymass/vim-matchup", dependencies = { "theHamsta/nvim-treesitter-pairs" } },
  -- pairs
  { 'echasnovski/mini.pairs', event = 'InsertEnter' },
  -- { 'windwp/nvim-autopairs', event = 'InsertEnter', enabled = false, dependencies = { 'nvim-cmp' } },
  -- textobjects
  { 'echasnovski/mini.ai', event = { 'VeryLazy' } },
  { 'chrisgrieser/nvim-various-textobjs', event = { 'VeryLazy' } },
  -- split/join
  { 'echasnovski/mini.splitjoin', event = { 'VeryLazy' } },
  { 'Wansmer/treesj', event = { 'VeryLazy' }, dependencies = { 'nvim-treesitter' } },
  -- traversal/swapping
  { 'mizlan/iswap.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'ziontee113/SelectEase', event = 'VeryLazy' },
  { 'chrisgrieser/nvim-spider', event = 'VeryLazy' },
  { 'echasnovski/mini.move', event = 'VeryLazy' },
  -- alignment
  { 'echasnovski/mini.align', event = 'VeryLazy' },
  -- { 'hrsh7th/nvim-pasta' },
  { 'dhruvasagar/vim-table-mode', event = 'VeryLazy', ft = { 'markdown', 'pandoc', 'vimwiki' } },
  { 'echasnovski/mini.doc', version = false, event = 'VeryLazy' },
  { 'echasnovski/mini.bracketed', event = 'VeryLazy' },
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
  { 'rainbowhxch/accelerated-jk.nvim', enabled = false },
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
  -- integrations
  { 'aserowy/tmux.nvim', event = 'VeryLazy' },
  { 'jbyuki/quickmath.nvim', cmd = 'Quickmath', event = 'VeryLazy' },
  { 'jameshiew/nvim-magic', dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim', event = 'VeryLazy' } },
  { 'michaelb/sniprun', build = 'bash install.sh', cmd = { 'SnipRun', 'SnipInfo' } },
  { 'milisims/nvim-luaref', event = 'VeryLazy' },
  { 'windwp/nvim-spectre', cmd = 'Spectre' },
  { 'WaylonWalker/Telegraph.nvim', cmd = 'Telegraph' },
  {
    'bennypowers/nvim-regexplainer',
    cmd = { 'RegexplainerShow', 'RegexplainerToggle' },
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
  },
  -- { 'rmagatti/auto-session', event = 'VimEnter' },
  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
  { 'AndrewRadev/id3.vim' },
  {
    'susensio/magic-bang.nvim',
    ft = 'sh',
    opts = { automatic = true, command = true, executable = true, default = '/bin/bash' },
  },
}
utils.apply_configs(plugins)
return plugins

-- { "chentoast/marks.nvim" },
-- { "inkarkat/vim-UnconditionalPaste",
-- requires = "inkarkat/vim-ingo-library" },
