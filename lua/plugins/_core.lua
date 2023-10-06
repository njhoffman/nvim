local utils = require('utils.lazy')

local plugins = {
  { 'folke/lazy.nvim', lazy = false },
  -- colorscheme components should load first

  {
    'rktjmp/lush.nvim',
    priority = 1000,
    lazy = false,
    keys = {
      {
        '<Leader>cs',
        function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ColorSchemeLoad' })
          require('telescope.builtin').colorscheme()
        end,
        noremap = true,
      },
    },
    config = function()
      vim.cmd('colorscheme nord-nick')
    end,
  },
  -- { 'freddiehaddad/feline.nvim', branch = 'main', event = 'VimEnter', lazy = false, },
  { 'famiu/bufdelete.nvim' },
  {
    'nvim-tree/nvim-web-devicons',
    dependencies = {
      'DaikyXendo/nvim-material-icon',
    },
  },
  {
    'utilyre/barbecue.nvim',
    -- dir = '~/git/barbecue.nvim',
    name = 'barbecue',
    event = 'VeryLazy',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-web-devicons',
    },
  },
  { 'rcarriga/nvim-notify', lazy = false },
  { 'folke/noice.nvim', event = 'VeryLazy' },
  { 'folke/which-key.nvim', event = 'VeryLazy' },
}

utils.apply_configs(plugins)

return plugins
