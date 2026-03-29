local stayinplace = require('stay-in-place')
stayinplace.setup({
  set_keymaps = false,
  preserve_visual_selection = true,
})
local map = require("mapper").map
-- vim.keymap.set('n', '>', stayinplace.shift_right, { noremap = true, expr = true, noremap = true })
-- vim.keymap.set('n', '<', stayinplace.shift_left, { noremap = true, expr = true, noremap = true })
map('n', '=', stayinplace.filter, { expr = true })
map('n', '>>', stayinplace.shift_right_line)
map('n', '<<', stayinplace.shift_left_line)
map('n', '==', stayinplace.filter_line)
map('x', '>', stayinplace.shift_right_visual)
map('x', '<', stayinplace.shift_left_visual)
map('x', '=', stayinplace.filter_visual)
