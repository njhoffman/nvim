local utils = require("utils.lazy")

local plugins = {
  { "abecodes/tabout.nvim", event = { "BufReadPost", "BufNewFile" }, dependencies = { "nvim-treesitter", "nvim-cmp" } },
  { "andrewferrier/debugprint.nvim", event = "VeryLazy" },
  { "chrisgrieser/nvim-recorder" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "ziontee113/SelectEase", event = "VeryLazy" },
  { "chrisgrieser/nvim-spider", event = "VeryLazy" },
  { "Konfekt/vim-alias", event = "VeryLazy" },
  { "gbprod/substitute.nvim", event = "VeryLazy" },
  { "smjonas/live-command.nvim", cmd = { "Reg", "Norm" }, event = "VeryLazy" },
  { "chrisgrieser/nvim-various-textobjs" },
  { "echasnovski/mini.comment", version = false },
  { "echasnovski/mini.doc", version = false },
  { "echasnovski/mini.bracketed", event = "VeryLazy", version = false },
  { "echasnovski/mini.surround", event = "VeryLazy", version = false },
  { "psliwka/vim-smoothie", commit = "10fd0aa", event = "VeryLazy" }, -- f2aaab1
  { dir = "~/git/clever-f.vim" }, -- rhysd/clever-f.vim
  { "AckslD/nvim-FeMaco.lua", ft = { "markdown", "pandoc" } },
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
