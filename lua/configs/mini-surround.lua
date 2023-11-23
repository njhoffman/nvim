---@diagnostic disable-next-line: unused-local
local default_cfg = {
  custom_surroundings = nil,
  highlight_duration = 500,
  mappings = {
    add = 'sa', -- Add surrounding in Normal and Visual modes
    delete = 'sd', -- Delete surrounding
    find = 'sf', -- Find surrounding (to the right)
    find_left = 'sF', -- Find surrounding (to the left)
    highlight = 'sh', -- Highlight surrounding
    replace = 'sr', -- Replace surrounding
    update_n_lines = 'sn', -- Update `n_lines`

    suffix_last = 'l', -- Suffix to search with "prev" method
    suffix_next = 'n', -- Suffix to search with "next" method
  },
  n_lines = 20,
  respect_selection_type = false,
  search_method = 'cover',
}

---@diagnostic disable-next-line: unused-local
local vim_surround = {
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'cs',
    update_n_lines = '',

    -- Add this only if you don't want to use extended mappings
    suffix_last = '',
    suffix_next = '',
  },
  search_method = 'cover_or_next',
}
-- { "ys", desc = "󰅪 Add Surround Operator" },
-- { "s", mode = "x", desc = "󰅪 Add Surround Operator" },
-- { "yS", "ys$", desc = "󰅪 Surround to EoL", remap = true },
-- { "ds", desc = "󰅪 Delete Surround Operator" },
-- { "cs", desc = "󰅪 Change Surround Operator" },

local custom_surroundings = {
  -- Lua long brackets - ysiwS
  B = {
    -- Configuration for "input" (like for delete) is done with Lua patterns
    input = { find = '%[%[.-%]%]', extract = '^(..).*(..)$' },
    -- Configuration for "output" (like for add) is done with plain text
    output = { left = '[[', right = ']]' },
  },
  -- Use `(` to insert with spaces, `)` will still add without them
  ['('] = { output = { left = '( ', right = ' )' } },
}

local cfg = {
  -- custom_surroundings = custom_surroundings,
  mappings = {
    add = 's', -- Add surrounding in Normal and Visual modes
    delete = 'ds', -- Add surrounding in Normal and Visual modes
    replace = 'cs', -- Replace surrounding
    find = 'sf', -- Find surrounding (to the right)
    find_left = 'sF', -- Find surrounding (to the left)
    highlight = 'sh', -- Highlight surrounding
    -- update_n_lines = 'sn', -- Update `n_lines`
    suffix_last = '', -- Suffix to search with "prev" method
    suffix_next = '', -- Suffix to search with "next" method
    -- suffix_last = 'l', -- Suffix to search with "prev" method
    -- suffix_next = 'n', -- Suffix to search with "next" method
  },
  highlight_duration = 400,
  n_lines = 30,
  respect_selection_type = true,
  search_method = 'cover_or_next',
}
--
-- ["x]s			Delete [count] characters [into register x] and start insert (s stands for Substitute).  Synonym for "cl" (not |linewise|).
-- vim.api.nvim_del_keymap('x', 'S')

require('mini.surround').setup(cfg)
-- vim.keymap.set(
--   'n',
--   's<space>',
-- noremap <silent> s<space> :execute "normal wst\<space>" . nr2char(getchar()) . "\<lt>esc>"<cr>
--   ':silent! normal wst<space>',
--   { silent = true, expr = true, desc = 'quickly add surrounding ( to word' }
-- )
vim.cmd([[
  noremap <silent> s<space> :execute "normal hwst\<space>" . nr2char(getchar()) . "\<lt>esc>"<cr>
" getline(".")[col(".")-1] == "\t"
  " let isOnKeyword = matchstr(getline('.'), '\%'.col('.').'c.') =~# '\k'
  " noremap s<space> :normal wst " . nr2char(getchar()) . <cr>
]])

-- vim.keymap.set({ 'x', 'n' }, 'ys', 's', { expr = true, desc = '󰅪 mini surround add operator/visual selection' })
-- vim.keymap.set(
--   { 'x' },
--   'ys',
--   "<cmd>lua MiniSurround.add('visual')<CR>",
--   { desc = '󰅪 mini surround add visual selection', expr = true }
-- )
--
-- vim.keymap.set(
--   { 'n' },
--   'ys',
--   "<cmd>lua MiniSurround.operator('add')<CR>",
--   { expr = true, desc = '󰅪 mini surround add operator selection' }
-- )

-- vim.keymap.set('n', 'yss', 'ys$', { remap = true, desc = '󰅪 mini surround add line' })

-- expr_map(m.add,       H.make_operator('add', nil, nil, true), 'Add surrounding')
--  expr_map(m.delete,    H.make_operator('delete'),              'Delete surrounding')
--  expr_map(m.replace,   H.make_operator('replace'),             'Replace surrounding')
--  expr_map(m.find,      H.make_operator('find', 'right'),       'Find right surrounding')
--  expr_map(m.find_left, H.make_operator('find', 'left'),        'Find left surrounding')
--  expr_map(m.highlight, H.make_operator('highlight'),           'Highlight surrounding')
--
--  H.map('n', m.update_n_lines, MiniSurround.update_n_lines, { desc = 'Update `MiniSurround.config.n_lines`' })
--  H.map('x', m.add, [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = 'Add surrounding to selection' })

---   vim.keymap.set('n', 'yss', 'ys_', { remap = true })
-- vim.keymap.set('n', 'yss', '^ys$', { remap = true, desc = '󰅪 mini surround add line' })
-- vim.keymap.set(
--   { 'n' },
--   'ys',
--   [[:<C-u>lua MiniSurround.add('visual')<CR>]],
--   { silent = true, expr = true, desc = '󰅪 mini surround add visual selection' }
-- )

--- Regular mappings:
--- - `saiw)` - add (`sa`) for inner word (`iw`) parenthesis (`)`).
--- - `saiw?[[<CR>]]<CR>` - add (`sa`) for inner word (`iw`) interactive surrounding (`?`): `[[` for left and `]]` for right.
--- - `2sdf` - delete (`sd`) second (`2`) surrounding function call (`f`).
--- - `sr)tdiv<CR>` - replace (`sr`) surrounding parenthesis (`)`) with tag (`t`) with identifier 'div' (`div<CR>` in command line prompt).
--- - `sff` - find right (`sf`) part of surrounding function call (`f`).
--- - `sh}` - highlight (`sh`) for a brief period of time surrounding curly brackets (`}`).
---
--- Extended mappings (temporary force "prev"/"next" search methods):
--- - `sdnf` - delete (`sd`) next (`n`) function call (`f`).
--- - `srlf(` - replace (`sd`) last (`l`) function call (`f`) with padded bracket (`(`).
--- - `2sfnt` - find (`sf`) second (2) next (`n`) tag (`t`).
--- - `shl}` - highlight (`sh`) last (`l`) second (`2`) curly bracket (`}`).
---
-- - Covering match. Left/right edge is before/after left/right edge of reference region.
-- - Previous match. Left/right edge is before left/right edge of reference region.
-- - Next match. Left/right edge is after left/right edge of reference region.
-- - Nearest match. Whichever is closest among previous and next matches.
--
-- Possible values are:
-- - `'cover'` - use only covering match. Don't use either previous or next; report that there is no surrounding found.
-- - `'cover_or_next'` (default) - use covering match. If not found, use next.
-- - `'cover_or_prev'` - use covering match. If not found, use previous.
-- - `'cover_or_nearest'` - use covering match. If not found, use nearest.
-- - `'next'` - use next match.
-- - `'previous'` - use previous match.
-- - `'nearest'` - use nearest match.
