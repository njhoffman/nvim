local utils = require("lazy-utils")

local plugins = {
  { "andrewferrier/debugprint.nvim", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "Konfekt/vim-alias", event = "VeryLazy" },
  { "gbprod/substitute.nvim", event = "VeryLazy" },
  {
    "kwkarlwang/bufjump.nvim",
    event = "VeryLazy",
    opts = {
      forward = "<C-i>",
      backward = "<C-o>",
      on_success = function()
        vim.cmd([[execute "normal! g`\"zz"]])
      end,
    },
  },
  { "smjonas/live-command.nvim", cmd = { "Reg", "Norm" }, event = "VeryLazy" },
  {
    "andymass/vim-matchup",
    event = "BufRead",
    init = function()
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = {
        method = "popup",
      }
    end,
  },
  { "echasnovski/mini.bracketed", event = "VeryLazy", version = false },
  { "echasnovski/mini.surround", event = "VeryLazy", version = false },
  { "echasnovski/mini.fuzzy", event = "VeryLazy", version = false },
  { "chaoren/vim-wordmotion", event = "VeryLazy" },
  { "psliwka/vim-smoothie", commit = "10fd0aa", event = "VeryLazy" }, -- f2aaab1
  { dir = "~/git/clever-f.vim" }, -- rhysd/clever-f.vim
  { "AckslD/nvim-FeMaco.lua", ft = { "markdown", "pandoc" } },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && yarn install",
    cmd = "MarkdownPreview",
    ft = { "markdown", "pandoc" },
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
      -- vim.g.mkdp_browser = 'safari'
    end,
  },
  { "machakann/vim-sandwich", event = "VeryLazy" },
  -- { "chentoast/marks.nvim" },
}
--   { "inkarkat/vim-UnconditionalPaste",
--   requires = "inkarkat/vim-ingo-library" },

utils.apply_configs(plugins)
utils.print_stats("Motion", plugins)
return plugins
