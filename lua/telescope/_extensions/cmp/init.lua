local has_telescope, telescope = pcall(require, "telescope")
local cmp = require("telescope._extensions.what-key.main")

if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

return telescope.register_extension({
  setup = cmp.setup,
  exports = {
    ["cmp"] = cmp.all,
    -- todo = main.todo,
    -- conflicts = main.conflicts,
  },
})
