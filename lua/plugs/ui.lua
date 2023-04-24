local utils = require('utils.lazy')

local plugins = {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      char = '│',
      filetype_exclude = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy' },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPre', 'BufNewFile' },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'help', 'alpha', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason' },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  { 'echasnovski/mini.trailspace', event = 'VeryLazy' },
  { 'echasnovski/mini.animate', event = 'VeryLazy' },
  {
    'tummetott/reticle.nvim',
    event = 'VeryLazy',
    opts = {
      always = {
        cursorline = {
          'neo-tree', -- reticle messes up with Neo-tree cursorline in search mode
        },
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    cmd = { 'Diffview', 'DiffviewLog', 'DiffviewOpen', 'DiffviewToggleFiles', 'DiffviewFileHistory' },
  },
  { 'm00qek/baleia.nvim' },
  { 'folke/zen-mode.nvim', cmd = 'ZenMode' },
  { 'tversteeg/registers.nvim', event = 'VimEnter', cmd = 'Registers' },
  { 'folke/twilight.nvim', cmd = { 'Twilight', 'TwilightEnable' } },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    cmd = { 'UfoEnable', 'UfoAttach', 'UfoEnableFold' },
    event = { 'BufReadPost', 'InsertEnter' },
  },
  { 'nacro90/numb.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'ivyl/vim-bling', event = { 'BufReadPost', 'BufNewFile' } },
  { 'romainl/vim-cool', event = { 'BufReadPost', 'BufNewFile' } },
  { 'edluffy/specs.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'petertriho/nvim-scrollbar', event = { 'BufReadPost', 'BufNewFile' } },
  { 'RRethy/vim-illuminate', event = { 'BufReadPost', 'BufNewFile' }, dependencies = { 'neovim/nvim-lspconfig' } },
  { 'TaDaa/vimade', event = { 'BufReadPost', 'BufNewFile' } },
  { 'kevinhwang91/nvim-hlslens', event = { 'VimEnter' } },
  { 'Bekaboo/deadcolumn.nvim', event = { 'VimEnter' }, lazy = false },
  -- {
  --   "m4xshen/smartcolumn.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   opts = {
  --     colorcolumn = 120,
  --     disabled_filetypes = { "help", "text", "markdown" },
  --     custom_colorcolumn = {},
  --     limit_to_window = false,
  --     limit_to_line = false,
  --   },
  -- },
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
  { 'RRethy/vim-hexokinase', event = 'VeryLazy', build = 'make hexokinase' },
  { 'MunifTanjim/nui.nvim', event = 'VeryLazy' },
}

utils.apply_configs(plugins)
return plugins

--
-- { "edluffy/hologram.nvim", cond = os.getenv("KITTY_WINDOW_ID") ~= nil
-- ["nvim-highlight-colors"] = { "brenoprata10/nvim-highlight-color" },
-- ["vim-hexokinase"]     = { "RRethy/vim-hexokinase", run = "make hexokinase" },
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
