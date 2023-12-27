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

-- stylua: ignore
local cfg = {
  -- custom_surroundings = custom_surroundings,
  mappings = {
    add               = 's', -- Add surrounding in Normal and Visual modes
    delete            = 'ds', -- Add surrounding in Normal and Visual modes
    replace           = 'cs', -- Replace surrounding
    find              = 'sf', -- Find surrounding (to the right)
    find_left         = 'sF', -- Find surrounding (to the left)
    highlight         = 'sh', -- Highlight surrounding
    update_n_lines    = '',
    -- update_n_lines = 'sn', -- Update `n_lines`
    suffix_last       = '', -- Suffix to search with "prev" method
    suffix_next       = '', -- Suffix to search with "next" method
    -- suffix_last = 'l', -- Suffix to search with "prev" method
    -- suffix_next = 'n', -- Suffix to search with "next" method
  },
  highlight_duration = 400,
  n_lines = 50,
  respect_selection_type = true,
  search_method = 'cover_or_next',
  silent = true,
}

--stylua: ignore
require('mini.surround').setup(cfg)
-- vim.keymap.set('x', 'ys', 's', { silent = true, remap = true, desc = '󰅪 mini surround add visual selection' })
-- vim.keymap.set('x', 'ys', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
vim.keymap.set('n', 'ys', 's', { silent = true, remap = true, desc = '󰅪 mini surround add operator' })
vim.keymap.set('n', 'yS', 'ys$', { silent = true, remap = true, desc = '󰅪 mini surround to end of line' })
vim.keymap.set('n', 'sS', 's0', { silent = true, remap = true, desc = '󰅪 mini surround to begin of line' })
vim.keymap.set('n', 'yss', '^ys$', { silent = true, remap = true, desc = '󰅪 mini surround add line' })
-- vim.keymap.set('n', 'yss', 'ys_', { remap = true })
vim.keymap.set(
  'n',
  's<space>',
  '<cmd>execute "normal hwst\\<space>" . nr2char(getchar()) . "\\<lt>esc>"<cr>',
  { silent = true, remap = true, desc = '󰅪 mini surround quick add word' }
)

vim.keymap.set(
  'n',
  'ss',
  '<cmd>execute "normal hwst\\<space>" . nr2char(getchar()) . "\\<lt>esc>"<cr>',
  { silent = true, remap = true, desc = '󰅪 mini surround quick add word' }
)
-- vim.cmd([[ noremap <silent> ss :execute "normal hwst\<space>" . nr2char(getchar()) . "\<lt>esc>"<cr> ]])
--- Regular mappings:
--- - `siw)` - add (`s`) for inner word (`iw`) parenthesis (`)`).
--- - `siw?[[<CR>]]<CR>` - add (`s`) for inner word (`iw`) interactive surrounding (`?`): `[[` for left and `]]` for right.
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
