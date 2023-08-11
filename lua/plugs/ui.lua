local utils = require('utils.lazy')

local function get_key_cmd(mode, lhs)
  local keys = vim.api.nvim_get_keymap(mode)
  local rhs, opt = '', {}
  for _, key in ipairs(keys) do
    if key.lhs == lhs then
      rhs = key.callback or key.rhs
      opt = key
    end
  end
  return rhs, opt
end

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
  'sidekick',
  'NeoTree',
  'NvimTree',
  'Trouble',
}
local bt_exclude = { 'terminal', 'prompt', 'nofile' }

local plugins = {
  {
    'nvim-tree/nvim-web-devicons',
    dependencies = { 'DaikyXendo/nvim-material-icon' },
    config = function()
      require('nvim-web-devicons').setup({
        override = require('nvim-material-icon').get_icons(),
      })
    end,
  },
  {
    'tummetott/reticle.nvim',
    lazy = false,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      always = {
        cursorline = {
          'neo-tree', -- reticle messes up with Neo-tree cursorline in search mode
        },
      },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
  },
  {
    'echasnovski/mini.clue',
    version = false,
    config = function()
      local miniclue = require('mini.clue')
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = 'n', keys = '<Leader>' },
          { mode = 'x', keys = '<Leader>' },

          -- Built-in completion
          { mode = 'i', keys = '<C-x>' },

          -- `g` key
          { mode = 'n', keys = 'g' },
          { mode = 'x', keys = 'g' },

          -- Marks
          { mode = 'n', keys = "'" },
          { mode = 'n', keys = '`' },
          { mode = 'x', keys = "'" },
          { mode = 'x', keys = '`' },

          -- Registers
          { mode = 'n', keys = '"' },
          { mode = 'x', keys = '"' },
          { mode = 'i', keys = '<C-r>' },
          { mode = 'c', keys = '<C-r>' },

          -- Window commands
          { mode = 'n', keys = '<C-w>' },

          -- `z` key
          { mode = 'n', keys = 'z' },
          { mode = 'x', keys = 'z' },
        },

        clues = {
          -- Enhance this by adding descriptions for <Leader> mapping groups
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
        -- Clue window settings
        window = {
          -- Floating window config
          config = {},

          -- Delay before showing clue window
          delay = 300,

          -- Keys to scroll inside the clue window
          scroll_down = '<C-f>',
          scroll_up = '<C-b>',
        },
      })
    end,
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
          if vim.tbl_contains(ft_exclude, ft) or vim.tbl_contains(bt_exclude, bt) then
            vim.b.miniindentscope_disable = true
          end
        end,
      })
    end,
  },
  { 'echasnovski/mini.trailspace', event = 'VeryLazy' },
  { 'echasnovski/mini.animate', event = 'VeryLazy' },
  {
    'sindrets/diffview.nvim',
    cmd = { 'Diffview', 'DiffviewLog', 'DiffviewOpen', 'DiffviewToggleFiles', 'DiffviewFileHistory' },
  },
  { 'm00qek/baleia.nvim', event = 'VeryLazy' },
  { 'folke/zen-mode.nvim', cmd = 'ZenMode', keys = { '<CR>' } },
  { 'tversteeg/registers.nvim', event = 'VimEnter', cmd = 'Registers' },
  { 'folke/twilight.nvim', cmd = { 'Twilight', 'TwilightEnable' } },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    cmd = { 'UfoEnable', 'UfoAttach', 'UfoEnableFold' },
    event = { 'BufReadPost', 'InsertEnter' },
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
  {
    'matbme/JABS.nvim',
    config = function()
      local default_cfg = {
        -- Options for the main window
        position = { 'center', 'top' }, -- position = {'<position_x>', '<position_y>'} | <position_x> left, center, right,
        --                                             <position_y> top, center, bottom
        -- Default {'right', 'bottom'}

        relative = 'editor', -- win, editor, cursor. Default win
        clip_popup_size = false, -- clips the popup size to the win (or editor) size. Default true

        width = 80, -- default 50
        height = 20, -- default 10
        border = 'single', -- none, single, double, rounded, solid, shadow, (or an array or chars). Default shadow

        offset = { -- window position offset
          top = 2, -- default 0
          bottom = 2, -- default 0
          left = 2, -- default 0
          right = 2, -- default 0
        },
        sort_mru = true, -- Sort buffers by most recently used (true or false). Default false
        split_filename = true, -- Split filename into separate components for name and path. Default false
        split_filename_path_width = 20, -- If split_filename is true, how wide the column for the path is supposed to be, Default 0 (don't show path)

        -- Options for preview window
        preview_position = 'left', -- top, bottom, left, right. Default top
        preview = {
          width = 40, -- default 70
          height = 60, -- default 30
          border = 'single', -- none, single, double, rounded, solid, shadow, (or an array or chars). Default double
        },
        -- Default highlights (must be a valid :highlight)
        highlight = {
          current = 'Title', -- default StatusLine
          hidden = 'StatusLineNC', -- default ModeMsg
          split = 'WarningMsg', -- default StatusLine
          alternate = 'StatusLine', -- default WarningMsg
        },
        -- Default symbols
        symbols = {
          current = 'C', -- default 
          split = 'S', -- default 
          alternate = 'A', -- default 
          hidden = 'H', -- default ﬘
          locked = 'L', -- default 
          ro = 'R', -- default 
          edited = 'E', -- default 
          terminal = 'T', -- default 
          default_file = 'D', -- Filetype icon if not present in nvim-web-devicons. Default 
          terminal_symbol = '>_', -- Filetype icon for a terminal split. Default 
        },

        -- Keymaps
        keymap = {
          close = '<c-d>', -- Close buffer. Default D
          jump = '<space>', -- Jump to buffer. Default <cr>
          h_split = 'h', -- Horizontally split buffer. Default s
          v_split = 'v', -- Vertically split buffer. Default v
          preview = 'p', -- Open buffer preview. Default P
        },

        -- Whether to use nvim-web-devicons next to filenames
        use_devicons = false, -- true or false. Default true
      }
      require('jabs').setup({ border = 'rounded', use_devicos = true })
    end,
  },

  {
    'ghillb/cybu.nvim',
  },
  { 'nacro90/numb.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'ivyl/vim-bling', event = { 'BufReadPost', 'BufNewFile' } },
  { 'romainl/vim-cool', event = { 'BufReadPost', 'BufNewFile' } },
  { 'edluffy/specs.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'petertriho/nvim-scrollbar', event = { 'BufReadPost', 'BufNewFile' } },
  -- {
  --   'nyngwang/NeoZoom.lua',
  --   config = function()
  -- require('neo-zoom').setup({
  --   callback = function()
  --     vim.dbglog('MY CALLBACK')
  --   end,
  --   popup = {
  --     enabled = true,
  --     exclude_filetypes = {},
  --     exclude_buftypes = {},
  --   },
  --   exclude_buftypes = { 'terminal' },
  --   exclude_filetypes = { 'lspinfo', 'mason', 'lazy', 'fzf', 'qf', 'noice' },
  --   winopts = {
  --     offset = {
  --       -- top = 0,
  --       -- left = 0.17,
  --       width = 0.90,
  --       height = 0.90,
  --     },
  --     border = 'rounded',
  --   },
  --   presets = {
  --     -- {
  --     --   filetypes = { '*' },
  --     --   callback = function()
  --     --     vim.dbglog('DOING PRESETS')
  --     --     vim.api.nvim_win_set_option(0, 'number', false)
  --     --     vim.api.nvim_win_set_option(0, 'relativenumber', false)
  --     --     vim.api.nvim_win_set_option(0, 'signcolumn', 'no')
  --     --   end,
  --     -- },
  --     {
  --       filetypes = { 'dapui_.*', 'dap-repl' },
  --       winopts = {
  --         offset = { top = 0.02, left = 0.26, width = 0.74, height = 0.25 },
  --       },
  --     },
  --     {
  --       filetypes = { 'markdown' },
  --       callbacks = {
  --         function()
  --           vim.wo.wrap = true
  --         end,
  --       },
  --     },
  --   },
  -- })

  -- vim.keymap.set('n', '<CR>', function()
  --   vim.cmd('NeoZoomToggle')
  -- end, { silent = true, nowait = true })

  -- vim.api.nvim_create_autocmd({ 'WinEnter' }, {
  --   callback = function(ev)
  --     local zoom_book = require('neo-zoom').zoom_book
  --     -- local winid = vim.api.nvim_get_current_win()
  --     -- vim.api.nvim_buf_set_option(ev.buf, 'buftype', 'neozoom')
  --     -- local bufnr = vim.api.nvim_win_get_buf(winid)
  --     -- vim.api.nvim_buf_set_option(bufnr, 'buftype', 'neozoom')
  --     -- vim.api.nvim_win_set_option(winid, 'indentline', false)
  --     -- vim.api.nvim_win_set_option(0, 'winhighlight', 'Normal:PmenuSel,NormalNC:PmenuSbar')
  --     -- vim.api.nvim_buf_set_option(bufnr, 'filetype', 'neozoom')
  --
  --     if require('neo-zoom').is_neo_zoom_float() then
  --       for z, _ in pairs(zoom_book) do
  --         vim.wo[z].winbl = 0
  --       end
  --     else
  --       -- local win_ns = vim.api.nvim_create_namespace('neozoom')
  --       for z, _ in pairs(zoom_book) do
  --         -- vim.api.nvim_win_set_hl_ns(z, win_ns)
  --         -- vim.api.nvim_set_hl(win_ns, 'Normal', { bg = '#101826' })
  --         -- vim.api.nvim_win_set_option(z, 'winhl', 'Normal:Float')
  --         vim.wo[z].winbl = 20
  --       end
  --     end
  -- end,
  -- })
  --   end,
  -- },
  { 'TaDaa/vimade', event = 'VimEnter' },
  { 'kevinhwang91/nvim-hlslens', event = { 'VimEnter' }, lazy = false },
  { 'Bekaboo/deadcolumn.nvim', event = { 'VimEnter' }, lazy = false },
  {
    'stevearc/dressing.nvim',
    dependencies = 'MunifTanjim/nui.nvim',
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require('lazy').load({ plugins = { 'dressing.nvim' } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        win_options = {
          winblend = 15,
        },
        select = {
          backend = { 'nui', 'telescope' },
          -- telescope = require('telescope.themes').get_ivy({...})
        },
      },
    },
  },
  {
    'phaazon/hop.nvim',
    branch = 'v2',
    event = { 'BufReadPost', 'BufNewFile' },
  },
  -- { 'RRethy/vim-hexokinase', event = 'VeryLazy', build = 'make hexokinase' },
  { 'MunifTanjim/nui.nvim', event = 'VeryLazy' },
}

utils.apply_configs(plugins)
return plugins

--
-- { "edluffy/hologram.nvim", cond = os.getenv("KITTY_WINDOW_ID") ~= nil
-- ["nvim-highlight-colors"] = { "brenoprata10/nvim-highlight-color" },
-- ["startup.nvim"] = {
--   use = {"startup-nvim/startup.nvim", requires = {"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"}}
-- },
-- ["icon-picker.nvim"] = { "ziontee113/icon-picker.nvim"}
-- ["vim-visual-multi"] = { "mg979/vim-visual-multi" },
-- ["wilder.nvim"] = {
--   "gelguy/wilder.nvim",
--   rocks = { "luarocks-fetch-gitrec", "pcre2" },
--   requires = { "romgrk/fzy-lua-native", "nvim-tree/nvim-web-devicons" }
-- }
-- ["codewindow.nvim"] = { "gorbit99/codewindow.nvim" },
-- https://github.com/anuvyklack/windows.nvim
-- ["yank-history"] = {"yazgoo/yank-history"},
-- https://github.com/gbprod/yanky.nvim
