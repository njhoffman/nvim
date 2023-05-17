local utils = require('utils.lazy')
local plugins = {
  {
    'LunarVim/bigfile.nvim',
    config = function()
      -- default config
      require('bigfile').config({
        filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
        pattern = { '*' }, -- autocmd pattern
        features = { -- features to disable
          'indent_blankline',
          'illuminate',
          'lsp',
          'treesitter',
          'syntax',
          'matchparen',
          'vimopts',
          'filetype',
        },
      })
    end,
  },
  -- https://github.com/RaafatTurki/hex.nvim
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
  { 'chrisgrieser/nvim-early-retirement', event = 'VeryLazy' },
  {
    'qpkorr/vim-renamer',
    config = function()
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
  { 'lambdalisue/suda.vim', event = 'VeryLazy' },
  { 'skywind3000/asynctasks.vim', event = 'VeryLazy', dependencies = 'skywind3000/asyncrun.vim' },
  { 'aymericbeaumet/vim-symlink', event = 'VeryLazy', dependencies = 'moll/vim-bbye' },
  { 't-troebst/perfanno.nvim', cmd = { 'PerfLoadFlat', 'PerfLoadCallGraph', 'PerfLoadFlameGraph' } },
  {
    'chrisgrieser/nvim-genghis',
    event = 'VeryLazy',
    dependencies = { 'stevearc/dressing.nvim', 'hrsh7th/nvim-cmp', 'hrsh7th/cmp-omni' },
  },
  {
    'echasnovski/mini.test',
    version = false,
    -- No need to copy this inside `setup()`. Will be used automatically.
    -- opts = {
    --   -- Options for collection of test cases. See `:h MiniTest.collect()`.
    --   collect = {
    --     -- Temporarily emulate functions from 'busted' testing framework
    --     -- (`describe`, `it`, `before_each`, `after_each`, and more)
    --     emulate_busted = true,
    --
    --     -- Function returning array of file paths to be collected.
    --     -- Default: all Lua files in 'tests' directory starting with 'test_'.
    --     find_files = function()
    --       return vim.fn.globpath('tests', '**/test_*.lua', true, true)
    --     end,
    --
    --     -- Predicate function indicating if test case should be executed
    --     filter_cases = function(case)
    --       return true
    --     end,
    --   },
    --
    --   -- Options for execution of test cases. See `:h MiniTest.execute()`.
    --   execute = {
    --     -- Table with callable fields `start()`, `update()`, and `finish()`
    --     reporter = nil,
    --
    --     -- Whether to stop execution after first error
    --     stop_on_error = false,
    --   },
    --
    --   -- Path (relative to current directory) to script which handles project
    --   -- specific test running
    --   script_path = 'scripts/minitest.lua',
    --
    --   -- Whether to disable showing non-error feedback
    --   silent = false,
    -- },
  },
  { 'gennaro-tedesco/nvim-jqx', lazy = true, cmd = { 'JqxList', 'JqxQuery' } },
  { 'bfrg/vim-jqplay', ft = 'jq', cmd = { 'Jqplay', 'JqplayScratch', 'JqplayScratchNoInput' } },
  { 'npxbr/glow.nvim', cmd = 'Glow' },
  { 'NTBBloodbath/rest.nvim', cmd = { 'RESTRunLast', 'RESTRun', 'RESTPreview' } },
  { 'dbeniamine/cheat.sh-vim', cmd = 'Cheat' },
  { 'potamides/pantran.nvim', cmd = 'Pantran' },
  { 'sidebar-nvim/sidebar.nvim', cmd = { 'SidebarNvimOpen', 'SidebarNvimToggle' } },
  { 'anuvyklack/hydra.nvim', event = 'VeryLazy' },
  { 'goolord/alpha-nvim', event = 'VimEnter', dependencies = 'nvim-tree/nvim-web-devicons' },
  { 'nvim-colortils/colortils.nvim', cmd = 'Colortils' },
  { 'xeluxee/competitest.nvim', cmd = 'CompetiTestRun', dependencies = 'MunifTanjim/nui.nvim' },
  { 'AckslD/nvim-neoclip.lua', event = 'VimEnter', dependencies = 'kkharji/sqlite.lua' },
  {
    'simnalamburt/vim-mundo',
    cmd = { 'MundoToggle', 'MundoShow', 'MundoHide' },
    build = function()
      vim.cmd([[UpdateRemotePlugins]])
    end,
    config = function()
      vim.g.mundo_prefer_python3 = 1
      vim.g.mundo_width = 35
      vim.g.mundo_preview_height = 5
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
    'jackMort/ChatGPT.nvim',
    cmd = { 'ChatGPT', 'ChatGPTEditWithInstructions', 'ChatGPTActAs' },
    -- enabled = false,
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'njhoffman/telescope.nvim',
    },
  },
}

utils.apply_configs(plugins)
return plugins
