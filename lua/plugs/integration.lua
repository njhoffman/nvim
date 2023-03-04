local utils = require("lazy-utils")
-- /usr/bin/gnome-ssh-askpass
local plugins = {
  { "aserowy/tmux.nvim" },
  {
    "nvim-neotest/neotest",
    cmd = { "Neotest", "NeotestSummary", "NeotestNearest", "NeotestAttach" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-plenary",
      "rouge8/neotest-rust",
      "akinsho/neotest-go",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      {
        "nvim-neotest/neotest-vim-test",
        dependencies = { "vim-test/vim-test", cmd = { "Test", "TestNearest", "TestFile" } },
      },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = {
      "Git",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "Gspilt",
      "Gstatus",
      "Gwrite",
      "Gread",
      "Gdiffsplit",
      "Gedit",
    },
  },
  { "rbong/vim-flog", cmd = { "Flog", "Flogsplit" } },
  { "dbeniamine/cheat.sh-vim", cmd = "Cheat" },
  { "potamides/pantran.nvim", cmd = "Pantran" },
  { "AndrewRadev/id3.vim", ft = "mp3" },
  { "npxbr/glow.nvim", cmd = "Glow" },
  { "jameshiew/nvim-magic", dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" } },
  { "michaelb/sniprun", build = "bash install.sh", cmd = { "SnipRun", "SnipInfo" } },
  { "vuki656/package-info.nvim", dependencies = "MunifTanjim/nui.nvim", ft = "json" },
  { "pwntester/octo.nvim", cmd = "Octo", dependencies = "kyazdani42/nvim-web-devicons" },
  { "NTBBloodbath/rest.nvim", cmd = { "RESTRunLast", "RESTRun", "RESTPreview" } },
  { "kdheepak/lazygit.nvim", cmd = "LazyGit" },
  { "windwp/nvim-spectre", cmd = "Spectre" },
  { "WaylonWalker/Telegraph.nvim", cmd = "Telegraph" },
  { "xeluxee/competitest.nvim", cmd = "CompetiTestRun", dependencies = "MunifTanjim/nui.nvim" },
  {
    "bennypowers/nvim-regexplainer",
    cmd = { "RegexplainerShow", "RegexplainerToggle" },
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  },
  { "lewis6991/gitsigns.nvim", event = "BufReadPost", dependencies = "nvim-lua/plenary.nvim" },
  { "rmagatti/auto-session", event = "BufReadPre" },
  { "AckslD/nvim-neoclip.lua", event = "VimEnter", dependencies = "kkharji/sqlite.lua" },
  { "aymericbeaumet/vim-symlink", event = "VeryLazy", dependency = "moll/vim-bbye" },
  { "lambdalisue/suda.vim", event = "VeryLazy" },
  { "nvim-lua/plenary.nvim", event = "VeryLazy" },
  { "rizzatti/dash.vim", event = "VeryLazy" },
  { "wakatime/vim-wakatime", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy", dependencies = "skywind3000/asyncrun.vim" },
  {
    "susensio/magic-bang.nvim",
    ft = "sh",
    opts = { automatic = true, command = true, executable = true, default = "/bin/bash" },
  },
  {
    "jamestthompson3/nvim-remote-containers",
    cmd = {
      "BuildImage",
      "AttachToContainer",
      "StartImage",
      "ComposeUp",
      "ComposeDown",
      "ComposeDestroy",
    },
  },
  {
    "tools-life/taskwiki",
    cmd = { "TW", "TWSync" },
    build = "pip3 install --upgrade git+git://github.com/tbabej/tasklib@develop",
    dependencies = {
      {
        "vimwiki/vimwiki",
        branch = "dev",
        init = function()
          vim.g.vimwiki_filetypes = { "vimwiki", "markdown", "pandoc" }
          vim.g.vimwiki_global_ext = 0
          vim.g.vimwiki_key_mappings = { all_maps = 0 }
          -- vim.cmd([[let g:vimwiki_key_mappings = { 'all_maps': 0, }]])
        end,
      },
      "vim-plugin-AnsiEsc",
      "farseer90718/vim-taskwarrior",
      "preservim/tagbar",
    },
  },
  {
    "qpkorr/vim-renamer",
    config = function()
      vim.g.RenamerShowHiddenEnabled = true
    end,
  },
}
-- { "njhoffman/neuron.nvim", { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" } },

utils.apply_configs(plugins)
utils.print_stats("Integration", plugins)
return plugins
