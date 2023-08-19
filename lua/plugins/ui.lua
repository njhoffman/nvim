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

local plugins = {
  { 'nvim-tree/nvim-web-devicons', dependencies = { 'DaikyXendo/nvim-material-icon' }, lazy = true },
  {
    'tummetott/reticle.nvim',
    lazy = false,
    event = { 'BufReadPre', 'BufNewFile' },
    -- reticle messes up with Neo-tree cursorline in search mode
    opts = { always = { cursorline = { 'neo-tree' } } },
  },
  { 'lukas-reineke/indent-blankline.nvim', event = { 'BufReadPre', 'BufNewFile' } },
  { 'Tyler-Barham/floating-help.nvim', cmd = 'FloatHelp' },
  { 'echasnovski/mini.clue', event = { 'VeryLazy' } },
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
            'sidekick',
            'NeoTree',
            'NvimTree',
            'Trouble',
          }
          local bt_exclude = { 'terminal', 'prompt', 'nofile' }
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
  {
    'tversteeg/registers.nvim',
    cmd = 'Registers',
    keys = {
      { '"', mode = { 'n', 'v' } },
      { '<C-R>', mode = 'i' },
    },
  },
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
  { 'nyngwang/NeoZoom.lua', enabled = false, event = 'VeryLazy' },
  {
    '3rd/image.nvim',
    enabled = false,
    event = 'VeryLazy',
    dependencies = { { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' } },
  },
  { 'matbme/JABS.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'ghillb/cybu.nvim', event = { 'BufRead', 'BufNewFile' } },
  { 'nacro90/numb.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'ivyl/vim-bling', event = { 'BufReadPost', 'BufNewFile' } },
  { 'romainl/vim-cool', event = { 'BufReadPost', 'BufNewFile' } },
  { 'edluffy/specs.nvim', event = { 'BufReadPost', 'BufNewFile' } },
  { 'petertriho/nvim-scrollbar', event = { 'BufReadPost', 'BufNewFile' } },
  { 'TaDaa/vimade', event = 'VimEnter' },
  { 'kevinhwang91/nvim-hlslens', event = { 'VimEnter' } },
  { 'Bekaboo/deadcolumn.nvim', event = { 'VimEnter' } },
  { 'stevearc/dressing.nvim', dependencies = 'MunifTanjim/nui.nvim', lazy = true },
  { 'phaazon/hop.nvim', branch = 'v2', event = { 'BufReadPost', 'BufNewFile' } },
  { 'MunifTanjim/nui.nvim', event = 'VeryLazy' },
}

utils.apply_configs(plugins)
return plugins
