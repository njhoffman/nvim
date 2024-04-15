local stayinplace = require('stay-in-place')
stayinplace.setup({
  set_keymaps = false,
  preserve_visual_selection = true,
})
-- vim.keymap.set('n', '>', stayinplace.shift_right, { noremap = true, expr = true, noremap = true })
-- vim.keymap.set('n', '<', stayinplace.shift_left, { noremap = true, expr = true, noremap = true })
vim.keymap.set('n', '=', stayinplace.filter, { noremap = true, expr = true })
vim.keymap.set('n', '>>', stayinplace.shift_right_line, { noremap = true })
vim.keymap.set('n', '<<', stayinplace.shift_left_line, { noremap = true })
vim.keymap.set('n', '==', stayinplace.filter_line, { noremap = true })
vim.keymap.set('x', '>', stayinplace.shift_right_visual, { noremap = true })
vim.keymap.set('x', '<', stayinplace.shift_left_visual, { noremap = true })
vim.keymap.set('x', '=', stayinplace.filter_visual, { noremap = true })
