vim.cmd [[
  let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
  let g:sandwich#recipes += [
    {
      'external': ['it', 'at'],
      'noremap' : 1,
      'filetype': ['html'],
      'input'   : ['t'],
     },
  ]
]]

-- If you want to use vim-sandwich with vim-surround keymappings, add the following line to your vimrc.
-- runtime macros/sandwich/keymap/surround.vim
-- ys, yss, yS, ds, cs in normal mode and S in visual mode are available. dss and css (not found in vim-surround) are also available: These are similar to ds and cs but determine deleted/replaced texts automatically. See the file directly for details.
