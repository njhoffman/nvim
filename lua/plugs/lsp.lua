local utils = require('utils.lazy')

local plugins = {
  { dir = '~/git/fidget.nvim', event = 'LspAttach' },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim', cmd = 'Mason' },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'weilbith/nvim-code-action-menu',
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
      {
        'folke/trouble.nvim',
        cmd = { 'TroubleToggle', 'Trouble' },
        -- vim.api.nvim_set_keymap( "n", "<leader>xx",
        --   "<cmd>Trouble<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
        --   { silent = true, noremap = true })
        -- vim.api.nvim_set_keymap( "n", "<leader>xw",
        --   "<cmd>Trouble lsp_workspace_diagnostics<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
        --   { silent = true, noremap = true })
        -- vim.api.nvim_set_keymap( "n", "<leader>xd",
        --   "<cmd>Trouble lsp_document_diagnostics<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
        --   { silent = true, noremap = true })
        -- vim.api.nvim_set_keymap( "n", "<leader>xl",
        --   "<cmd>Trouble loclist<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
        --   { silent = true, noremap = true })
        -- vim.api.nvim_set_keymap( "n", "<leader>xq",
        --   "<cmd>Trouble quickfix<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
        --   { silent = true, noremap = true })
        -- vim.api.nvim_set_keymap( "n", "<leader>xr",
        --   "<cmd>Trouble lsp_references<cr><bar><cmd>VimadeBufDisable<cr><bar><cmd>wincmd p<cr>",
        --   { silent = true, noremap = true })
        --
      },
      {
        'folke/lsp-colors.nvim',
        opts = { Error = '#db4b4b', Warn = '#e0af68', Info = '#0db9d7', Hint = '#10B981' },
      },
      { 'jbyuki/ntangle-lsp.nvim', dependencies = { 'jbyuki/ntangle-ts.nvim' } },
      {
        'hrsh7th/cmp-nvim-lsp',
        cond = function()
          return require('lazy.core.config').plugins['nvim-cmp'] ~= nil
        end,
      },
    },
    config = function()
      vim.import('lsp.capabilities')
      vim.import('lsp.servers')
      vim.import('lsp.config')
    end,
  },
  -- https://github.com/onsails/diaglist.nvim
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'neovim/nvim-lspconfig' },
  },
  {
    -- 'utilyre/barbecue.nvim',
    dir = '~/git/barbecue.nvim',
    name = 'barbecue',
    version = '*',
    lazy = false,
    event = 'VeryLazy',
    cmd = 'Barbecue',
    dependencies = {
      'neovim/nvim-lspconfig',
      'SmiteshP/nvim-navic',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'ray-x/go.nvim',
    dependencies = { 'ray-x/guihua.lua' },
    ft = 'go',
    event = 'LspAttach',
    -- event = { "BufReadPost", "BufNewFile" },
  },
  {
    'SmiteshP/nvim-navbuddy',
    dir = '~/git/nvim-navbuddy',
    lazy = false,
    cmd = { 'Navbuddy' },
    dependencies = { 'neovim/nvim-lspconfig', 'SmiteshP/nvim-navic', 'MunifTanjim/nui.nvim' },
  },
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = 'LspAttach',
    -- event = { "BufReadPre", "BufNewFile" },
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
    -- event = "BufReadPost",
    event = 'LspAttach',
    cmd = { 'AerialToggle', 'AerialNext', 'AerialGo', 'AerialOpen', 'AerialPrev', 'AerialOpenAll' },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
  {
    'folke/todo-comments.nvim',
    -- event = "LspAttach",
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    opts = {
      highlight = {
        -- keyword = "fg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        multiline = false, -- enable multine todo comments
        multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
        multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
        before = 'fg', -- "fg" or "bg" or empty
        keyword = 'fg', -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
        after = 'fg', -- "fg" or "bg" or empty
        pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
        comments_only = true, -- uses treesitter to match keywords in comments only
        max_line_len = 400, -- ignore lines longer than this
        exclude = {}, -- list of file types to exclude highlighting
      },
      colors = {
        warning = { 'Warning' },
        info = { 'TodoMsg' },
        hint = { '#10B981' },
        default = { 'TodoMsg' },
        test = { '#794789' },
      },
      -- TODO: testing
      -- HACK: hack
      -- FIX: a fix
      -- WARN: this is a warning
      -- PERF: this is for perf
      -- NOTE: this is a note
      -- TEST: this is a test
    },
  },
}

utils.apply_configs(plugins)

return plugins

-- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },
