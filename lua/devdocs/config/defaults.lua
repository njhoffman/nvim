local custom_filetypes = require('devdocs.config.filetypes')

---@class nvim_devdocs.Config
local defaults = {
  dir_path = vim.fn.stdpath('data') .. '/devdocs',
  telescope = require('telescope.themes').get_dropdown(),
  filetypes = custom_filetypes,
  float_win = {
    relative = 'editor',
    height = 25,
    width = 100,
    border = 'rounded',
  },
  wrap = false,
  cmd_args = {},
  cmd_ignore = {},
  previewer_cmd = nil,
  picker_cmd = false,
  picker_cmd_args = {},
  ensure_installed = {},
  preprocess_install = {},
  preprocess_read = {},
  mappings = {
    open_in_browser = '',
  },
  ---@diagnostic disable-next-line: unused-local
  after_open = function(bufnr) end,
}

return defaults
