local has_telescope, telescope = pcall(require, 'telescope')
local pickers = require('telescope._extensions.devdocs.pickers')

if not has_telescope then
  error('This plugins requires nvim-telescope/telescope.nvim')
end

return telescope.register_extension({
  -- setup = main.setup,
  exports = {
    -- variables = main.all,
    devdocs = pickers.open_picker_alias_dyn,
  },
})
