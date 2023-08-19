local utils = require('utils.lazy')

local lz_syn = false

local plugins = {
  { 'bfrg/vim-jqplay', ft = 'jq', cmd = { 'Jqplay', 'JqplayScratch', 'JqplayScratchNoInput' } },
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
    'llllvvuu/nvim-js-actions',
    ft = {
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        command = 'nnoremap <buffer> <leader>ta ' .. ":lua require('nvim-js-actions').js_arrow_fn.toggle()<CR>",
        -- can also do `require('nvim-js-actions/js-arrow-fn').toggle()`
      })
    end,
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
  },
  { 'serenevoid/kiwi.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'kevinhwang91/nvim-bqf', cmd = { 'BqfEnable', 'BqfToggle' }, ft = 'qf' },
  { 'herringtondarkholme/yats.vim', ft = 'typescript', lazy = lz_syn },
  { 'AckslD/nvim-FeMaco.lua', ft = { 'markdown', 'pandoc' } },
  { 'njhoffman/vim-liquid', ft = 'liquid', lazy = lz_syn },
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
  {
    'preservim/vim-markdown',
    commit = 'df4be8626e2c5b2a42eb60e1f100fce469b81f7d',
    dependencies = { 'godlygeek/tabular' },
  },
  -- { 'SidOfc/mkdx', ft = { 'markdown', 'pandoc' }, lazy = false },
  -- { "jakewvincent/mkdnflow.nvim", enabled = false },
  -- { 'plasticboy/vim-markdown', branch = 'master', require = {'godlygeek/tabular'}, },
}

utils.apply_configs(plugins)
return plugins
