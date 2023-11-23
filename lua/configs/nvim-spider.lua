local M = require('mapper')
M.map(
  { 'n', 'o', 'x' },
  'w',
  "<cmd>lua require('spider').motion('w')<CR>",
  { desc = '󱇫 spider-w motion', plugin = 'nvim-spider', category = 'Motion' }
)
M.map(
  { 'n', 'o', 'x' },
  'e',
  "<cmd>lua require('spider').motion('e')<CR>",
  { desc = '󱇫 spider-e motion', plugin = 'nvim-spider', category = 'Motion' }
)
M.map(
  { 'n', 'o', 'x' },
  'b',
  "<cmd>lua require('spider').motion('b')<CR>",
  { desc = '󱇫 spider-b motion', plugin = 'nvim-spider', category = 'Motion' }
)
M.map(
  { 'n', 'o', 'x' },
  'ge',
  "<cmd>lua require('spider').motion('ge')<CR>",
  { desc = '󱇫 spider-ge motion', plugin = 'nvim-spider', category = 'Motion' }
)

require('spider').setup({
  skipInsignificantPunctuation = false,
})
