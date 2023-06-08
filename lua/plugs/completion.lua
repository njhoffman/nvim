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
      {
        'zbirenbaum/copilot-cmp',
        dependencies = 'copilot.lua',
        opts = {},
        config = function(_, opts)
          local copilot_cmp = require('copilot_cmp')
          copilot_cmp.setup(opts)
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          -- require('lazyvim.util').on_attach(function(client)
          --   if client.name == 'copilot' then
          --     copilot_cmp._on_insert_enter({})
          --   end
          -- end)
        end,
      },
      {
        'roobert/tailwindcss-colorizer-cmp.nvim',
        -- opts = function(_, opts)
        --   local format_kinds = opts.formatting.format
        --   opts.formatting.format = function(entry, item)
        --     format_kinds(entry, item) -- add icons
        --     return require('tailwindcss-colorizer-cmp').formatter(entry, item)
        --   end
        -- end,
        config = function()
          require('tailwindcss-colorizer-cmp').setup({
            color_square_width = 2,
          })
        end,
      },
      {
        'NvChad/nvim-colorizer.lua',
        config = function()
          require('colorizer').setup({
            buftypes = {
              '*',
              '!prompt',
              '!popup',
            },
            filetypes = {
              '*',
              '!vim',
              '!noice',
              css = { mode = 'foreground', names = true, RGB = true },
              html = { mode = 'foreground', names = true, RGB = true },
              cmp_docs = { always_update = true },
              cmp_menu = { always_update = true },
            },
            user_default_options = {
              RGB = false, -- #RGB hex codes
              RRGGBB = true, -- #RRGGBB hex codes
              names = false, -- "Name" codes like Blue or blue
              RRGGBBAA = true, -- #RRGGBBAA hex codes
              AARRGGBB = true, -- 0xAARRGGBB hex codes
              rgb_fn = true, -- CSS rgb() and rgba() functions
              hsl_fn = true, -- CSS hsl() and hsla() functions
              css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
              css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
              mode = 'virtualtext', -- foreground, background,  virtualtext
              -- Available methods are false / true / "normal" / "lsp" / "both" True is same as normal
              tailwind = true, -- Enable tailwind colors
              -- parsers can contain values used in |user_default_options|
              sass = { enable = true, parsers = { 'css' } }, -- Enable sass colors
              virtualtext = '■',
              -- update color values even if buffer is not focused example use: cmp_menu, cmp_docs
              always_update = false,
            },
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
    build = ':Copilot auth',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
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
