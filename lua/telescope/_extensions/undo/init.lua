local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('telescope_undo.nvim requires telescope.nvim - https://github.com/nvim-telescope/telescope.nvim')
end

local default_config = require('telescope._extensions.undo.config')
local config

local setup = function()
  local telescope_undo = require('telescope._extensions.undo.main')
  telescope_undo.setup_highlights()
  return telescope_undo.undo(config)
end

return telescope.register_extension({
  setup = function(extension_config, telescope_config)
    config = vim.tbl_extend('force', default_config, extension_config)
    if config['side_by_side'] and not config['use_delta'] then
      error('telescope_undo.nvim: setting side_by_side but not use_delta will have no effect')
    end
  end,
  exports = {
    undo = setup,
  },
})
