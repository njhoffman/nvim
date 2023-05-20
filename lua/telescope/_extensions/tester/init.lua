local has_telescope, telescope = pcall(require, 'telescope')
if not has_telescope then
  error('This plugin requires nvim-telescope/telescope.nvim')
end

local file_picker = require('telescope._extensions.tester.file')
local script_picker = require('telescope._extensions.tester.script')

return telescope.register_extension({
  exports = {
    file = file_picker,
    script = script_picker,
  },
})

-- tester()
