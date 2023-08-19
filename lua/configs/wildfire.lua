local default_cfg = {
  surrounds = {
    { '(', ')' },
    { '{', '}' },
    { '<', '>' },
    { '[', ']' },
  },
  keymaps = {
    init_selection = '<CR>',
    node_incremental = '<CR>',
    node_decremental = '<BS>',
  },
}
require('wildfire').setup({
  keymaps = {
    init_selection = 'vv',
    node_incremental = 'v',
    node_decremental = 'V',
  },
})
