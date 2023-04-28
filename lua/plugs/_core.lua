local utils = require('utils.lazy')
local plugins = {
  { 'folke/lazy.nvim', lazy = false, version = '*' },
  -- colorscheme components should load first
  {
    'rktjmp/lush.nvim',
    lazy = false,
    config = function()
      vim.cmd('colorscheme nord-nick')
    end,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    -- no lazy loading to enable netrw override
    lazy = false,
    cmd = { 'NeoTreeFocusToggle', 'NeoTreeShowToggle' },
    event = 'VimEnter',
    branch = 'v2.x',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
  },
  { 'freddiehaddad/feline.nvim', event = 'VimEnter' },
  {
    'romgrk/barbar.nvim',
    event = 'VimEnter',
    cmd = { 'BufferPrev', 'BufferNext' },
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = {
      auto_hide = true,
    },
  },
  { 'rcarriga/nvim-notify', event = 'VimEnter' },
  { 'folke/which-key.nvim', event = 'VimEnter' },
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
