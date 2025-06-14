local utils = require("utils.lazy")

-- andersevenrud/cmp-tmux
-- chrisgrieser/cmp-nerdfont
-- David-Kunz/cmp-npm
-- f3fora/cmp-spell
-- FelipeLema/cmp-async-path
-- hrsh7th/cmp-buffer
-- hrsh7th/cmp-calc
-- hrsh7th/cmp-cmdline
-- hrsh7th/cmp-emoji
-- hrsh7th/cmp-nvim-lsp
-- hrsh7th/cmp-nvim-lsp-document-symbol
-- hrsh7th/cmp-nvim-lsp-signature-help
-- hrsh7th/cmp-nvim-lua
-- hrsh7th/cmp-omni
-- hrsh7th/cmp-path
-- jc-doyle/cmp-pandoc-references
-- js-everts/cmp-tailwind-colors
-- lukas-reineke/cmp-rg
-- quangnguyen30192/cmp-nvim-tags
-- ray-x/cmp-treesitter
-- rcarriga/cmp-dap

local plugins = {
  {
    "njhoffman/nvim-cmp",
    dir = "~/git/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter", "CmdwinEnter" },

    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
    dependencies = {
      "David-Kunz/cmp-npm",
      "JMarkin/cmp-diag-codes",
      "andersevenrud/cmp-tmux",
      "chrisgrieser/cmp-nerdfont",
      "chrisgrieser/nvim-scissors",
      "dmitmel/cmp-cmdline-history",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-calc",
      "quangnguyen30192/cmp-nvim-tags",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-nvim-lua",
      "jc-doyle/cmp-pandoc-references",
      "lukas-reineke/cmp-rg",
      "onsails/lspkind.nvim",
      "pontusk/cmp-vimwiki-tags",
      "rafamadriz/friendly-snippets",
      "ray-x/cmp-treesitter",
      "roobert/tailwindcss-colorizer-cmp.nvim",
      "tamago324/cmp-zsh",
      "tzachar/cmp-ai",
      "uga-rosa/cmp-dictionary",
      { "chrisgrieser/cmp_yanky", dependencies = "yanky.nvim" },
      { "hrsh7th/cmp-nvim-lsp", dependencies = "nvim-lspconfig" },
      { "zbirenbaum/copilot-cmp", event = "InsertEnter", dependencies = "zbirenbaum/copilot.lua" },
      { "tzachar/cmp-fuzzy-path", dependencies = { "tzachar/fuzzy.nvim" } },
      { "tzachar/cmp-fuzzy-buffer", dependencies = { "tzachar/fuzzy.nvim" } },
      { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
      { "petertriho/cmp-git", dependencies = { "nvim-lua/plenary.nvim" } },
      {
        "KadoBOT/cmp-plugins",
        config = function()
          require("cmp-plugins").setup({
            -- files = { ".*\\.lua" }  -- default
            files = { "plugins/", "configs/" }, -- Recommended: use static filenames or partial paths
          })
        end,
      },
    },
  },
  { "zbirenbaum/copilot.lua", cmd = "Copilot", build = ":Copilot auth", event = "InsertEnter" },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "molleweide/LuaSnip-snippets.nvim",
      {
        "dsznajder/vscode-es7-javascript-react-snippets",
        build = "yarn install --frozen-lockfile && yarn compile",
      },
      "honza/vim-snippets",
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    -- keys = {
    --   {
    --     "<tab>",
    --     function()
    --       return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
    --     end,
    --     expr = true, silent = true, mode = "i",
    --   },
    --   { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
    --   { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    -- },
  },
}

utils.apply_configs(plugins)
return plugins
