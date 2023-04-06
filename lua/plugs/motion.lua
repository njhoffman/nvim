local utils = require("utils.lazy")

local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "RRethy/nvim-treesitter-endwise",
      "RRethy/nvim-treesitter-textsubjects",
      "jbyuki/tree-sitter-ntangle",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      "p00f/nvim-ts-rainbow",
      "romgrk/nvim-treesitter-context",
      "theHamsta/nvim-treesitter-pairs",
      "windwp/nvim-ts-autotag",
    },
  },
  { "chrisgrieser/nvim-various-textobjs", event = { "BufReadPost", "BufNewFile" } },
  { "abecodes/tabout.nvim", event = { "BufReadPost", "BufNewFile" }, dependencies = { "nvim-treesitter", "nvim-cmp" } },
  { "andrewferrier/debugprint.nvim", event = "VeryLazy" },
  { "chrisgrieser/nvim-recorder", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "ziontee113/SelectEase", event = "VeryLazy" },
  { "chrisgrieser/nvim-spider", event = "VeryLazy" },
  { "Konfekt/vim-alias", event = "VeryLazy" },
  { "gbprod/substitute.nvim", event = "VeryLazy" },
  { "smjonas/live-command.nvim", cmd = { "Reg", "Norm" }, event = "VeryLazy" },
  { "echasnovski/mini.comment", version = false, event = "VeryLazy" },
  { "echasnovski/mini.doc", version = false, event = "VeryLazy" },
  { "echasnovski/mini.bracketed", event = "VeryLazy", version = false },
  { "echasnovski/mini.surround", event = { "BufRead" }, version = false },
  { "psliwka/vim-smoothie", commit = "10fd0aa", event = "VeryLazy" }, -- f2aaab1
  { dir = "~/git/clever-f.vim" }, -- rhysd/clever-f.vim
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    cmd = "MarkdownPreview",
    ft = { "markdown", "pandoc" },
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- vim.g.mkdp_browser = 'safari'
    end,
  },
}
utils.apply_configs(plugins)
return plugins

-- { "chentoast/marks.nvim" },
-- { "inkarkat/vim-UnconditionalPaste",
-- requires = "inkarkat/vim-ingo-library" },
