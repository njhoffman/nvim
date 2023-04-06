local utils = require("utils.lazy")
local plugins = {
  {
    "qpkorr/vim-renamer",
    config = function()
      vim.g.RenamerShowHiddenEnabled = true
    end,
  },
  {
    "jamestthompson3/nvim-remote-containers",
    cmd = { "BuildImage", "AttachToContainer", "StartImage", "ComposeUp", "ComposeDown", "ComposeDestroy" },
  },
  { "lambdalisue/suda.vim", event = "VeryLazy" },
  { "skywind3000/asynctasks.vim", event = "VeryLazy", dependencies = "skywind3000/asyncrun.vim" },
  { "aymericbeaumet/vim-symlink", event = "VeryLazy", dependencies = "moll/vim-bbye" },
  { "t-troebst/perfanno.nvim", cmd = { "PerfLoadFlat", "PerfLoadCallGraph", "PerfLoadFlameGraph" } },
  {
    "chrisgrieser/nvim-genghis",
    event = "VeryLazy",
    dependencies = { "stevearc/dressing.nvim", "hrsh7th/nvim-cmp", "hrsh7th/cmp-omni" },
  },
}

utils.apply_configs(plugins)
return plugins
