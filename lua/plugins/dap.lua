local utils = require('utils.lazy')
-- https://github.com/krady21/compiler-explorer.nvim
-- https://github.com/p00f/godbolt.nvim
-- https://hiphish.github.io/blog/2024/02/20/debugging-lua-scripts-running-in-neovim/
local plugins = {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'jbyuki/one-small-step-for-vimkind',
      'mfussenegger/nvim-dap-python',
      { 'jbyuki/dash.nvim', dependencies = 'jbyuki/ntangle.nvim' },
      { 'LiadOz/nvim-dap-repl-highlights' },
    },
  },
}

utils.apply_configs(plugins)

return plugins
