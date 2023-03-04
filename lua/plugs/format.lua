local utils = require("lazy-utils")

local plugins = {
  { "dhruvasagar/vim-table-mode", ft = { "markdown", "pandoc", "vimwiki" } },
  { "jkramer/vim-checkbox", ft = { "markdown", "pandoc.markdown", "vimwiki", "vimwiki.markdown" } },
  { "andrewradev/splitjoin.vim", event = { "BufReadPost", "BufNewFile" } }, --  https://github.com/FooSoft/vim-argwrap
  { "b3nj5m1n/kommentary", event = { "BufReadPost", "BufNewFile" } },
  { "junegunn/vim-easy-align", event = { "BufReadPost", "BufNewFile" } }, -- tommcdo/vim-lion
  { "kylechui/nvim-surround", event = { "BufReadPost", "BufNewFile" } },
  { "editorconfig/editorconfig-vim", event = { "BufReadPost", "BufNewFile" } },
  { "mizlan/iswap.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "monaqa/dial.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "nicwest/vim-camelsnek", event = "VeryLazy" },
  { "numToStr/Comment.nvim", event = "VeryLazy" },
  { "windwp/nvim-autopairs", event = "VeryLazy" }, -- jiangmiao/auto-pairs
  { "johmsalas/text-case.nvim", event = "VeryLazy" },
  { "AckslD/nvim-trevJ.lua", event = "VeryLazy" },
  { "christoomey/vim-sort-motion", event = "VeryLazy" },
  -- { "echasnovski/mini.pairs", event = "VeryLazy",
  --   config = function(_, opts)
  --     require("mini.pairs").setup(opts)
  --   end
  -- },
}

utils.apply_configs(plugins)
utils.print_stats("Format", plugins)
return plugins

-- https://github.com/Furkanzmc/zettelkasten.nvim
-- https://github.com/phaazon/mind.nvim
-- https://github.com/mickael-menu/zk-nvim
