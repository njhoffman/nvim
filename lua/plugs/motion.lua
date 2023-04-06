local utils = require("utils.lazy")

local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      -- https://github.com/David-Kunz/markid
      "RRethy/nvim-treesitter-endwise",
      "theHamsta/nvim-treesitter-pairs",
      "RRethy/nvim-treesitter-textsubjects",
      "HiPhish/nvim-ts-rainbow2",
      {
        "ThePrimeagen/refactoring.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        -- keys = {
        --   -- Remaps for the refactoring operations currently offered by the plugin
        --   {
        --     mode = "x",
        --     "<leader>re",
        --     [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
        --   },
        --   {
        --     mode = "x",
        --     "<leader>rf",
        --     [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
        --   },
        --   {
        --     mode = "x",
        --     "<leader>rv",
        --     [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
        --   },
        --   {
        --     mode = "x",
        --     "<leader>ri",
        --     [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        --   },
        --
        --   -- Extract block doesn't need visual mode
        --   {
        --     mode = "n",
        --     "<leader>rb",
        --     [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
        --   },
        --   {
        --     mode = "n",
        --     "<leader>rbf",
        --     [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
        --   },
        --
        --   -- Inline variable can also pick up the identifier currently under the cursor without visual mode
        --   {
        --     mode = "n",
        --     "<leader>ri",
        --     [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        --   },
        -- },
      },
      "jbyuki/tree-sitter-ntangle",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/playground",
      "romgrk/nvim-treesitter-context",
      -- /mfussenegger/nvim-treehopper
      -- https://github.com/David-Kunz/markid
      "windwp/nvim-ts-autotag",
    },
  },

  { "echasnovski/mini.surround", event = { "BufRead" }, version = false },
  -- matching
  { "andymass/vim-matchup", dependencies = { "theHamsta/nvim-treesitter-pairs" } },
  -- pairs
  { "echasnovski/mini.pairs", event = "VeryLazy", enabled = false },
  { "windwp/nvim-autopairs", event = "InsertEnter", dependencies = { "nvim-cmp" } },
  -- textobjects
  { "echasnovski/mini.ai", event = { "BufReadPost", "BufNewFile" }, version = false },
  { "chrisgrieser/nvim-various-textobjs", event = { "BufReadPost", "BufNewFile" } },
  -- split/join
  { "echasnovski/mini.splitjoin", event = { "BufReadPost", "BufNewFile" }, version = false },
  { "Wansmer/treesj", event = { "BufReadPost", "BufNewFile" }, dependencies = { "nvim-treesitter/nvim-treesitter" } },
  -- traversal/swapping
  { "mizlan/iswap.nvim", event = { "BufReadPost", "BufNewFile" } },
  { "ziontee113/SelectEase", event = "VeryLazy" },
  { "chrisgrieser/nvim-spider", event = "VeryLazy" },
  { "echasnovski/mini.move", event = "VeryLazy" },
  { "gbprod/substitute.nvim", event = "VeryLazy" },
  { "abecodes/tabout.nvim", event = { "BufReadPost", "BufNewFile" }, dependencies = { "nvim-treesitter", "nvim-cmp" } },
  { "andrewferrier/debugprint.nvim", event = "VeryLazy" },
  { "chrisgrieser/nvim-recorder", event = "VeryLazy" },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "smjonas/live-command.nvim", cmd = { "Reg", "Norm" }, event = "VeryLazy" },
  { "Konfekt/vim-alias", event = "VeryLazy" },
  { "echasnovski/mini.comment", version = false, event = "VeryLazy" },
  { "echasnovski/mini.doc", version = false, event = "VeryLazy" },
  { "echasnovski/mini.bracketed", event = "VeryLazy", version = false },
  { "psliwka/vim-smoothie", commit = "10fd0aa", event = "VeryLazy" }, -- f2aaab1
  { dir = "~/git/clever-f.vim" }, -- rhysd/clever-f.vim
}
utils.apply_configs(plugins)
return plugins

-- { "chentoast/marks.nvim" },
-- { "inkarkat/vim-UnconditionalPaste",
-- requires = "inkarkat/vim-ingo-library" },
