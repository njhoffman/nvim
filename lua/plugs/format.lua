local utils = require("lazy-utils")

local plugins = {
  { "windwp/nvim-autopairs", event = "InsertEnter", dependencies = { "nvim-cmp" } },
  { "andrewradev/splitjoin.vim", event = { "BufReadPost", "BufNewFile" } },
  { "dhruvasagar/vim-table-mode", event = "VeryLazy", ft = { "markdown", "pandoc", "vimwiki" } },
  { "jkramer/vim-checkbox", event = "VeryLazy", ft = { "markdown", "pandoc", "vimwiki" } },
  { "junegunn/vim-easy-align", cmd = "EasyAlign", event = { "BufReadPost", "BufNewFile" } }, -- tommcdo/vim-lion
  { "mizlan/iswap.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "monaqa/dial.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "editorconfig/editorconfig-vim", event = { "VeryLazy" } },
  { "nicwest/vim-camelsnek", event = "VeryLazy" },
  { "echasnovski/mini.fuzzy", event = "VeryLazy", version = false },
  { "johmsalas/text-case.nvim", event = "VeryLazy" },
  { "AckslD/nvim-trevJ.lua", event = "VeryLazy" },
  { "christoomey/vim-sort-motion", event = "VeryLazy" },
  { "numToStr/Comment.nvim", event = "VeryLazy" },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    enabled = false,
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },
}

utils.apply_configs(plugins)
utils.print_stats("Format", plugins)
return plugins

-- https://github.com/Furkanzmc/zettelkasten.nvim
-- https://github.com/phaazon/mind.nvim
-- https://github.com/mickael-menu/zk-nvim
