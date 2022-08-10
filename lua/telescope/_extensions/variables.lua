local has_telescope, telescope = pcall(require, "telescope")
local main = require("telescope._extensions.variables.main")

if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
  setup = main.setup,
  exports = {
    variables = main.all,
    buffer = main.buffer,
    predef = main.predef,
    global = main.global,
    window = main.window,
  }
})
