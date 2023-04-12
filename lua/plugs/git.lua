local utils = require("utils.lazy")
local plugins = {
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } },
  {
    "ThePrimeagen/git-worktree.nvim",
    event = "VeryLazy",
    -- ! For some reason declaring this dependency overrides telescope.nvim setup in lazyvim core
    -- dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("git-worktree").setup()
      require("telescope").load_extension("git_worktree")
    end,
    keys = function()
      require("which-key").register({
        mode = { "n", "v" },
        -- TODO: clean up this which-key mess :(
        ["<leader>t"] = { name = "+telescope" },
        ["<leader>gw"] = { name = "git-worktree" },
      }, nil)

      return {
        {
          "<leader>gws",
          function()
            require("telescope").extensions.git_worktree.git_worktrees()
          end,
          desc = "[s]witch",
        },
        {
          "<leader>gwa",
          function()
            require("telescope").extensions.git_worktree.create_git_worktree()
          end,
          desc = "[a]dd",
        },
      }
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    cmd = { "GitConflictListQf", "GitConflictNextConflict" },
    event = { "BufReadPost", "BufNewFile" },
  },
  { "pwntester/octo.nvim", cmd = "Octo", dependencies = "nvim-tree/nvim-web-devicons" },
  { "kdheepak/lazygit.nvim", cmd = "LazyGit" },
  { "lewis6991/gitsigns.nvim", event = "BufReadPost", dependencies = "nvim-lua/plenary.nvim" },
  {
    "tpope/vim-fugitive",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "Git", "Ggrep", "GMove", "GDelete", "Gspilt", "Gstatus", "Gwrite", "Gread", "Gdiffsplit", "Gedit" },
    dependencies = { { "tpope/vim-rhubarb", cmd = "GBrowse" } },
  },
}

utils.apply_configs(plugins)
return plugins
