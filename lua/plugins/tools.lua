local utils = require('utils.lazy')
-- https://github.com/RaafatTurki/hex.nvim

local plugins = {
  {
    'ThePrimeagen/refactoring.nvim',
    lazy = true,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  },
  { 'LunarVim/bigfile.nvim' },
  {
    'nvim-neotest/neotest',
    cmd = { 'Neotest', 'NeotestSummary', 'NeotestNearest', 'NeotestAttach' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neotest/neotest-python',
      'nvim-neotest/neotest-plenary',
      'rouge8/neotest-rust',
      'akinsho/neotest-go',
      'nvim-treesitter/nvim-treesitter',
      'antoinemadec/FixCursorHold.nvim',
      {
        'nvim-neotest/neotest-vim-test',
        dependencies = { 'vim-test/vim-test', cmd = { 'Test', 'TestNearest', 'TestFile' } },
      },
    },
  },
  -- quickfix file renamer
  {
    'gabrielpoca/replacer.nvim',
    opts = { rename_files = false },
    keys = {
      {
        '<leader>h',
        function()
          require('replacer').run()
        end,
        desc = 'run replacer.nvim',
      },
    },
  },
  { 'chrisgrieser/nvim-early-retirement', event = 'VeryLazy' },
  {
    'qpkorr/vim-renamer',
    init = function()
      vim.g.RenamerShowHiddenEnabled = true
    end,
  },
  {
    'chrisbra/unicode.vim',
    cmd = {
      'Digraphs',
      'UnicodeSearch',
      'UnicodeName',
      'UnicodeTable',
      'DownloadUnicode',
      'UnicodeCache',
    },
  },
  {
    'simonefranza/nvim-conv',
    cmd = {
      'ConvBin',
      'ConvDec',
      'ConvHex',
      'ConvOct',
      'ConvFarenheit',
      'ConvCelsius',
      'ConvStr',
      'ConvBytes',
      'ConvMetricImperial',
      'ConvDataTransRate',
      'ConvColor',
      'ConvSetPrecision',
    },
  },
  {
    'jamestthompson3/nvim-remote-containers',
    cmd = { 'BuildImage', 'AttachToContainer', 'StartImage', 'ComposeUp', 'ComposeDown', 'ComposeDestroy' },
  },
  { 'kelly-lin/ranger.nvim', lazy = true },
  { 'lambdalisue/suda.vim', event = 'VeryLazy' },
  { 'skywind3000/asynctasks.vim', event = 'VeryLazy', dependencies = 'skywind3000/asyncrun.vim' },
  { 'aymericbeaumet/vim-symlink', event = 'VeryLazy', dependencies = 'moll/vim-bbye' },
  { 't-troebst/perfanno.nvim', cmd = { 'PerfLoadFlat', 'PerfLoadCallGraph', 'PerfLoadFlameGraph' } },
  {
    'chrisgrieser/nvim-genghis',
    event = 'VeryLazy',
    dependencies = { 'stevearc/dressing.nvim', 'hrsh7th/nvim-cmp', 'hrsh7th/cmp-omni' },
  },
  { 'echasnovski/mini.test', lazy = true },
  { 'gennaro-tedesco/nvim-jqx', lazy = true, cmd = { 'JqxList', 'JqxQuery' } },
  { 'npxbr/glow.nvim', cmd = 'Glow' },
  { 'NTBBloodbath/rest.nvim', cmd = { 'RESTRunLast', 'RESTRun', 'RESTPreview' } },
  { 'dbeniamine/cheat.sh-vim', cmd = 'Cheat' },
  { 'potamides/pantran.nvim', cmd = 'Pantran' },
  { 'sidebar-nvim/sidebar.nvim', cmd = { 'SidebarNvimOpen', 'SidebarNvimToggle' } },
  { 'anuvyklack/hydra.nvim', event = 'VeryLazy' },
  { 'goolord/alpha-nvim', event = 'VimEnter', dependencies = 'nvim-tree/nvim-web-devicons' },
  { 'nvim-colortils/colortils.nvim', cmd = 'Colortils', event = { 'BufReadPost', 'BufNewFile' } },
  { 'xeluxee/competitest.nvim', cmd = 'CompetiTestRun', dependencies = 'MunifTanjim/nui.nvim' },
  { -- A lua profiler for neovim that is discovered thanks to https://www.reddit.com/r/neovim/comments/xicxox/comment/ip2hprd
    'stevearc/profile.nvim',
    cond = function()
      return vim.env.NVIM_PROFILE ~= nil
    end,
  },
  { 'AckslD/nvim-neoclip.lua', event = 'VimEnter', dependencies = 'kkharji/sqlite.lua' },
  {
    'simnalamburt/vim-mundo',
    cmd = { 'MundoToggle', 'MundoShow', 'MundoHide' },
    build = function()
      vim.cmd([[UpdateRemotePlugins]])
    end,
    init = function()
      vim.g.mundo_prefer_python3 = 1
      vim.g.mundo_width = 35
      vim.g.mundo_preview_height = 10
      vim.g.mundo_right = 1
      vim.g.mundo_help = 0
      vim.g.mundo_disable = 0
      vim.g.mundo_preview_bottom = 1
      vim.g.mundo_close_on_revert = 0
      vim.g.mundo_auto_preview = 1
      vim.g.mundo_playback_delay = 60
      -- vim.g.mundo_preview_statusline = nil
      -- vim.g.mundo_tree_statusline = nil
    end,
  },
  {
    'tools-life/taskwiki',
    cmd = { 'TW', 'TWSync' },
    build = 'pip3 install --upgrade git+git://github.com/tbabej/tasklib@develop',
    dependencies = {
      {
        'vimwiki/vimwiki',
        branch = 'dev',
        init = function()
          vim.g.vimwiki_filetypes = { 'vimwiki', 'markdown', 'pandoc' }
          vim.g.vimwiki_global_ext = 0
          vim.g.vimwiki_key_mappings = { all_maps = 0 }
          -- vim.cmd([[let g:vimwiki_key_mappings = { 'all_maps': 0, }]])
        end,
      },
      'vim-plugin-AnsiEsc',
      'farseer90718/vim-taskwarrior',
      'preservim/tagbar',
    },
  },
  {
    'mthbernardes/codeexplain.nvim',
    lazy = true,
    cmd = 'CodeExplain',
    -- pip install -r langchain==0.0.177 llama-cpp-python==0.1.48 Pygments==2.15.1 pynvim==0.4.3
    build = function()
      vim.cmd([[silent UpdateRemotePlugins]])
    end,
  },
  {
    'Bryley/neoai.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    cmd = {
      'NeoAI',
      'NeoAIOpen',
      'NeoAIClose',
      'NeoAIToggle',
      'NeoAIContext',
      'NeoAIContextOpen',
      'NeoAIContextClose',
      'NeoAIInject',
      'NeoAIInjectCode',
      'NeoAIInjectContext',
      'NeoAIInjectContextCode',
    },
    keys = {
      { '<leader>as', desc = 'summarize text' },
      { '<leader>ag', desc = 'generate git message' },
    },
  },
  {
    'jackMort/ChatGPT.nvim',
    cmd = { 'ChatGPT', 'ChatGPTEditWithInstructions', 'ChatGPTActAs' },
    -- enabled = false,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'telescope.nvim',
    },
  },
}

utils.apply_configs(plugins)
return plugins
