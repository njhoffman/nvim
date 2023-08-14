local utils = require('utils.lazy')

vim.g.barbar_auto_setup = false

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
  { 'rcarriga/nvim-notify', lazy = false },
  {
    'nvim-neo-tree/neo-tree.nvim',
    -- no lazy loading to enable netrw override
    lazy = false,
    cmd = { 'NeoTreeFocusToggle', 'NeoTreeShowToggle' },
    event = 'VimEnter',
    branch = 'v2.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  },
  -- { 'freddiehaddad/feline.nvim', branch = 'main', event = 'VimEnter', lazy = false, },
  { 'famiu/bufdelete.nvim' },
  {
    'utilyre/barbecue.nvim',
    -- dir = '~/git/barbecue.nvim',
    name = 'barbecue',
    event = { 'BufNewFile', 'BufReadPost' },
    cmd = 'Barbecue',
    dependencies = {
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'romgrk/barbar.nvim',
    enabled = false,
    event = 'VimEnter',
    cmd = { 'BufferPrev', 'BufferNext', 'BufferDelete' },
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local opts = {
        insert_at_start = true,
        auto_hide = true,
      }
      -- require('barbar').setup(opts)
    end,
  },
  { 'folke/which-key.nvim', event = 'VeryLazy' },
  {
    'folke/noice.nvim',
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    },
    event = 'VeryLazy',
  },
}

utils.apply_configs(plugins)

return plugins
