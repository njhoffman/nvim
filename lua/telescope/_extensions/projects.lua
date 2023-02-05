local has_telescope, telescope = pcall(require, "telescope")
local main = require("telescope._extensions.projects.main")

if not has_telescope then
  return
end

return telescope.register_extension({
  setup = main.setup,
  exports = {
    projects = main.all,
    recent = main.recent,
    nvim = main.nvim,
  },
})
