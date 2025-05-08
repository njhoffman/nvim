local utils = require("utils.lazy")
-- https://theosteiner.de/debugging-javascript-frameworks-in-neovim
-- https://github.com/krady21/compiler-explorer.nvim
-- https://github.com/p00f/godbolt.nvim
-- https://hiphish.github.io/blog/2024/02/20/debugging-lua-scripts-running-in-neovim/

local u = require("configs.dap.util")
local m = u.lazy_map

local plugins = {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
      { "jbyuki/dash.nvim", dependencies = "jbyuki/ntangle.nvim" },
      { "LiadOz/nvim-dap-repl-highlights" },
    },
    keys = {
      m("<F1>", [[DapStepInto]]),
      m("<F2>", [[DapStepOver]]),
      m("<F3>", [[DapStepOut]]),
      m("<F4>", [[DapStepBack]]),
      m("<F5>", [[DapContinue]]),
      ---
      m("<F8>", [[DapStepInto]]),
      m("<F9>", [[DapStepOver]]),
      m("<F10>", [[DapStepOut]]),
      ---
      m("<F6>", [[DapDisconnect]]),
    },
    init = function()
      local dap = require("dap")
      require("configs.dap.keymaps").setup(dap)
    end,
    cmd = { "DapContinue" },
    config = function()
      local dap = require("dap")
      require("configs.dap.adapters").setup(dap)
      dap.defaults.go.autostart = "Debug main.go"
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      floating = { border = "rounded" },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.75 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
          },
          position = "left",
          size = 40,
          elements = {
            { id = "repl", size = 0.75 },
            { id = "console", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    config = true,
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    event = "BufReadPre",
  },
  {
    "ofirgall/goto-breakpoints.nvim",
    event = "BufReadPre",
    keys = {
      m("]r", [[lua require('goto-breakpoints').next()]]),
      m("[r", [[lua require('goto-breakpoints').prev()]]),
    },
    dependencies = "mfussenegger/nvim-dap",
    enabled = true,
  },
  {
    "Weissle/persistent-breakpoints.nvim",
    event = "BufReadPre",
    opts = {
      load_breakpoints_event = { "BufReadPost" },
    },
    keys = {
      m("<leader>/", [[lua require('persistent-breakpoints.api').toggle_breakpoint()]]),
      m("<F11>", [[lua require('persistent-breakpoints.api').clear_all_breakpoints()]]),
    },
    dependencies = "mfussenegger/nvim-dap",
  },
}
utils.apply_configs(plugins)
return plugins
