local utils = require("lazy-utils")

local plugins = {
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp-document-symbol",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      "ray-x/cmp-treesitter",
      "f3fora/cmp-spell",
      "David-Kunz/cmp-npm",
      "andersevenrud/cmp-tmux",
      "pontusk/cmp-vimwiki-tags",
      "jc-doyle/cmp-pandoc-references",
    }
  },
  { "tzachar/cmp-fuzzy-path", dependencies = { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" } },
  { "tzachar/cmp-fuzzy-buffer", dependencies =  { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" } },
  { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip", "hrsh7th/nvim-cmp" } },
  { "petertriho/cmp-git", dependencies =  {"nvim-lua/plenary.nvim" } },
  { "molleweide/LuaSnip-snippets.nvim" },
  { "rafamadriz/friendly-snippets" },
  { "honza/vim-snippets" },
  { "kitagry/vs-snippets" },
  { "milisims/nvim-luaref" },
  { "nanotee/luv-vimdocs" },
  { "dsznajder/vscode-es7-javascript-react-snippets", build = "yarn install --frozen-lockfile && yarn compile" },
}

utils.apply_configs(plugins)
utils.print_stats('Completion', plugins)
return plugins

-- ["cmp-tabnine"] = { "tzachar/cmp-tabnine", run = "./install.sh", after = "nvim-cmp" },
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },
