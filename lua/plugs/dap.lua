local utils = require("lazy-utils")

local plugins = {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "jbyuki/one-small-step-for-vimkind",
      "mfussenegger/nvim-dap-python",
      { "jbyuki/dash.nvim", dependencies = "jbyuki/ntangle.nvim" },
    },
  },
}

utils.apply_configs(plugins)
utils.print_stats("DAP", plugins)

return plugins
