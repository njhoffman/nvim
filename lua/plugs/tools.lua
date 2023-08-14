local utils = require('utils.lazy')
local plugins = {
  {
    'ThePrimeagen/refactoring.nvim',
    lazy = true,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  },
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
    config = function()
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
    config = function()
      require('neoai').setup({
        -- Below are the default options, feel free to override what you would like changed
        ui = {
          output_popup_text = 'NeoAI',
          input_popup_text = 'Prompt',
          width = 30, -- As percentage eg. 30%
          output_popup_height = 80, -- As percentage eg. 80%
          submit = '<Enter>', -- Key binding to submit the prompt
        },
        models = {
          {
            name = 'openai',
            model = 'gpt-3.5-turbo',
            params = nil,
          },
        },
        register_output = {
          ['g'] = function(output)
            return output
          end,
          ['c'] = require('neoai.utils').extract_code_snippets,
        },
        inject = {
          cutoff_width = 75,
        },
        prompts = {
          context_prompt = function(context)
            return "Hey, I'd like to provide some context for future "
              .. 'messages. Here is the code/text that I want to refer '
              .. 'to in our upcoming conversations:\n\n'
              .. context
          end,
        },
        mappings = {
          ['select_up'] = '<C-k>',
          ['select_down'] = '<C-j>',
        },
        open_api_key_env = 'OPENAI_API_KEY',
        shortcuts = {
          {
            name = 'textify',
            key = '<leader>as',
            desc = 'fix text with AI',
            use_context = true,
            prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
            modes = { 'v' },
            strip_function = nil,
          },
          {
            name = 'gitcommit',
            key = '<leader>ag',
            desc = 'generate git commit message',
            use_context = false,
            prompt = function()
              return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system('git diff --cached')
            end,
            modes = { 'n' },
            strip_function = nil,
          },
        },
      })
    end,
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
