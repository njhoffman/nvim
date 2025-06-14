local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local file_picker = require("telescope._extensions.tester.file")
local script_picker = require("telescope._extensions.tester.script")
local dynamic_picker = require("telescope._extensions.tester.dynamic")

return telescope.register_extension({
  -- setup = function(opts, global_opts) {

  -- },
  exports = {
    file = file_picker,
    script = script_picker,
    dynamic = dynamic_picker,
  },
})

-- tester()
