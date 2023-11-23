local telescope = require('telescope')
local yank_history = require('telescope._extensions.yank_history.yank_history')

return telescope.register_extension({
  exports = yank_history.get_exports(),
})
