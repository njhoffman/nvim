vim.keymap.set({ 'n', 'x' }, 'p', require('pasta.mappings').p)
vim.keymap.set({ 'n', 'x' }, 'P', require('pasta.mappings').P)
-- vim.keymap.set({ 'n' }, '<C-p>', require('pasta.mappings').toggle_pin)

-- This is the default. You can omit `setup` call if you don't want to change this.
require('pasta').setup({
  converters = { require('pasta.converters').indentation },
  paste_mode = true,
  prevent_diagnostics = true,
  next_key = vim.api.nvim_replace_termcodes('<C-p>', true, true, true),
  prev_key = vim.api.nvim_replace_termcodes('<C-n>', true, true, true),
})

require('pasta').setup.filetype({ 'markdown', 'yaml' }, { converters = {} })
