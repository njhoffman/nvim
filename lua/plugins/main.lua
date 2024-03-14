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
    '00sapo/visual.nvim',
    enabled = false,
    dependencies = { 'nvim-treesitter', 'nvim-treesitter-textobjects' }, -- this is needed so that visual.nvim is loaded *afterwards* Treesitter
    event = 'VeryLazy',
  },
  {
    'rasulomaroff/reactive.nvim',
    enabled = true,
    lazy = false,
  },
  -- https://www.reddit.com/r/neovim/comments/1aupy8c/a_simple_journaling_system_built_with_mind_and/
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
  { 'stevearc/stickybuf.nvim', event = 'VeryLazy' },
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
      never = {
        cursorline = { 'qf', 'noice', 'navbuddy' },
        cursorcolumn = { 'qf', 'noice', 'navbuddy' },
      },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  { 'Tyler-Barham/floating-help.nvim', cmd = 'FloatHelp' },
  { 'monaqa/dial.nvim', event = { 'VeryLazy' }, dependencies = { 'nvim-lua/plenary.nvim' } },
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
    cmd = {
      'Diffview',
      'DiffviewLog',
      'DiffviewOpen',
      'DiffviewToggleFiles',
      'DiffviewFileHistory',
    },
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
  -- https://github.com/miversen33/sunglasses.nvim
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
    cmd = { 'TSTextobjectSelect', 'TSTextobjectGotoPreviousStart' },
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
                vim.notify(
                  'Enabled Treesitter Context',
                  vim.lsp.log_levels.INFO,
                  { title = 'Option' }
                )
              else
                vim.notify(
                  'Disabled Treesitter Context',
                  vim.lsp.log_levels.WARN,
                  { title = 'Option' }
                )
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
  { 'echasnovski/mini.ai', event = { 'VeryLazy' } },
  {
    'chrisgrieser/nvim-various-textobjs',
    event = { 'VeryLazy' },
    -- opts = { useDefaultKeymaps = false },
  },

  -- stylua: ignore
  --     -- {
  --     -- 			{
  --     -- 				"<leader>H",
  --     -- 				function() vim.cmd.TSTextobjectPeekDefinitionCode("@function.outer") end,
  --     -- 				desc = " Hover Peek Function",
  --     -- 			},
  --     -- 			{
  --     -- 				"q",
  --     -- 				function() vim.cmd.TSTextobjectSelect("@comment.outer") end,
  --     -- 				mode = "o", -- only operator-pending to not conflict with commenting selection
  --     -- 				desc = "󱡔  single comment textobj",
  --     -- 			},
  --     -- 			{
  --     -- 				"dq",
  --     -- 				function()
  --     -- 					local cursor = vim.api.nvim_win_get_cursor(0)
  --     -- 					vim.cmd.TSTextobjectSelect("@comment.outer")
  --     -- 					u.normal("d")
  --     -- 					vim.api.nvim_win_set_cursor(0, cursor)
  --     -- 				end,
  --     -- 				desc = " Sticky Delete Comment",
  --     -- 			},
  --     -- 			{
  --     -- 				"cq",
  --     -- 				function()
  --     -- 					vim.cmd.TSTextobjectSelect("@comment.outer")
  --     -- 					u.normal("d")
  --     -- 					local comStr = vim.bo.commentstring:format("")
  --     -- 					local line = vim.api.nvim_get_current_line():gsub("%s+$", "")
  --     -- 					vim.api.nvim_set_current_line(line .. " " .. comStr)
  --     -- 					vim.cmd.startinsert { bang = true }
  --     -- 				end,
  --     -- 				desc = " Change Comment",
  --     -- 			},
  --     -- 			{
  --     -- 				"<C-j>",
  --     -- 				"<cmd>TSTextobjectGotoNextStart @function.outer<CR>zv",
  --     -- 				desc = " Goto Next Function",
  --     -- 			},
  --     -- 			{
  --     -- 				"<C-k>",
  --     -- 				"<cmd>TSTextobjectGotoPreviousStart @function.outer<CR>zv",
  --     -- 				desc = " Goto Previous Function",
  --     -- 			},
  --     -- 			-----------------------------------------------------------------------
  --     -- 			-- INFO outer key textobj defined via various textobjs
  --     -- 			-- stylua: ignore start
  --     -- 			{ "ik", "<cmd>TSTextobjectSelect @assignment.lhs<CR>", mode = { "x", "o" }, desc = "󱡔 inner key" },
  --     -- 			{ "a<CR>", "<cmd>TSTextobjectSelect @return.outer<CR>", mode = { "x", "o" }, desc = "󱡔 outer return" },
  --     -- 			{ "i<CR>", "<cmd>TSTextobjectSelect @return.inner<CR>", mode = { "x", "o" }, desc = "󱡔 inner return" },
  --     -- 			{ "a/", "<cmd>TSTextobjectSelect @regex.outer<CR>", mode = { "x", "o" }, desc = "󱡔 outer regex" },
  --     -- 			{ "i/", "<cmd>TSTextobjectSelect @regex.inner<CR>", mode = { "x", "o" }, desc = "󱡔 inner regex" },
  --     -- 			{ "aa", "<cmd>TSTextobjectSelect @parameter.outer<CR>", mode = { "x", "o" }, desc = "󱡔 outer parameter" },
  --     -- 			{ "ia", "<cmd>TSTextobjectSelect @parameter.inner<CR>", mode = { "x", "o" }, desc = "󱡔 inner parameter" },
  --     -- 			{ "iu", "<cmd>TSTextobjectSelect @loop.inner<CR>", mode = { "x", "o" }, desc = "󱡔 inner loop" },
  --     -- 			{ "au", "<cmd>TSTextobjectSelect @loop.outer<CR>", mode = { "x", "o" }, desc = "󱡔 outer loop" },
  --     -- 			{ "af", "<cmd>TSTextobjectSelect @function.outer<CR>", mode = {"x","o"},desc = "󱡔 outer function" },
  --     -- 			{ "if", "<cmd>TSTextobjectSelect @function.inner<CR>", mode = {"x","o"},desc = "󱡔 inner function" },
  --     -- 			{ "ao", "<cmd>TSTextobjectSelect @conditional.outer<CR>", mode = {"x","o"},desc = "󱡔 outer cond." },
  --     -- 			{ "io", "<cmd>TSTextobjectSelect @conditional.inner<CR>", mode = {"x","o"},desc = "󱡔 inner cond." },
  --     -- 			{ "al", "<cmd>TSTextobjectSelect @call.outer<CR>", mode = {"x","o"},desc = "󱡔 outer call" },
  --     -- 			{ "il", "<cmd>TSTextobjectSelect @call.inner<CR>", mode = {"x","o"},desc = "󱡔 inner call" },
  --     -- 			-- stylua: ignore end
  --     -- 		},
  --     { "<Space>", "<cmd>lua require('various-textobjs').subword('inner')<CR>", mode = "o", desc = "󱡔 inner subword" },
  --     { "a<Space>", "<cmd>lua require('various-textobjs').subword('outer')<CR>", mode = { "o", "x" }, desc = "󱡔 outer subword" },

  --     { "iv", "<cmd>lua require('various-textobjs').value('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner value" },
  --     { "av", "<cmd>lua require('various-textobjs').value('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer value" },
  --     -- INFO `ik` defined via treesitter to exclude `local` and `let`;
  --     { "ak", "<cmd>lua require('various-textobjs').key('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer key" },

  --     { "pp", "<cmd>lua require('various-textobjs').lastChange()<CR>", mode = "o", desc = "󱡔 last paste" },
  --     { "gg", "<cmd>lua require('various-textobjs').entireBuffer()<CR>", mode = { "x", "o" }, desc = "󱡔 entire buffer" },

  --     { "n", "<cmd>lua require('various-textobjs').nearEoL()<CR>", mode = "o", desc = "󱡔 near EoL" },
  --     { "m", "<cmd>lua require('various-textobjs').toNextClosingBracket()<CR>", mode = { "o", "x" }, desc = "󱡔 to next closing bracket" },
  --     { "w", "<cmd>lua require('various-textobjs').toNextQuotationMark()<CR>", mode = "o", desc = "󱡔 to next quote", nowait = true },
  --     { "b", "<cmd>lua require('various-textobjs').anyBracket('inner')<CR>", mode = "o", desc = "󱡔 inner anyBracket" },
  --     { "B", "<cmd>lua require('various-textobjs').anyBracket('outer')<CR>", mode = "o", desc = "󱡔 outer anyBracket" },
  --     { "k", "<cmd>lua require('various-textobjs').anyQuote('inner')<CR>", mode = "o", desc = "󱡔 inner anyQuote" },
  --     { "K", "<cmd>lua require('various-textobjs').anyQuote('outer')<CR>", mode = "o", desc = "󱡔 outer anyQuote" },
  --     { "iR", "<cmd>lua require('various-textobjs').doubleSquareBrackets('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner wikilink" },
  --     { "aR", "<cmd>lua require('various-textobjs').doubleSquareBrackets('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer wikilink" },

  --     -- INFO not setting in visual mode, to keep visual block mode replace
  --     { "rv", "<cmd>lua require('various-textobjs').restOfWindow()<CR>", mode = "o", desc = "󱡔 rest of viewport" },
  --     { "rp", "<cmd>lua require('various-textobjs').restOfParagraph()<CR>", mode = "o", desc = "󱡔 rest of paragraph" },
  --     { "ri", "<cmd>lua require('various-textobjs').restOfIndentation()<CR>", mode = "o", desc = "󱡔 rest of indentation" },
  --     { "rg", "G", mode = "o", desc = "󱡔 rest of buffer" },

  --     { "ge", "<cmd>lua require('various-textobjs').diagnostic()<CR>", mode = { "x", "o" }, desc = "󱡔 diagnostic" },
  --     { "L", "<cmd>lua require('various-textobjs').url()<CR>", mode = "o", desc = "󱡔 link" },
  --     { "o", "<cmd>lua require('various-textobjs').column()<CR>", mode = "o", desc = "󱡔 column" },

  --     { "in", "<cmd>lua require('various-textobjs').notebookCell('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner notebookCell" },
  --     { "an", "<cmd>lua require('various-textobjs').notebookCell('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer notebookCell" },

  --     { "ii", "<cmd>lua require('various-textobjs').indentation('inner', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner indent" },
  --     { "ai", "<cmd>lua require('various-textobjs').indentation('outer', 'outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer indent" },
  --     { "aj", "<cmd>lua require('various-textobjs').indentation('outer', 'inner')<CR>", mode = { "x", "o" }, desc = "󱡔 top-border indent" },
  --     { "ig", "<cmd>lua require('various-textobjs').greedyOuterIndentation('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner greedy indent" },
  --     { "ag", "<cmd>lua require('various-textobjs').greedyOuterIndentation('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer greedy indent" },

  --     { "i.", "<cmd>lua require('various-textobjs').chainMember('inner')<CR>", mode = { "x", "o" }, desc = "󱡔 inner indent" },
  --     { "a.", "<cmd>lua require('various-textobjs').chainMember('outer')<CR>", mode = { "x", "o" }, desc = "󱡔 outer indent" },

  --     { "u", "<cmd>lua require('various-textobjs').multiCommentedLines()<CR>", mode = "o", desc = "󱡔 multi-line-comment" },
  --     { "guu", "guu" }, -- do not use `u` as textobject when using `guu`

  --       -- python
  --       { "iy", "<cmd>lua require('various-textobjs').pyTripleQuotes('inner')<CR>", ft = "python", mode = { "x", "o" }, desc = "󱡔 inner tripleQuotes" },
  --       { "ay", "<cmd>lua require('various-textobjs').pyTripleQuotes('outer')<CR>", ft = "python", mode = { "x", "o" }, desc = "󱡔 outer tripleQuotes" },

  --       -- markdown
  --       { "iE", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('inner')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 inner CodeBlock" },
  --       { "aE", "<cmd>lua require('various-textobjs').mdFencedCodeBlock('outer')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 outer CodeBlock" },
  --       { "il", "<cmd>lua require('various-textobjs').mdlink('inner')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 inner md link" },
  --       { "al", "<cmd>lua require('various-textobjs').mdlink('outer')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 outer md link" },
  --       { "if", "<cmd>lua require('various-textobjs').mdEmphasis('inner')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 inner md formatting" },
  --         { "af", "<cmd>lua require('various-textobjs').mdEmphasis('outer')<CR>", mode = { "x", "o" }, ft = "markdown", desc = "󱡔 outer md formatting" },

  --         -- css
  --         { "is", "<cmd>lua require('various-textobjs').cssSelector('inner')<CR>", mode = { "x", "o" }, ft = "css", desc = "󱡔 inner selector" },
  --         { "as", "<cmd>lua require('various-textobjs').cssSelector('outer')<CR>", mode = { "x", "o" }, ft = "css", desc = "󱡔 outer selector" },
  --         { "i#", "<cmd>lua require('various-textobjs').cssColor('inner')<CR>", mode = { "x", "o" }, ft = "css", desc = "󱡔 inner color" },
  --         { "a#", "<cmd>lua require('various-textobjs').cssColor('outer')<CR>", mode = { "x", "o" }, ft = "css", desc = "󱡔 outer color" },

  --         -- shell
  --         { "pi", "<cmd>lua require('various-textobjs').shellPipe('inner')<CR>", mode = "o", ft = "sh", desc = "󱡔 inner pipe" },
  --       -- stylua: ignore end

  --       { -- delete surrounding indentation
  --         "dsi",
  --         function()
  --           require("various-textobjs").indentation("outer", "outer")
  --           local indentationFound = vim.fn.mode():find("V")
  --           if not indentationFound then return end

  --           u.normal("<") -- dedent indentation
  --           local endBorderLn = vim.api.nvim_buf_get_mark(0, ">")[1]
  --           local startBorderLn = vim.api.nvim_buf_get_mark(0, "<")[1]
  --         vim.cmd(tostring(endBorderLn) .. " delete") -- delete end first so line index is not shifted
  --         vim.cmd(tostring(startBorderLn) .. " delete")
  --       end,
  --       desc = " Delete surrounding indent",
  --     },
  --     { -- yank surrounding inner indentation
  --       "ysii", -- `ysi` would conflict with `ysib` and other textobs
  --       function()
  --       -- identify start- and end-border
  --       local startPos = vim.api.nvim_win_get_cursor(0)
  --       require("various-textobjs").indentation("outer", "outer")
  --       local indentationFound = vim.fn.mode():find("V")
  --       if not indentationFound then return end
  --       u.normal("V") -- leave visual mode so <> marks are set
  --       vim.api.nvim_win_set_cursor(0, startPos) -- restore (= sticky)

  --       -- copy them into the + register
  --       local startLn = vim.api.nvim_buf_get_mark(0, "<")[1] - 1
  --       local endLn = vim.api.nvim_buf_get_mark(0, ">")[1] - 1
  --       local startLine = vim.api.nvim_buf_get_lines(0, startLn, startLn + 1, false)[1]
  --       local endLine = vim.api.nvim_buf_get_lines(0, endLn, endLn + 1, false)[1]
  --       vim.fn.setreg("+", startLine .. "\n" .. endLine .. "\n")

  --       -- highlight yanked text
  --       local ns = vim.api.nvim_create_namespace("ysi")
  --       vim.highlight.range(0, ns, "IncSearch", { startLn, 0 }, { startLn, -1 })
  --       vim.highlight.range(0, ns, "IncSearch", { endLn, 0 }, { endLn, -1 })
  --       vim.defer_fn(function() vim.api.nvim_buf_clear_namespace(0, ns, 0, -1) end, 1000)
  --     end,
  --     desc = "󰅍 Yank surrounding indent",
  --   },
  --   { -- indent last paste
  --     "P",
  --     function()
  --       require("various-textobjs").lastChange()
  --       local changeFound = vim.fn.mode():find("v")
  --       if changeFound then u.normal(">") end
  --     end,
  --     desc = " Indent Last Paste",
  --   },
  --   { -- open URL (forward seeking)
  --     "gx",
  --     function()
  --       require("various-textobjs").url()
  --       local foundURL = vim.fn.mode():find("v")
  --       if foundURL then
  --         u.normal('"zy')
  --         local url = vim.fn.getreg("z")
  --         vim.fn.system { "open", url }
  --       end
  --     end,
  --     desc = "󰌹 Smart URL Opener",
  --   },
  -- },
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
  },
  -- cursor
  { 'romainl/vim-cool', event = { 'BufReadPost', 'BufNewFile' } },
  { 'edluffy/specs.nvim', enabled = false, event = { 'BufReadPost', 'BufNewFile' } },
  { 'gen740/SmoothCursor.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'echasnovski/mini.animate', event = 'VeryLazy' },
  -- { 'otavioschwanck/cool-substitute.nvim' },
  -- matching

  {
    'andymass/vim-matchup',
    lazy = false,
    init = function()
      vim.g.matchup_text_obj_linewise_operators = { 'c', 'd', 'y' }
      vim.g.loaded_matchit = 1
      vim.g.disable_virtual_text = 1
      -- disable virtual text highlighting virtual end of blocks for langs without markers

      vim.g.matchup_enabled = 1 -- enable/disable plugin entirely
      vim.g.matchup_matchparen_enabled = 1
      vim.g.matchup_motion_enabled = 1
      vim.g.matchup_text_obj_enabled = 1
      vim.g.matchup_surround_enabled = 1 -- adds ds% and cs%

      vim.g.matchup_delim_noskips = 1 -- matching between strings and constants (0 always, 1 no words, 2 never)
      vim.g.matchup_delim_stopline = 2000 -- 1500  (# of lines to search for motions/text objects)

      vim.g.matchup_matchparen_pumvisible = 0
      -- 1 (show matching even when pum-completion is visible)
      -- vim.g.matchup_matchparen_offscreen = { method = 'popup' } -- method = popup, status, status_minimal

      vim.g.matchup_motion_override_Npercent = 0 -- enable vim default {count}%
      vim.g.matchup_matchparen_timeout = 150 -- 300
      vim.g.matchup_matchparen_insert_timeout = 30 -- 60
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_deferred_fade_time = 0 -- 0 (ms match will disappear after no movement)
      vim.g.matchup_matchparen_deferred_show_delay = 50 -- 50 (time between cursor stop moving and match check)
      vim.g.matchup_matchparen_deferred_hide_delay = 700 -- 700 (hide stale matches after n seconds of cursor movement)
      vim.g.matchup_matchparen_hi_surround_always = 1
      vim.g.matchup_matchparen_stopline = 2000 -- (# of lines to search for highlighting only)
    end,
  },
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
    -- keep this for operator  (dgc, dgb, cgc) and visual functions
    event = 'VeryLazy',
    opts = {
      -- mappings = {
      --   comment_line = 'gcc',
      --   comment_visual = 'gc',
      --   comment = 'gc',
      --   textobject = 'gc',
      -- },
      mappings = {
        --   -- Toggle comment (like `gcip` - comment inner paragraph) for both Normal and Visual modes
        comment = 'gc', -- gc
        comment_line = '', -- gcc
        comment_visual = 'gc',
        --   -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        --   -- Works also in Visual mode if mapping differs from `comment_visual`
        text_object = 'gc',
      },
      options = {
        custom_commentstring = function()
          return require('ts_context_commentstring.internal').calculate_commentstring()
            or vim.bo.commentstring
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
    -- branch = 'remote',
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

  {
    'ray-x/forgit.nvim',
    config = function()
      require('forgit').setup({
        debug = false, -- enable debug logging default path is ~/.cache/nvim/forgit.log
        diff_pager = 'delta', -- you can use `diff`,         `diff-so-fancy`
        diff_cmd = '', -- you can use `DiffviewOpen`, `Gvdiffsplit` or `!git diff`, auto if not set
        fugitive = false, -- git fugitive installed?
        abbreviate = false, -- abvreviate some of the commands e.g. gps -> git push
        git_alias = true, -- git command extensions see: Git command alias
        show_result = 'quickfix', -- show cmd result in quickfix or notify
        shell_mode = true, -- set to true if you using zsh/bash and can not run forgit commands
        height_ratio = 0.6, -- height ratio of floating window when split horizontally
        cmds_list = {}, -- additional commands to show in Forgit command list
        width_ratio = 0.6, -- width ratio of floating window when split vertically
      })
    end,
  },

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
    cmd = {
      'Git',
      'Ggrep',
      'GMove',
      'GDelete',
      'Gspilt',
      'Gstatus',
      'Gwrite',
      'Gread',
      'Gdiffsplit',
      'Gedit',
    },
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
  -- https://github.com/miversen33/netman.nvim
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
    cmd = {
      'BuildImage',
      'AttachToContainer',
      'StartImage',
      'ComposeUp',
      'ComposeDown',
      'ComposeDestroy',
    },
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
  -- https://github.com/krady21/compiler-explorer.nvim
  {
    't-troebst/perfanno.nvim',
    cmd = { 'PerfLoadFlat', 'PerfLoadCallGraph', 'PerfLoadFlameGraph' },
  },
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
  -- https://www.reddit.com/r/neovim/comments/1awiy1t/neovim_timetracking_system_using_timewarrior/
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
        command = 'nnoremap <buffer> gta '
          .. ":lua require('nvim-js-actions').js_arrow_fn.toggle()<CR>",
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
