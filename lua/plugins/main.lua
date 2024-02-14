local utils = require('utils.lazy')
local lz_syn = false

local plugins = {
  { 'stevearc/dressing.nvim', dependencies = 'MunifTanjim/nui.nvim', event = 'VeryLazy' },
  {
    '3rd/image.nvim',
    enabled = false,
    event = 'VeryLazy',
    dependencies = 'nvim-treesitter',
  },
  { 'goolord/alpha-nvim', event = 'VimEnter', dependencies = 'nvim-web-devicons' },
  { 'tamton-aquib/zone.nvim', enabled = false },
  -- using lazy.nvim
  -- { 'akinsho/bufferline.nvim', version = '*', dependencies = 'nvim-tree/nvim-web-devicons' },
  {
    'romgrk/barbar.nvim',
    -- https://github.com/romgrk/barbar.nvim/pull/540
    -- 'gbprod/barbar.nvim',
    -- branch = 'fix-telescope-insert',
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    event = 'VimEnter',
    dependencies = 'nvim-web-devicons',
  },
  { 'declancm/cinnamon.nvim', event = 'VeryLazy' },
  { 'karb94/neoscroll.nvim', event = 'VeryLazy' },
  {
    'rasulomaroff/reactive.nvim',
    enabled = true,
    lazy = false,
  },
  {
    'RutaTang/quicknote.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'LintaoAmons/scratch.nvim',
    event = 'VeryLazy',
    -- Scratch, ScratchOpen, ScrathWithName, ScratchOpenFzf, ScratchPad
    -- nvim -c 'lua require("scratch").scratchByType("md")'
  },
  -- { 'stevearc/stickybuf.nvim', event = 'VeryLazy' },
  { 'rgroli/other.nvim', event = 'VeryLazy' },
  {
    'tummetott/reticle.nvim',
    enabled = false,
    lazy = false,
    event = { 'BufReadPre', 'BufNewFile' },
    -- reticle messes up with Neo-tree cursorline in search mode
    opts = {
      always = { cursorline = { 'neo-tree' } },
      on_startup = { cursorline = true, cursorcolumn = false },
      never = { cursorline = { 'qf', 'noice', 'navbuddy' }, cursorcolumn = { 'qf', 'noice', 'navbuddy' } },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    commit = '0dca928',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  { 'Tyler-Barham/floating-help.nvim', cmd = 'FloatHelp' },
  { 'tris203/hawtkeys.nvim', event = { 'VeryLazy' } },
  {
    'echasnovski/mini.clue',
    enabled = false,
    event = { 'VeryLazy' },
  },
  {
    'nmac427/guess-indent.nvim',
    event = 'BufReadPre',
    opts = {
      -- due to code blocks and bullets often having spaces or tabs
      filetype_exclude = { 'markdown' },
      --   auto_cmd = true, -- Set to false to disable automatic execution
      --   override_editorconfig = false, -- Set to true to override settings set by .editorconfig
      --   filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
      --     'netrw',
      --     'tutor',
      --   },
      --   buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
      --     'help',
      --     'nofile',
      --     'terminal',
      --     'prompt',
      --   },
    },
  },
  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPre', 'BufNewFile' },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          local ft = vim.api.nvim_buf_get_option(0, 'filetype')
          local bt = vim.api.nvim_buf_get_option(0, 'buftype')
          local ft_exclude = {
            'alpha',
            'dap.*',
            'dashboard',
            'guihua',
            'help',
            'lazy',
            'lspinfo',
            'mason',
            'neo-tree',
            'noice',
            'null-ls-info',
            'qf',
            'sidekick',
            'neo-tree',
            'NvimTree',
            'tablegen',
            'Trouble',
          }
          local bt_exclude = { 'terminal', 'prompt', 'nofile', 'quickfix' }
          if vim.tbl_contains(ft_exclude, ft) or vim.tbl_contains(bt_exclude, bt) then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end,
  },
  { 'echasnovski/mini.trailspace', event = 'VeryLazy' },
  {
    'sindrets/diffview.nvim',
    cmd = { 'Diffview', 'DiffviewLog', 'DiffviewOpen', 'DiffviewToggleFiles', 'DiffviewFileHistory' },
  },
  { 'm00qek/baleia.nvim', lazy = false, commit = '56ad00d' },
  { 'folke/zen-mode.nvim', cmd = 'ZenMode', keys = { '<S-CR>' } },
  { 'folke/twilight.nvim', cmd = { 'Twilight', 'TwilightEnable' } },
  -- { 'benlubas/wrapping-paper.nvim' },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    cmd = { 'UfoEnable', 'UfoAttach', 'UfoEnableFold' },
    event = { 'BufReadPost', 'InsertEnter' },
  },
  {
    'laytan/tailwind-sorter.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-lua/plenary.nvim' },
    build = 'cd formatter && npm i && npm run build',
    config = function()
      require('tailwind-sorter').setup({
        on_save_enabled = true, -- If `true`, automatically enables on save sorting.
        node_path = '/home/nicholas/.asdf/shims/node',
      })
    end,
  },
  { 'BlackLight/nvim-http' },
  {
    'jellydn/hurl.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    ft = 'hurl',
    -- keys = {
    --   -- Run API request
    --   { "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
    --   { "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
    --   { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
    --   { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
    --   { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
    --   -- Run Hurl request in visual mode
    --   { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    -- },
  },
  {
    'MaximilianLloyd/tw-values.nvim',
    -- ft = 'typescriptreact, typescript, astro, vue, svelte, html'
    keys = {
      { '<leader>sv', '<cmd>TWValues<cr>', desc = 'Show tailwind CSS values' },
    },
    opts = {
      border = 'rounded', -- Valid window border style,
      show_unknown_classes = true, -- Shows the unknown classes popup
    },
  },
  { 'nyngwang/NeoZoom.lua', enabled = false, event = 'VeryLazy' },
  { 'matbme/JABS.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  -- { 'ghillb/cybu.nvim', event = { 'BufRead', 'BufNewFile' } },
  { 'nacro90/numb.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  {
    'winston0410/range-highlight.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = 'winston0410/cmd-parser.nvim',
  },
  { 'petertriho/nvim-scrollbar', event = { 'BufReadPost', 'BufNewFile' } },
  { 'TaDaa/vimade', event = 'VimEnter' },
  {
    'kevinhwang91/nvim-hlslens',
    event = { 'VimEnter' },
    init = function()
      -- cannot use my utility, as the value of IncSearch needs to be retrieved dynamically
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = function()
          local reversed = require('utils.core').getHighlightValue('IncSearch', 'bg')
          vim.api.nvim_set_hl(0, 'HLSearchReversed', { fg = reversed })
        end,
      })
    end,
  },
  { 'Bekaboo/deadcolumn.nvim', event = { 'VimEnter' } },
  -- treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = true,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'JoosepAlviste/nvim-ts-context-commentstring',
        lazy = true,
        opts = {
          enable_autocmd = false,
        },
      },
      'RRethy/nvim-treesitter-endwise',
      'theHamsta/nvim-treesitter-pairs',
      'RRethy/nvim-treesitter-textsubjects',
      'HiPhish/nvim-ts-rainbow2',
      'jbyuki/tree-sitter-ntangle',
      { 'sustech-data/wildfire.nvim', enabled = false },
      'nvim-lua/plenary.nvim',
      { 'ThePrimeagen/refactoring.nvim', dependencies = { { 'nvim-lua/plenary.nvim' } } },
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/playground',
      {
        'nvim-treesitter/nvim-treesitter-context',
        keys = {
          {
            '<leader>otc',
            function()
              local Util = require('utils.inject')
              local tsc = require('treesitter-context')
              tsc.toggle()
              if Util.inject.get_upvalue(tsc.toggle, 'enabled') then
                vim.notify('Enabled Treesitter Context', vim.lsp.log_levels.INFO, { title = 'Option' })
              else
                vim.notify('Disabled Treesitter Context', vim.lsp.log_levels.WARN, { title = 'Option' })
              end
            end,
            desc = 'Toggle Treesitter Context',
          },
        },
      },
      'windwp/nvim-ts-autotag',
      { 'ziontee113/query-secretary', keys = { '<leader><BS>' } },
      { 'ckolkey/ts-node-action', dependencies = { 'none-ls.nvim' } },
    },
  },
  { 'stevearc/aerial.nvim', event = { 'VeryLazy' }, dependencies = { 'nvim-treesitter' } },
  -- motion
  { 'rainbowhxch/accelerated-jk.nvim', enabled = false, event = 'VeryLazy' },
  { 'abecodes/tabout.nvim', event = { 'InsertEnter' } },
  { 'roobert/tabtree.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'Weissle/easy-action' },
  {
    'gbprod/stay-in-place.nvim',
    config = function()
      local stayinplace = require('stay-in-place')
      stayinplace.setup({
        set_keymaps = false,
        preserve_visual_selection = true,
      })
      -- vim.keymap.set('n', '>', stayinplace.shift_right, { noremap = true, expr = true, noremap = true })
      -- vim.keymap.set('n', '<', stayinplace.shift_left, { noremap = true, expr = true, noremap = true })
      vim.keymap.set('n', '=', stayinplace.filter, { noremap = true, expr = true })
      vim.keymap.set('n', '>>', stayinplace.shift_right_line, { noremap = true })
      vim.keymap.set('n', '<<', stayinplace.shift_left_line, { noremap = true })
      vim.keymap.set('n', '==', stayinplace.filter_line, { noremap = true })
      vim.keymap.set('x', '>', stayinplace.shift_right_visual, { noremap = true })
      vim.keymap.set('x', '<', stayinplace.shift_left_visual, { noremap = true })
      vim.keymap.set('x', '=', stayinplace.filter_visual, { noremap = true })
    end,
  },
  {
    'cbochs/portal.nvim',
    -- Optional dependencies
    dependencies = {
      'cbochs/grapple.nvim',
      'ThePrimeagen/harpoon',
      -- require("portal").setup({
      --     ---@type "debug" | "info" | "warn" | "error"
      --     log_level = "warn",
      --
      --     ---The base filter applied to every search.
      --     ---@type Portal.SearchPredicate | nil
      --     filter = nil,
      --
      --     ---The maximum number of results for any search.
      --     ---@type integer | nil
      --     max_results = nil,
      --
      --     ---The maximum number of items that can be searched.
      --     ---@type integer
      --     lookback = 100,
      --
      --     ---An ordered list of keys for labelling portals.
      --     ---Labels will be applied in order, or to match slotted results.
      --     ---@type string[]
      --     labels = { "j", "k", "h", "l" },
      --
      --     ---Select the first portal when there is only one result.
      --     select_first = false,
      --
      --     ---Keys used for exiting portal selection. Disable with [{key}] = false
      --     ---to `false`.
      --     ---@type table<string, boolean>
      --     escape = {
      --         ["<esc>"] = true,
      --     },
      --
      --     ---The raw window options used for the portal window
      --     window_options = {
      --         relative = "cursor",
      --         width = 80,
      --         height = 3,
      --         col = 2,
      --         focusable = false,
      --         border = "single",
      --         noautocmd = true,
      --     },
      -- })
    },
  },
  {
    'smoka7/multicursors.nvim',
    enabled = false,
    event = 'VeryLazy',
    dependencies = {
      'nvimtools/hydra.nvim',
    },
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      {
        mode = { 'v', 'n' },
        '<Leader>M',
        '<cmd>MCstart<cr>',
        desc = 'Create a selection for selected text or word under the cursor',
      },
    },
  },
  { 'anuvyklack/animation.nvim', dependencies = 'anuvyklack/middleclass' },
  {
    'psliwka/vim-smoothie',
    commit = '10fd0aa',
    init = function()
      vim.g.smoothie_enabled = 1
      vim.g.smoothie_no_default_mappings = 1
      vim.g.smoothie_experimental_mappings = 0
      vim.g.smoothie_update_interval = 20 -- 20
      vim.g.smoothie_speed_constant_factor = 6 -- 10
      vim.g.smoothie_speed_linear_factor = 8 -- 10
      vim.g.smoothie_speed_exponentiation_factor = 0.9 -- 0.9
      vim.g.redraw_at_finish = 1
      -- vim.g.smoothie_minimum_speed = 0.6
      vim.g.smoothie_break_on_reverse = 1
    end,
  }, -- f2aaab1
  -- movement highlighters
  -- https://github.com/tzachar/local-highlight.nvim
  -- https://github.com/jjshoots/betterf.nvim/tree/main
  {
    'smoka7/hop.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    -- stylua: ignore
    keys = {
      { "<leader>/", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "<leader>?", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",         mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<M-S>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
  },
  -- cursor
  { 'romainl/vim-cool', event = { 'BufReadPost', 'BufNewFile' } },
  { 'edluffy/specs.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'gen740/SmoothCursor.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'echasnovski/mini.animate', event = 'VeryLazy' },
  -- { 'otavioschwanck/cool-substitute.nvim' },
  -- matching
  { 'andymass/vim-matchup', lazy = false },
  -- pairs
  {
    'echasnovski/mini.pairs',
    event = 'VeryLazy',
    enable = false,
    keys = {
      {
        '<leader>otp',
        function()
          local Util = require('lazy.core.util')
          vim.g.minipairs_disable = not vim.g.minipairs_disable
          if vim.g.minipairs_disable then
            Util.warn('Disabled auto pairs', { title = 'Option' })
          else
            Util.info('Enabled auto pairs', { title = 'Option' })
          end
        end,
        desc = 'Toggle auto pairs',
      },
    },
  },
  -- { 'windwp/nvim-autopairs', event = 'InsertEnter', enabled = false, dependencies = { 'nvim-cmp' } },
  {
    'altermo/ultimate-autopair.nvim',
    event = { 'InsertEnter' },
    -- branch = 'v0.6',
    branch = 'development',
  },
  { 'gbprod/substitute.nvim', event = { 'VeryLazy' } },
  -- textobjects
  { 'echasnovski/mini.ai', event = { 'VeryLazy' } },
  { 'chrisgrieser/nvim-various-textobjs', event = { 'VeryLazy' } },
  -- split/join
  { 'echasnovski/mini.splitjoin', event = { 'VeryLazy' } },
  {
    'Wansmer/treesj',
    dir = '~/git/treesj',
    event = { 'VeryLazy' },
    dependencies = { 'nvim-treesitter' },
  },
  -- surround
  { 'echasnovski/mini.surround', event = { 'VeryLazy' } },
  -- traversal/swapping
  { 'mizlan/iswap.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'ziontee113/SelectEase', event = 'VeryLazy' },
  {
    'chrisgrieser/nvim-spider',
    event = 'VeryLazy',
    commit = 'e0eeac5480704cc3fdd5bdadd4901ca5409d7838',
  },
  { 'echasnovski/mini.move', event = 'VeryLazy' },
  -- alignment
  { 'echasnovski/mini.align', event = 'VeryLazy' },
  {
    'dhruvasagar/vim-table-mode',
    event = 'VeryLazy',
    ft = { 'markdown', 'pandoc', 'vimwiki' },
  },
  { 'echasnovski/mini.doc', version = false, event = 'VeryLazy' },
  { 'echasnovski/mini.bracketed', event = 'VeryLazy' },
  {
    'jkramer/vim-checkbox',
    event = 'VeryLazy',
    ft = { 'markdown', 'pandoc', 'vimwiki' },
  },
  -- formatting
  { 'johmsalas/text-case.nvim', event = 'VeryLazy' },
  {
    'echasnovski/mini.comment',
    -- keep this for operator functions (dgc, dgb, cgc)
    version = false,
    event = 'VeryLazy',
    opts = {
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
      },
    },
  },
  { 'numToStr/Comment.nvim', event = 'VeryLazy' },
  { 'andrewferrier/debugprint.nvim', event = 'VeryLazy' },
  -- https://github.com/kr40/nvim-macros
  {
    'ecthelionvi/NeoComposer.nvim',
    event = 'VeryLazy',
    dependencies = { 'kkharji/sqlite.lua', 'telescope.nvim' },
  },
  { 'tpope/vim-repeat', event = 'VeryLazy' },
  {
    'smjonas/live-command.nvim',
    dependencies = { 'tpope/vim-abolish', 'rickhowe/diffchar.vim' },
    event = 'VeryLazy',
  },
  { 'Konfekt/vim-alias', event = 'VeryLazy' },
  --
  -- pickers
  --
  -- https://github.com/axkirillov/easypick.nvim
  -- https://github.com/adoyle-h/telescope-extension-maker.nvim
  -- https://github.com/adoyle-h/ad-telescope-extensions.nvim
  -- https://github.com/otavioschwanck/telescope-alternate.nvim
  -- https://github.com/lpoto/telescope-tasks.nvim
  -- "moevis/smartjump.nvim",
  -- "nvim-telescope/telescope-vimspector",
  -- "benfowler/telescope-luasnip.nvim",
  { 'echasnovski/mini.fuzzy', event = 'VeryLazy' },
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  { 'echasnovski/mini.files', version = false },
  {
    'nvim-neo-tree/neo-tree.nvim',
    lazy = false,
    cmd = { 'Neotree' },
    event = 'VimEnter',
    branch = 'v3.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  },
  {
    'njhoffman/telescope.nvim',
    -- 'nvim-telescope/telescope.nvim',
    dir = '~/git/telescope.nvim',
    cmd = 'Telescope',
    -- opts = { extensions = { gpt = { title = "Gpt Actions", } } },
    -- event = 'VeryLazy',
    dependencies = {
      'HPRIOR/telescope-gpt',
      'ElPiloto/telescope-vimwiki.nvim',
      'LinArcX/telescope-changes.nvim',
      'LinArcX/telescope-command-palette.nvim',
      'LinArcX/telescope-ports.nvim',
      'Zane-/cder.nvim',
      'Zane-/howdoi.nvim',
      'benfowler/telescope-luasnip.nvim',
      'camgraff/telescope-tmux.nvim',
      'cljoly/telescope-repo.nvim',
      'crispgm/telescope-heading.nvim',
      'dhruvmanila/telescope-bookmarks.nvim',
      'elianiva/telescope-npm.nvim',
      'frenchtoasters/telescope-kubectl.nvim',
      'nvim-web-devicons',
      'lpoto/telescope-docker.nvim',
      'molecule-man/telescope-menufacture',
      'smartpde/telescope-recent-files',
      'ghassan0/telescope-glyph.nvim',
      'Marskey/telescope-sg',
      'danielvolchek/tailiscope.nvim',
      'nat-418/telescope-color-names.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'piersolenski/telescope-import.nvim',
      'nvim-telescope/telescope-dap.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-ghq.nvim',
      'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-hop.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
      'nvim-telescope/telescope-media-files.nvim',
      'nvim-telescope/telescope-node-modules.nvim',
      'nvim-telescope/telescope-rg.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-z.nvim',
      'paopaol/telescope-git-diffs.nvim',
      'ptethng/telescope-makefile',
      'rlch/github-notifications.nvim',
      'sbulav/telescope-terraform.nvim',
      'doctorfree/cheatsheet.nvim',
      'tamago324/telescope-openbrowser.nvim',
      'tsakirist/telescope-lazy.nvim',
      {
        'prochri/telescope-all-recent.nvim',
        dependencies = { 'kkharji/sqlite.lua', 'telescope-ui-select.nvim', 'dressing.nvim' },
      },
      { 'chip/telescope-code-fence.nvim', build = 'luarocks --local install lunamark' },
      { 'danielfalk/smart-open.nvim', dependencies = { 'kkharji/sqlite.lua' } },
      { 'nvim-telescope/telescope-smart-history.nvim', dependencies = { 'kkharji/sqlite.lua' } },
      { 'mvaldes14/terraform.nvim', dependencies = { 'plenary.nvim', 'nui.nvim' } },
      { 'kkharji/sqlite.lua', run = 'luarocks install sqlite luv' },
      { 'nvim-telescope/telescope-frecency.nvim', dependencies = { 'kkharji/sqlite.lua' } },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      {
        'gbprod/yanky.nvim',
        -- keys = {
        --   {
        --     '<leader>p',
        --     function()
        --       require('telescope').extensions.yank_history.yank_history({})
        --     end,
        --     desc = 'Open Yank History',
        --   },
        --   { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' }, desc = 'Yank text' },
        --   { 'p', '<Plug>(YankyPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after cursor' },
        --   { 'P', '<Plug>(YankyPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before cursor' },
        --   { 'gp', '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' }, desc = 'Put yanked text after selection' },
        --   { 'gP', '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' }, desc = 'Put yanked text before selection' },
        --   { '<c-p>', '<Plug>(YankyPreviousEntry)', desc = 'Select previous entry through yank history' },
        --   { '<c-n>', '<Plug>(YankyNextEntry)', desc = 'Select next entry through yank history' },
        --   { ']p', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
        --   { '[p', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
        --   { ']P', '<Plug>(YankyPutIndentAfterLinewise)', desc = 'Put indented after cursor (linewise)' },
        --   { '[P', '<Plug>(YankyPutIndentBeforeLinewise)', desc = 'Put indented before cursor (linewise)' },
        --   { '>p', '<Plug>(YankyPutIndentAfterShiftRight)', desc = 'Put and indent right' },
        --   { '<p', '<Plug>(YankyPutIndentAfterShiftLeft)', desc = 'Put and indent left' },
        --   { '>P', '<Plug>(YankyPutIndentBeforeShiftRight)', desc = 'Put before and indent right' },
        --   { '<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', desc = 'Put before and indent left' },
        --   { '=p', '<Plug>(YankyPutAfterFilter)', desc = 'Put after applying a filter' },
        --   { '=P', '<Plug>(YankyPutBeforeFilter)', desc = 'Put before applying a filter' },
        -- },
      },
      { 'GustavoKatel/telescope-asynctasks.nvim', dependencies = { 'skywind3000/asynctasks.vim' } },
      -- { "rmagatti/session-lens", dependencies = "rmagatti/auto-session" },
      { 'PhilippFeO/telescope-filelinks.nvim' },
      { 'octarect/telescope-menu.nvim' },
      {
        'paopaol/telescope-git-diffs.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
      },
      {
        'luckasRanarison/nvim-devdocs',
        enabled = false,
        dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-treesitter/nvim-treesitter',
        },
        -- run = 'DevdocsFetch',
        opts = {
          dir_path = vim.fn.stdpath('data') .. '/devdocs', -- installation directory
          telescope = {}, -- passed to the telescope picker
          telescope_alt = {}, -- when searching globally without preview
          float_win = { -- passed to nvim_open_win(), see :h api-floatwin
            relative = 'editor',
            height = 25,
            width = 100,
            border = 'rounded',
          },
          wrap = false, -- text wrap
          ensure_installed = {}, -- get automatically installed
          -- DevdocsFetch: Fetch DevDocs metadata.
          -- DevdocsInstall: Install documentation, 0-n args.
          -- DevdocsUninstall: Uninstall documentation, 0-n args.
          -- DevdocsOpen: Open documentation in a normal buffer, 0 or 1 arg.
          -- DevdocsOpenFloat: Open documentation in a floating window, 0 or 1 arg.
          -- DevdocsUpdate: Update documentation, 1-n args.
          -- DevdocsUpdateAll: Update all documentations.
        },
      },
    },
  },
  --
  -- git tools
  --
  -- https://github.com/dlvhdr/gh-blame.nvim
  { 'rbong/vim-flog', cmd = { 'Flog', 'Flogsplit' } },
  { 'ThePrimeagen/git-worktree.nvim', event = 'VeryLazy' },
  { 'napisani/nvim-github-codesearch', cmd = 'GithubSearch', build = 'make' },
  { 'akinsho/git-conflict.nvim', version = '*', lazy = false },
  { 'pwntester/octo.nvim', cmd = 'Octo', dependencies = 'nvim-web-devicons' },
  { 'kdheepak/lazygit.nvim', cmd = 'LazyGit' },
  { 'lewis6991/gitsigns.nvim', event = 'BufReadPost', dependencies = 'nvim-lua/plenary.nvim' },
  { 'rhysd/git-messenger.vim', cmd = 'GitMessenger' },
  {
    'tpope/vim-fugitive',
    init = function()
      vim.g.fugitive_no_maps = 1
    end,
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'Git', 'Ggrep', 'GMove', 'GDelete', 'Gspilt', 'Gstatus', 'Gwrite', 'Gread', 'Gdiffsplit', 'Gedit' },
    dependencies = 'tpope/vim-rhubarb',
  },
  -- https://github.com/sam4llis/nvim-lua-gf
  -- https://github.com/notomo/curstr.nvim/blob/master/doc/curstr.nvim.txt
  -- { 'tpope/vim-apathy' }
  -- tools and integrations
  --
  { 'aserowy/tmux.nvim', event = 'VeryLazy' },
  { 'jbyuki/quickmath.nvim', cmd = 'Quickmath' },
  {
    'jameshiew/nvim-magic',
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim', event = 'VeryLazy' },
  },
  {
    'michaelb/sniprun',
    build = 'bash install.sh',
    cmd = { 'SnipRun', 'SnipInfo' },
  },
  { 'milisims/nvim-luaref', event = 'VeryLazy' },
  { 'windwp/nvim-spectre', cmd = 'Spectre' },
  { 'WaylonWalker/Telegraph.nvim', cmd = 'Telegraph' },
  {
    'bennypowers/nvim-regexplainer',
    cmd = { 'RegexplainerShow', 'RegexplainerToggle' },
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
  },
  -- { 'rmagatti/auto-session', event = 'VimEnter' },
  { 'wakatime/vim-wakatime', enabled = false, event = 'VeryLazy' },
  { 'LunarVim/bigfile.nvim' },
  { 'carlosrocha/chrome-remote.nvim', event = 'VeryLazy' },
  { 'altermo/nxwm', event = 'VeryLazy', enabled = false },
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
  {
    'qpkorr/vim-renamer',
    init = function()
      vim.g.RenamerShowHiddenEnabled = true
    end,
  },
  {
    'chrisbra/unicode.vim',
    cmd = { 'Digraphs', 'UnicodeSearch', 'UnicodeName', 'UnicodeTable', 'DownloadUnicode', 'UnicodeCache' },
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
  { 'LeonHeidelbach/trailblazer.nvim' },
  { 'kelly-lin/ranger.nvim', lazy = true },
  { 'lambdalisue/suda.vim', event = 'VeryLazy' },
  {
    'skywind3000/asynctasks.vim',
    event = 'VeryLazy',
    dependencies = 'skywind3000/asyncrun.vim',
  },
  {
    'aymericbeaumet/vim-symlink',
    event = 'VeryLazy',
    dependencies = 'moll/vim-bbye',
  },
  { 't-troebst/perfanno.nvim', cmd = { 'PerfLoadFlat', 'PerfLoadCallGraph', 'PerfLoadFlameGraph' } },
  {
    'chrisgrieser/nvim-genghis',
    dependencies = { 'stevearc/dressing.nvim', 'nvim-cmp', 'hrsh7th/cmp-omni' },
    keys = {
      -- stylua: ignore start
      -- {"<C-p>", function() require("genghis").copyFilepath() end, desc = " Copy filepath" },
      -- {"<C-n>", function() require("genghis").copyFilename() end, desc = " Copy filename" },
      -- {"<C-r>", function() require("genghis").renameFile() end, desc = " Rename file" },
      { "<leader>fx", function() require("genghis").chmodx() end, desc = " chmod +x" },
      -- {"<C-d>", function() require("genghis").duplicateFile() end, desc = " Duplicate file" },
      -- {"<D-BS>", function() require("genghis").trashFile() end, desc = " Move file to trash" },
      -- {"<D-n>", function() require("genghis").createNewFile() end, desc = " Create new file" },
      -- {"X", function() require("genghis").moveSelectionToNewFile() end, mode = "x", desc = " Selection to new file" },
      -- stylua: ignore end
    },
    cmd = {
      'NewFromSelection',
      'Duplicate',
      'Rename',
      'Trash',
      'Move',
      'CopyFilename',
      'CopyFilepath',
      'Chmodx',
      'New',
    },
  },
  { 'echasnovski/mini.test', lazy = true },
  {
    'gennaro-tedesco/nvim-jqx',
    lazy = true,
    cmd = { 'JqxList', 'JqxQuery' },
  },
  { 'npxbr/glow.nvim', cmd = 'Glow' },
  { 'NTBBloodbath/rest.nvim', cmd = { 'RESTRunLast', 'RESTRun', 'RESTPreview' } },
  { 'dbeniamine/cheat.sh-vim', cmd = 'Cheat' },
  { 'potamides/pantran.nvim', cmd = 'Pantran' },
  { 'sidebar-nvim/sidebar.nvim', cmd = { 'SidebarNvimOpen', 'SidebarNvimToggle' } },
  { 'nvimtools/hydra.nvim', event = 'VeryLazy' }, -- anuvyklack
  { 'NvChad/nvim-colorizer.lua', event = { 'BufReadPost', 'BufNewFile' } },
  {
    'nvim-colortils/colortils.nvim',
    cmd = 'Colortils',
    event = { 'BufReadPost', 'BufNewFile' },
  },
  {
    'kawre/leetcode.nvim',
    build = ':TSUpdate html',
    dependencies = {
      'njhoffman/telescope.nvim',
      'nvim-lua/plenary.nvim', -- required by telescope
      'MunifTanjim/nui.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-notify',
      'nvim-tree/nvim-web-devicons',
    },
    lazy = 'leetcode.nvim' ~= vim.fn.argv()[1],
    opts = {
      arg = 'leetcode.nvim',
    },
  },
  {
    'xeluxee/competitest.nvim',
    cmd = 'CompetiTestRun',
    dependencies = 'MunifTanjim/nui.nvim',
  },
  {
    -- A lua profiler for neovim that is discovered thanks to https://www.reddit.com/r/neovim/comments/xicxox/comment/ip2hprd
    'stevearc/profile.nvim',
    cond = function()
      return vim.env.NVIM_PROFILE ~= nil
    end,
  },
  {
    'sQVe/sort.nvim',
    -- Optional setup for overriding defaults.
    config = function()
      require('sort').setup({
        {
          -- List of delimiters, in descending order of priority, to automatically
          -- sort on.
          delimiters = {
            ',',
            '|',
            ';',
            ':',
            's', -- Space
            't', -- Tab
          },
        },
        -- Input configuration here.
        -- Refer to the configuration section below for options.
      })
      -- vim.cmd([[
      --   nnoremap <silent> go <Cmd>Sort<CR>
      --   vnoremap <silent> go <Esc><Cmd>Sort<CR>
      --   ]])
    end,
  },
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

    'kevinhwang91/nvim-fundo',
    dependencies = 'kevinhwang91/promise-async',
    config = function()
      local default_cfg = {
        -- archives_dir = {
        --   description = [[The directory to store the archives]],
        --   default = vim.fn.stdpath('cache') .. path.separator .. 'fundo',
        -- },
        -- limit_archives_size = {
        --   description = [[Limit the archives directory size, unit is MB(megabyte), elder files will be
        -- removed based on their modified time]],
        --   default = 512,
        -- },
      }
      require('fundo').install()
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
      'powerman/vim-plugin-AnsiEsc',
      'farseer90718/vim-taskwarrior',
      'preservim/tagbar',
    },
  },
  {
    'mthbernardes/codeexplain.nvim',
    cmd = 'CodeExplain',
    build = function()
      -- pip install -r langchain==0.0.177 llama-cpp-python==0.1.48 Pygments==2.15.1 pynvim==0.4.3
      vim.cmd([[silent UpdateRemotePlugins]])
    end,
  },
  {
    'kndndrj/nvim-dbee',
    dependencies = { 'MunifTanjim/nui.nvim' },
    build = function()
      -- Install tries to automatically detect the install method.
      -- if it fails, try calling it with one of these parameters: "curl", "wget", "bitsadmin", "go"
      require('dbee').install()
    end,
  },
  { 'tzachar/highlight-undo.nvim', event = { 'BufEnter', 'BufReadPost', 'BufNewFile' } },
  {
    'kndndrj/nvim-projector',
    event = { 'VeryLazy' },
    dependencies = { 'MunifTanjim/nui.nvim', 'kndndrj/projector-neotest', 'nvim-neotest/neotest' },
  },
  { 'Shatur/neovim-session-manager', dependencies = 'nvim-lua/plenary.nvim' },
  --
  -- filetypes
  --
  { 'AndrewRadev/id3.vim', ft = 'mp3' },
  {
    'susensio/magic-bang.nvim',
    ft = 'sh',
    opts = { automatic = true, command = true, executable = true, default = '/bin/bash' },
  },
  { 'ray-x/go.nvim', dependencies = { 'ray-x/guihua.lua' }, ft = 'go' },

  -- { -- Formatter integration
  --   'stevearc/conform.nvim',
  --   cmd = 'ConformInfo',
  --   config = function()
  --     require('conform.formatters.injected').options.ignore_errors = true
  --     require('conform').setup(formatterConfig)
  --   end,
  --   keys = {
  --     { '<D-s>', formattingFunc, desc = '󰒕 Format & Save', mode = { 'n', 'x' } },
  --   },
  -- },
  -- { -- auto-convert string and f/template string
  --   'chrisgrieser/nvim-puppeteer',
  --   ft = { 'python', 'javascript', 'typescript', 'lua' },
  --   init = function()
  --     vim.g.puppeteer_lua_format_string = true
  --   end,
  --   keys = {
  --     { -- Toggle string formatting in lua
  --       'gtp',
  --       function()
  --         vim.g.puppeteer_lua_format_string = not vim.g.puppeteer_lua_format_string
  --         local status = vim.g.puppeteer_lua_format_string and 'enabled' or 'disabled'
  --         vim.notify('Puppeteer', 'Lua string formatting ' .. status)
  --       end,
  --       ft = 'lua',
  --       desc = '󰅳 lua string formatting',
  --     },
  --   },
  -- },
  {
    'llllvvuu/nvim-js-actions',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        command = 'nnoremap <buffer> gta ' .. ":lua require('nvim-js-actions').js_arrow_fn.toggle()<CR>",
        -- can also do `require('nvim-js-actions/js-arrow-fn').toggle()`
      })
    end,
  },
  {
    'ten3roberts/qf.nvim',
    -- Unlike :cnext and :cprev, :Qnext and :Qprev will not navigate to valid entries which contain file names, as well as wrapping.
    -- :Qsave, :Qload:Qbelow, :Qabove, :Lbelow, Labove, etc will navigate to the next or previous entry relative to the cursor. However, unlike :cabove it will cross buffer boundaries.
  },
  -- https://github.com/Zeioth/markmap.nvim
  {
    'lukas-reineke/headlines.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown', 'pandoc', 'pandoc.markdown', 'markdown.pandoc' },
  },
  { 'elkasztano/nushell-syntax-vim', ft = 'nu', lazy = lz_syn },
  { 'iamcco/markdown-preview.nvim', build = 'cd app && yarn install', cmd = 'MarkdownPreview' },
  { 'vuki656/package-info.nvim', dependencies = 'MunifTanjim/nui.nvim', ft = 'json' },
  { 'serenevoid/kiwi.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'herringtondarkholme/yats.vim', ft = 'typescript', lazy = lz_syn },
  -- https://github.com/AndrewRadev/inline_edit.vim
  { 'AckslD/nvim-FeMaco.lua', ft = { 'markdown', 'pandoc' } },
  { 'njhoffman/vim-liquid', ft = 'liquid', lazy = lz_syn },
  -- { 'moll/vim-node', ft = { 'javascript' }, lazy = lz_syn },
  { 'bfrg/vim-jq', ft = 'jq', lazy = lz_syn },
  -- { 'maxmellon/vim-jsx-pretty', ft = { 'javascript', 'jsx', 'javascriptreact' }, lazy = lz_syn },
  { 'yuezk/vim-js', ft = { 'javascript', 'jsx', 'javascriptreact' }, lazy = lz_syn },
  { 'zdharma-continuum/zinit-vim-syntax', ft = 'zsh', lazy = lz_syn },
  { 'wgwoods/vim-systemd-syntax', ft = 'systemd', lazy = lz_syn },
  { 'aliou/bats.vim', ft = 'bats', lazy = lz_syn },
  { 'alx741/vim-hindent', ft = 'haskell', lazy = lz_syn },
  { 'cakebaker/scss-syntax.vim', ft = 'scss', lazy = lz_syn },
  { 'chr4/nginx.vim', ft = 'nginx', lazy = lz_syn },
  { 'ekalinin/dockerfile.vim', ft = 'dockerfile', lazy = lz_syn },
  { 'elzr/vim-json', ft = 'json', lazy = lz_syn },
  { 'ericpruitt/tmux.vim', ft = 'tmux', lazy = lz_syn },
  { 'euclidianace/betterlua.vim', ft = 'lua', lazy = lz_syn },
  { 'gisphm/vim-gitignore', ft = 'gitignore', lazy = lz_syn },
  { 'glench/vim-jinja2-syntax', ft = 'jinja', lazy = lz_syn },
  { 'gutenye/json5.vim', ft = 'json5', lazy = lz_syn },
  { 'jparise/vim-graphql', ft = 'graphql', lazy = lz_syn },
  { 'kchmck/vim-coffee-script', ft = 'coffee', lazy = lz_syn },
  { 'lifepillar/pgsql.vim', ft = 'pgsql', lazy = lz_syn },
  { 'lnl7/vim-nix', ft = 'nix', lazy = lz_syn },
  { 'neoclide/jsonc.vim', ft = 'jsonc', lazy = lz_syn },
  { 'neovimhaskell/haskell-vim', ft = 'haskell', lazy = lz_syn },
  { 'octol/vim-cpp-enhanced-highlight', ft = 'cpp', lazy = lz_syn },
  { 'pearofducks/ansible-vim', ft = 'ansible', lazy = lz_syn },
  { 'potatoesmaster/i3-vim-syntax', ft = 'i3', lazy = lz_syn },
  { 'rodjek/vim-puppet', ft = 'puppet', lazy = lz_syn },
  { 'stanangeloff/php.vim', ft = 'php', lazy = lz_syn },
  { 'tbastos/vim-lua', ft = 'lua', lazy = lz_syn },
  { 'tikhomirov/vim-glsl', ft = 'glsl', lazy = lz_syn },
  { 'vim-utils/vim-man', ft = 'man', lazy = lz_syn },
  { 'vimwiki/vimwiki', ft = { 'markdown', 'vimwiki' }, lazy = lz_syn },
  {
    'mtdl9/vim-log-highlighting',
    ft = { 'log', 'LOG' },
    event = { 'BufReadPost', 'BufNewFile' },
    lazy = lz_syn,
  },
  {
    'hashivim/vim-terraform',
    ft = 'terraform',
    event = { 'BufReadPost', 'BufNewFile' },
    lazy = lz_syn,
  },
  { 'raimon49/requirements.txt.vim', event = 'VeryLazy', lazy = lz_syn },
  { 'godlygeek/tabular', event = 'VeryLazy', lazy = lz_syn },
  {
    'preservim/vim-markdown',
    commit = 'df4be86',
    dependencies = { 'godlygeek/tabular' },
  },
}

utils.apply_configs(plugins)
return plugins
