local telescope = require("telescope")
local main = require("telescope._extensions.highlights.main")

return telescope.register_extension({
  setup = main.setup,
  exports = {
    all = main.all,
    colorscheme = main.colorscheme,
  },
})
