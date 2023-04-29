local utils = require('utils.lazy')

local plugins = {
  {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'CmdlineEnter', 'CmdwinEnter' },
    dependencies = {
      'David-Kunz/cmp-npm',
      'andersevenrud/cmp-tmux',
      'dmitmel/cmp-cmdline-history',
      'f3fora/cmp-spell',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-document-symbol',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'jc-doyle/cmp-pandoc-references',
      'onsails/lspkind.nvim',
      'pontusk/cmp-vimwiki-tags',
      'rafamadriz/friendly-snippets',
      'ray-x/cmp-treesitter',
      'uga-rosa/cmp-dictionary',
      'zbirenbaum/copilot-cmp',
      {
        'roobert/tailwindcss-colorizer-cmp.nvim',
        config = function()
          require('tailwindcss-colorizer-cmp').setup({
            color_square_width = 2,
          })
        end,
      },
      { 'tzachar/cmp-fuzzy-path', dependencies = { 'tzachar/fuzzy.nvim' } },
      { 'tzachar/cmp-fuzzy-buffer', dependencies = { 'tzachar/fuzzy.nvim' } },
      { 'saadparwaiz1/cmp_luasnip', dependencies = { 'L3MON4D3/LuaSnip' } },
      { 'petertriho/cmp-git', dependencies = { 'nvim-lua/plenary.nvim' } },
    },
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    enabled = false,
    event = 'VeryLazy',
    config = true,
  },
  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'molleweide/LuaSnip-snippets.nvim',
      { 'dsznajder/vscode-es7-javascript-react-snippets', build = 'yarn install --frozen-lockfile && yarn compile' },
      'honza/vim-snippets',
      -- config = function()
      --   require("luasnip.loaders.from_vscode").lazy_load()
      -- end,
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
