local map = require("mapper").map

require('ranger-nvim').setup({ replace_netrw = true })
map('n', '<leader>ef', function()
  require('ranger-nvim').open(true)
end)
