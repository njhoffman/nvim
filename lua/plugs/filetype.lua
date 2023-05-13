local utils = require('utils.lazy')

local lz_syn = true

local plugins = {
  {
    'jose-elias-alvarez/typescript.nvim',
    config = function()
      require('language.typescript')
    end,
    ft = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx',
    },
  },

  {
    'b0o/SchemaStore.nvim',
    ft = {
      'json',
      'jsonc',
      'yaml',
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && yarn install',
    cmd = 'MarkdownPreview',
    ft = { 'markdown', 'pandoc' },
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
      -- vim.g.mkdp_browser = 'safari'
    end,
  },
  {
    'vuki656/package-info.nvim',
    dependencies = 'MunifTanjim/nui.nvim',
    ft = 'json',
    config = function()
      -- local cfg = {
      --   colors = {
      --     up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
      --     outdated = "#d19a66", -- Text color for outdated dependency virtual text
      --   },
      --   icons = {
      --     enable = true, -- Whether to display icons
      --     style = {
      --       up_to_date = "|  ", -- Icon for up to date dependencies
      --       outdated = "|  ", -- Icon for outdated dependencies
      --     },
      --   },
      --   autostart = true, -- Whether to autostart when `package.json` is opened
      --   hide_up_to_date = false, -- It hides up to date versions when displaying virtual text
      --   hide_unstable_versions = false, -- It hides unstable versions from version list e.g next-11.1.3-canary3
      --   -- Can be `npm`, `yarn`, or `pnpm`. Used for `delete`, `install` etc...
      --   -- The plugin will try to auto-detect the package manager based on
      --   -- `yarn.lock` or `package-lock.json`. If none are found it will use the
      --   -- provided one, if nothing is provided it will use `yarn`
      --   package_manager = "yarn",
      -- }
      require('package-info').setup({ package_manager = 'npm' })
    end,
    -- event = { "BufReadPost", "BufNewFile" },
    -- ft = "json",
  },
  { 'romainl/vim-qf', ft = 'qf' },
  { 'kevinhwang91/nvim-bqf', cmd = { 'BqfEnable', 'BqfToggle' }, ft = 'qf' },
  { 'herringtondarkholme/yats.vim', ft = 'typescript', lazy = lz_syn },
  { 'AckslD/nvim-FeMaco.lua', ft = { 'markdown', 'pandoc' } },
  { 'njhoffman/vim-liquid', ft = 'liquid', lazy = lz_syn },
  -- {
  --   'SidOfc/mkdx',
  --   ft = { 'markdown', 'pandoc' },
  --   lazy = false,
  -- },
  { 'moll/vim-node', ft = { 'javascript' }, lazy = lz_syn },
  { 'bfrg/vim-jq', ft = 'jq', lazy = lz_syn },
  { 'maxmellon/vim-jsx-pretty', ft = { 'javascript', 'jsx', 'javascriptreact' }, lazy = lz_syn },
  { 'yuezk/vim-js', ft = { 'javascript', 'jsx', 'javascriptreact' }, lazy = lz_syn },
  { 'zdharma-continuum/zinit-vim-syntax', ft = 'zsh', lazy = lz_syn },
  { 'wgwoods/vim-systemd-syntax', ft = 'systemd', lazy = lz_syn },
  { 'aliou/bats.vim', ft = 'bats', lazy = lz_syn },
  { 'alx741/vim-hindent', ft = 'haskell', lazy = lz_syn },
  { 'cakebaker/scss-syntax.vim', ft = 'scss', lazy = lz_syn },
  { 'chr4/nginx.vim', ft = 'nginx', lazy = lz_syn },
  { 'ekalinin/dockerfile.vim', ft = 'dockerfile', lazy = lz_syn },
  { 'elzr/vim-json', ft = 'json', lazy = lz_syn },
  { 'ericpruitt/tmux.vim', ft = 'tmux', lazy = lz_syn },
  { 'euclidianace/betterlua.vim', ft = 'lua', lazy = lz_syn },
  { 'gisphm/vim-gitignore', ft = 'gitignore', lazy = lz_syn },
  { 'glench/vim-jinja2-syntax', ft = 'jinja', lazy = lz_syn },
  { 'gutenye/json5.vim', ft = 'json5', lazy = lz_syn },
  { 'jparise/vim-graphql', ft = 'graphql', lazy = lz_syn },
  { 'kchmck/vim-coffee-script', ft = 'coffee', lazy = lz_syn },
  { 'lifepillar/pgsql.vim', ft = 'pgsql', lazy = lz_syn },
  { 'lnl7/vim-nix', ft = 'nix', lazy = lz_syn },
  { 'neoclide/jsonc.vim', ft = 'jsonc', lazy = lz_syn },
  { 'neovimhaskell/haskell-vim', ft = 'haskell', lazy = lz_syn },
  { 'octol/vim-cpp-enhanced-highlight', ft = 'cpp', lazy = lz_syn },
  { 'pearofducks/ansible-vim', ft = 'ansible', lazy = lz_syn },
  { 'potatoesmaster/i3-vim-syntax', ft = 'i3', lazy = lz_syn },
  { 'rodjek/vim-puppet', ft = 'puppet', lazy = lz_syn },
  { 'stanangeloff/php.vim', ft = 'php', lazy = lz_syn },
  { 'tbastos/vim-lua', ft = 'lua', lazy = lz_syn },
  { 'tikhomirov/vim-glsl', ft = 'glsl', lazy = lz_syn },
  { 'vim-pandoc/vim-pandoc-syntax', ft = { 'markdown', 'pandoc' }, lazy = lz_syn },
  { 'vim-utils/vim-man', ft = 'man', lazy = lz_syn },
  { 'vimwiki/vimwiki', ft = { 'markdown', 'vimwiki' }, lazy = lz_syn },
  { 'mtdl9/vim-log-highlighting', ft = { 'log', 'LOG' }, event = { 'BufReadPost', 'BufNewFile' }, lazy = lz_syn },
  { 'hashivim/vim-terraform', ft = 'terraform', event = { 'BufReadPost', 'BufNewFile' }, lazy = lz_syn },
  { 'raimon49/requirements.txt.vim', event = 'VeryLazy', lazy = lz_syn },
  { 'godlygeek/tabular', event = 'VeryLazy', lazy = lz_syn },
  { 'preservim/vim-markdown', commit = 'df4be8626e2c5b2a42eb60e1f100fce469b81f7d', dependencies = { 'godlygeek/tabular' } },

  -- {
  --   "jakewvincent/mkdnflow.nvim",
  --   enabled = false,
  -- },
  -- {
  --   'plasticboy/vim-markdown',
  --   branch = 'master',
  --   require = {'godlygeek/tabular'},
  -- },
  -- use "plasticboy/vim-markdown"
}

utils.apply_configs(plugins)
return plugins
