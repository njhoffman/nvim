local utils = require('utils.lazy')

-- https://github.com/onsails/diaglist.nvim

local plugins = {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile', 'LspAttach' },
    dependencies = {
      { 'williamboman/mason.nvim', cmd = 'Mason' },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'weilbith/nvim-code-action-menu',
      {
        'adoyle-h/lsp-toggle.nvim',
        config = function()
          require('lsp-toggle').setup({
            create_cmds = true, -- Whether to create user commands
            telescope = true, -- Whether to load telescope extensions
          })
        end,
      },
      'SmiteshP/nvim-navic',
      'aznhe21/actions-preview.nvim',
      'RRethy/vim-illuminate',
      -- 'zeioth/garbage-day.nvim',
      'b0o/schemastore.nvim', -- for jsonls
      {
        'piersolenski/wtf.nvim',
        dependencies = { 'MunifTanjim/nui.nvim' },
        keys = {
          {
            'gw',
            mode = { 'n', 'x' },
            function()
              require('wtf').ai()
            end,
            desc = 'Debug diagnostic with AI',
          },
          {
            mode = { 'n' },
            'gW',
            function()
              require('wtf').search()
            end,
            desc = 'Search diagnostic with Google',
          },
        },
      },
      'KostkaBrukowa/definition-or-references.nvim',
      {
        'smjonas/inc-rename.nvim',
        config = function()
          require('inc_rename').setup()
        end,
      },
      'nanotee/sqls.nvim',
      'tami5/lspsaga.nvim',

      {
        'Exafunction/codeium.nvim',
        config = function()
          local cfg = {}
          require('codeium').setup(cfg)
        end,
      },
      -- { 'Wansmer/symbol-usage.nvim', event = 'LspAttach' },
      'rmagatti/goto-preview',
      'kosayoda/nvim-lightbulb',
      'mickael-menu/zk-nvim',
      'dnlhc/glance.nvim',
      -- ft = {'javascript','javascriptreact','javascript.jsx','typescript','typescriptreact','typescript.tsx'}
      { 'jose-elias-alvarez/typescript.nvim' },
      {
        'pmizio/typescript-tools.nvim',
        enabled = false,
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
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
      vim.import('lsp.lines')
      vim.import('configs.definition-or-references')
    end,
  },
  {
    'james1236/backseat.nvim',
    cmd = { 'Backseat', 'BackseatAsk', 'BackseatClear' },
  },
  {
    'SmiteshP/nvim-navbuddy',
    dir = '~/git/nvim-navbuddy',
    event = { 'LspAttach' },
    cmd = { 'Navbuddy' },
    dependencies = { 'neovim/nvim-lspconfig', 'SmiteshP/nvim-navic', 'MunifTanjim/nui.nvim' },
  },
  {
    'nvimtools/none-ls.nvim',
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
    dependencies = { 'nvim-web-devicons' },
  },
  -- https://github.com/mfussenegger/nvim-jdtls
  {
    'folke/todo-comments.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TodoTrouble', 'TodoTelescope' },
  },
}

utils.apply_configs(plugins)

return plugins
