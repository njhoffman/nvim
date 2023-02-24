local utils = require("lazy-utils")

local plugins = {
  { "rmagatti/auto-session" },
  { "xeluxee/competitest.nvim", dependencies = "MunifTanjim/nui.nvim" },
  { "lewis6991/gitsigns.nvim", dependencies = "nvim-lua/plenary.nvim" },
  { "pwntester/octo.nvim", dependencies = "kyazdani42/nvim-web-devicons" },
  { "rbong/vim-flog" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-rhubarb" },
  { "wakatime/vim-wakatime" },
  { "skywind3000/asynctasks.vim", dependencies = "skywind3000/asyncrun.vim" },
  { "folke/noice.nvim" }, -- highlight for Window separator
  { "GustavoKatel/tasks.nvim" },
  { "potamides/pantran.nvim" },
  { "nvim-colortils/colortils.nvim" },
  { "dbeniamine/cheat.sh-vim" },
  { "AndrewRadev/id3.vim" }, -- "AndrewRadev/id3.vim"
  { "jameshiew/nvim-magic", dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" } },
  { "michaelb/sniprun", build = "bash ./install.sh" },
  { "vuki656/package-info.nvim", dependencies = "MunifTanjim/nui.nvim" },
  { "urbainvaes/vim-ripple" },
  { "vim-test/vim-test" },
  { "NTBBloodbath/rest.nvim" },
  { "kdheepak/lazygit.nvim" },
  { "aserowy/tmux.nvim" },
  { "WaylonWalker/Telegraph.nvim" },
  { "bennypowers/nvim-regexplainer", dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" } },
  {
    "susensio/magic-bang.nvim",
    config = function()
      require("magic-bang").setup({
        automatic = true, -- insert shebang on new file when in $PATH
        command = true, -- define Bang user command
        executable = true, -- make file executable on exit
        default = "/bin/bash", -- default shebang for `:Bang` without args
      })
    end,
  },
  {
    "tools-life/taskwiki",
    dependencies = {
      {
        "vimwiki/vimwiki",
        branch = "dev",
        config = function()
          vim.g.vimwiki_global_ext = 0
          vim.cmd([[let g:vimwiki_key_mappings = { 'all_maps': 0, }]])
        end,
      },
      "vim-plugin-AnsiEsc",
      "farseer90718/vim-taskwarrior",
      "preservim/tagbar",
    },
    -- TODO: also needs taskwarrior, tasklib, pip install --upgrade git+git://github.com/tbabej/tasklib@develop
  },
  { "qpkorr/vim-renamer" },
  { "jamestthompson3/nvim-remote-containers" },
  { "lambdalisue/suda.vim" },
  { "aymericbeaumet/vim-symlink" },
  { "bchretien/vim-profiler" },
  { "tweekmonster/startuptime.vim" },
  { "nvim-lua/plenary.nvim" },
}

utils.apply_configs(plugins)
utils.print_stats("Integration", plugins)
return plugins
