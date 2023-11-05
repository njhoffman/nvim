local utils = require('utils.lazy')

local plugins = {
  {
    'njhoffman/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter', 'CmdwinEnter' },
    dependencies = {
      'David-Kunz/cmp-npm',
      'andersevenrud/cmp-tmux',
      'JMarkin/cmp-diag-codes',
      'dmitmel/cmp-cmdline-history',
      'tzachar/cmp-ai',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-emoji',
      { 'chrisgrieser/cmp_yanky', dependencies = 'yanky.nvim' },
      { 'hrsh7th/cmp-nvim-lsp', dependencies = 'nvim-lspconfig' },
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'jc-doyle/cmp-pandoc-references',
      'roobert/tailwindcss-colorizer-cmp.nvim',
      'onsails/lspkind.nvim',
      'pontusk/cmp-vimwiki-tags',
      'rafamadriz/friendly-snippets',
      'ray-x/cmp-treesitter',
      'uga-rosa/cmp-dictionary',
      { 'zbirenbaum/copilot-cmp', dependencies = 'copilot.lua' },
      { 'tzachar/cmp-fuzzy-path', dependencies = { 'tzachar/fuzzy.nvim' } },
      { 'tzachar/cmp-fuzzy-buffer', dependencies = { 'tzachar/fuzzy.nvim' } },
      { 'saadparwaiz1/cmp_luasnip', dependencies = { 'L3MON4D3/LuaSnip' } },
      { 'petertriho/cmp-git', dependencies = { 'nvim-lua/plenary.nvim' } },
      {
        'KadoBOT/cmp-plugins',
        config = function()
          require('cmp-plugins').setup({
            -- files = { ".*\\.lua" }  -- default
            files = { 'plugins/', 'configs/' }, -- Recommended: use static filenames or partial paths
          })
        end,
      },
    },
  },
  { 'gsuuon/llm.nvim' },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    event = 'InsertEnter',
  },
  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'molleweide/LuaSnip-snippets.nvim',
      { 'dsznajder/vscode-es7-javascript-react-snippets', build = 'yarn install --frozen-lockfile && yarn compile' },
      'honza/vim-snippets',
    },
    opts = {
      history = true,
      delete_check_events = 'TextChanged',
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },
}

utils.apply_configs(plugins)
return plugins

-- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },
