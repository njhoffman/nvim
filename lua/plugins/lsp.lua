local utils = require('utils.lazy')

-- https://github.com/onsails/diaglist.nvim

local plugins = {
  {
    'neovim/nvim-lspconfig',
    event = { 'VimEnter' },
    dependencies = {
      { 'williamboman/mason.nvim', cmd = 'Mason' },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'weilbith/nvim-code-action-menu',
      'RRethy/vim-illuminate',
      'b0o/schemastore.nvim', -- for jsonls
      'WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
      'KostkaBrukowa/definition-or-references.nvim',
      'smjonas/inc-rename.nvim',
      'nanotee/sqls.nvim',
      'tami5/lspsaga.nvim',
      'rmagatti/goto-preview',
      'kosayoda/nvim-lightbulb',
      'mickael-menu/zk-nvim',
      { 'folke/neodev.nvim', dependencies = { 'williamboman/mason-lspconfig.nvim', 'williamboman/mason.nvim' } },
      { 'folke/trouble.nvim', cmd = { 'TroubleToggle', 'Trouble' } },
      {
        'folke/lsp-colors.nvim',
        opts = { Error = '#db4b4b', Warn = '#e0af68', Info = '#0db9d7', Hint = '#10B981' },
      },
      { 'jbyuki/ntangle-lsp.nvim', dependencies = { 'jbyuki/ntangle-ts.nvim' } },
    },
    config = function()
      vim.import('lsp.capabilities')
      vim.import('lsp.servers')
      vim.import('lsp.config')
    end,
  },
  {
    'SmiteshP/nvim-navbuddy',
    dir = '~/git/nvim-navbuddy',
    event = { 'BufReadPost', 'BufNewFile', 'LspAttach' },
    cmd = { 'Navbuddy' },
    dependencies = { 'neovim/nvim-lspconfig', 'SmiteshP/nvim-navic', 'MunifTanjim/nui.nvim' },
  },
  { 'ray-x/go.nvim', dependencies = { 'ray-x/guihua.lua' }, ft = 'go' },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'ThePrimeagen/refactoring.nvim',
      'mason.nvim',
      'ckolkey/ts-node-action',
    },
  },
  { 'mfussenegger/nvim-lint', event = { 'BufReadPre', 'BufNewFile' } },
  {
    'stevearc/aerial.nvim',
    event = { 'BufReadPre', 'BufNewFile', 'LspAttach' },
    cmd = { 'AerialToggle', 'AerialNext', 'AerialGo', 'AerialOpen', 'AerialPrev', 'AerialOpenAll' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TodoTrouble', 'TodoTelescope' },
  },
}

utils.apply_configs(plugins)

return plugins

-- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },
