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
    opts = {
      char = '│',
      filetype_exclude = ft_exclude,
      show_trailing_blankline_indent = false,
      show_current_context = false,
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
  -- {
  --   'RRethy/vim-illuminate',
  --   event = { 'BufReadPost', 'BufNewFile' },
  --   dependencies = { 'neovim/nvim-lspconfig' },
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
