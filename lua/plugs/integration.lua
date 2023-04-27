-- /usr/bin/gnome-ssh-askpass
local utils = require('utils.lazy')
local plugins = {
  -- { "aserowy/tmux.nvim" },
  { 'jbyuki/quickmath.nvim', cmd = 'Quickmath' },
  { 'jameshiew/nvim-magic', dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' } },
  { 'michaelb/sniprun', build = 'bash install.sh', cmd = { 'SnipRun', 'SnipInfo' } },
  { 'milisims/nvim-luaref' },
  { 'windwp/nvim-spectre', cmd = 'Spectre' },
  { 'WaylonWalker/Telegraph.nvim', cmd = 'Telegraph' },
  {
    'bennypowers/nvim-regexplainer',
    cmd = { 'RegexplainerShow', 'RegexplainerToggle' },
    dependencies = { 'nvim-lua/plenary.nvim', 'MunifTanjim/nui.nvim' },
  },
  { 'rmagatti/auto-session', event = 'VimEnter' },
  { 'wakatime/vim-wakatime', event = 'VeryLazy' },
  { 'AndrewRadev/id3.vim' },
  {
    'susensio/magic-bang.nvim',
    ft = 'sh',
    opts = { automatic = true, command = true, executable = true, default = '/bin/bash' },
  },
}
-- { "njhoffman/neuron.nvim", { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" } },

utils.apply_configs(plugins)
return plugins
