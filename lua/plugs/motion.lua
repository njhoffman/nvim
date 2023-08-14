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
  {
    'ziontee113/neo-minimap',
    dependencies = { 'nvim-treesitter' },
    event = 'VeryLazy',
    config = function()
      local nm = require('neo-minimap')

      nm.setup_defaults({
        -- height_toggle = { 12, 25 },
        height_toggle = { 20, 25 },
        hl_group = 'DiagnosticWarn',
      })

      -- Rust

      nm.set({ 'zi', 'zo' }, '*.rs', {
        events = { 'BufEnter' },
        query = {
          [[
                        ;; query
                        (((attribute_item) @attr (function_item) @cap (#vim-match? @attr "test")))
                    ]],
          [[
                        ;; query
                        (enum_item (type_identifier) @cap)
                        (trait_item (type_identifier) @cap)
                        (struct_item (type_identifier) @cap)
                        ;; (impl_item (type_identifier) @cap)
                        ((impl_item) @cap)
                        (function_item (identifier) @cap)
                        (mod_item (identifier) @cap)
                        (macro_definition (identifier) @cap)
                        ]],
          2,
        },
        regex = {},
        search_patterns = {
          { 'impl', '<C-j>', true },
          { 'impl', '<C-k>', false },
          { 'mod', '<C-l>', false },
        },
        height_toggle = { 20, 25 },
      })

      -- Latex

      nm.set({ 'zo', 'zu' }, '*.tex', {
        events = { 'BufEnter' },
        query = {},
        regex = {
          { [[\\section]], [[\\subsection]], [[\\subsubsection]] },
          { [[\\begin{.*}]] },
        },
      })

      -- Lua
      nm.set({ 'zi', 'zo', 'zu' }, '*.lua', {
        events = { 'BufEnter', 'BufReadPost' },

        query = {
          [[
                        ;; query
                        ;; ((function_declaration name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
                        ;; ((function_call name: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
                        ;; ((dot_index_expression field: ((identifier) @name (#eq? @name "{cursorword}"))) @cap)
                        ((function_declaration) @cap)
                        ((assignment_statement(expression_list((function_definition) @cap))))
                        ((identifier) @cap (#any-of? @cap "describe" "it"))
                    ]],
          1,
          [[
                        ;; query
                        ((function_declaration) @cap)
                        ((assignment_statement(expression_list((function_definition) @cap))))
                        ((field (identifier) @cap) (#eq? @cap "keymaps"))
                    ]],
          [[
                        ;; query
                        ((for_statement) @cap)
                        ((function_declaration) @cap)
                        ((assignment_statement(expression_list((function_definition) @cap))))
                        ((function_call (identifier)) @cap (#vim-match? @cap "^__*" ))
                        ((function_call (dot_index_expression) @field (#eq? @field "vim.keymap.set")) @cap)
                    ]],
          [[
                        ;; query
                        ((for_statement) @cap)
                        ((function_declaration) @cap)
                        ((assignment_statement(expression_list((function_definition) @cap))))
                    ]],
        },

        regex = {
          {},
          { [[^\s*---*\s\+\w\+]], [[--\s*=]] },
          { [[^\s*---*\s\+\w\+]], [[--\s*=]] },
          {},
        },

        search_patterns = {
          { 'function', '<C-j>', true },
          { 'function', '<C-k>', false },
          { 'keymap', '<A-j>', true },
          { 'keymap', '<A-k>', false },
        },

        -- auto_jump = false,
        -- open_win_opts = { border = "double" },
        win_opts = { scrolloff = 1 },

        disable_indentaion = true,
      })

      -- Typescript React
      nm.set('zi', { 'typescriptreact', 'javascriptreact' }, {
        query = [[
                    ;; query
                    ((function_declaration) @cap)
                    ((arrow_function) @cap)
                    ((identifier) @cap (#vim-match? @cap "^use.*"))
                ]],
      })
    end,
  },
  { 'echasnovski/mini.nvim', version = false },
  {
    'ziontee113/query-secretary',
    dependencies = { 'nvim-treesitter' },
    keys = { '<leader><BS>' },
    config = function()
      require('query-secretary').setup({
        open_win_opts = {
          row = 0,
          col = 9999,
          width = 50,
          height = 15,
        },

        -- other options you can customize
        buf_set_opts = {
          tabstop = 2,
          softtabstop = 2,
          shiftwidth = 2,
        },

        capture_group_names = { 'cap', 'second', 'third' }, -- when press "c"
        predicates = { 'eq', 'any-of', 'contains', 'match', 'lua-match' }, -- when press "p"
        visual_hl_group = 'Visual', -- when moving cursor around

        -- here are the default keymaps
        keymaps = {
          close = { 'q', 'Esc' },
          next_predicate = { 'p' },
          previous_predicate = { 'P' },
          remove_predicate = { 'd' },
          toggle_field_name = { 'f' },
          yank_query = { 'y' },
          next_capture_group = { 'c' },
          previous_capture_group = { 'C' },
        },
      })

      vim.keymap.set('n', '<leader><BS>', function()
        require('query-secretary').query_window_initiate()
      end, {})
    end,
  },
  {
    'gbprod/substitute.nvim',
    config = function()
      local defaults = {
        on_substitute = nil,
        yank_substituted_text = false,
        highlight_substituted_text = {
          enabled = true,
          timer = 500,
        },
        range = {
          prefix = 's',
          prompt_current_text = false,
          confirm = false,
          complete_word = false,
          motion1 = false,
          motion2 = false,
          suffix = '',
        },
        exchange = {
          motion = false,
          use_esc_to_cancel = true,
        },
      }

      -- replace:  Siw replaces the current word with "+" register
      -- exchange: Sxiw (move to next work) Sxiw (or .)
      require('substitute').setup({ range = { prefix = 'S' } })

      vim.keymap.set('n', 'S', require('substitute').operator, { noremap = true })
      vim.keymap.set('n', 'SS', require('substitute').line, { noremap = true })
      -- vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
      vim.keymap.set('x', 'S', require('substitute').visual, { noremap = true })

      vim.keymap.set('n', '<leader>S', function()
        require('substitute.range').operator({ prefix = 'S' })
      end, { noremap = true })

      vim.keymap.set('n', 'Sx', require('substitute.exchange').operator, { noremap = true })
      vim.keymap.set('n', 'Sxx', require('substitute.exchange').line, { noremap = true })
      vim.keymap.set('x', 'X', require('substitute.exchange').visual, { noremap = true })
      vim.keymap.set('n', 'Sxc', require('substitute.exchange').cancel, { noremap = true })

      -- vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
      -- vim.keymap.set("n", "ss", require('substitute').line, { noremap = true })
      -- vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
      -- vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })

      -- vim.keymap.set("n", "<leader>s", require('substitute.range').operator, { noremap = true })
      -- vim.keymap.set("x", "<leader>s", require('substitute.range').visual, { noremap = true })
      -- vim.keymap.set("n", "<leader>ss", require('substitute.range').word, { noremap = true })

      -- exchange operator
      -- vim.keymap.set("n", "sx", require('substitute.exchange').operator, { noremap = true })
      -- vim.keymap.set("n", "sxx", require('substitute.exchange').line, { noremap = true })
      -- vim.keymap.set("x", "X", require('substitute.exchange').visual, { noremap = true })
      -- vim.keymap.set("n", "sxc", require('substitute.exchange').cancel, { noremap = true })
    end,
  },
  {
    'ckolkey/ts-node-action',
    event = 'BufReadPost',
    dependencies = {
      'nvim-treesitter',
      'null-ls.nvim',
      -- name = 'more_actions',
      -- method = { require('null-ls').methods.CODE_ACTION },
      -- filetypes = { '_all' },
      -- generator = {
      --   fn = require('ts-node-action').available_actions,
      -- },
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
  { 'ziontee113/SelectEase', lazy = false },
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
