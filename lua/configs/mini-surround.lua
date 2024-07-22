-- https://github.com/echasnovski/mini.nvim/pull/566
-- https://github.com/echasnovski/mini.nvim/issues/191
-- https://github.com/echasnovski/mini.nvim/issues/770
-- When using blockwise mode and respect_selection_type, multiline selections aren't properly highlighted
---@diagnostic disable-next-line: unused-local
local default_cfg = {
  custom_surroundings = nil,
  highlight_duration = 500,
  mappings = {
    add = "sa", -- Add surrounding in Normal and Visual modes
    delete = "sd", -- Delete surrounding
    find = "sf", -- Find surrounding (to the right)
    find_left = "sF", -- Find surrounding (to the left)
    highlight = "sh", -- Highlight surrounding
    replace = "sr", -- Replace surrounding
    update_n_lines = "sn", -- Update `n_lines`

    suffix_last = "l", -- Suffix to search with "prev" method
    suffix_next = "n", -- Suffix to search with "next" method
  },
  n_lines = 20,
  respect_selection_type = false,
  search_method = "cover_or_next",
  -- 'cover', 'cover_or_next', 'cover_or_prev',
  -- 'cover_or_nearest', 'next', 'prev', 'nearest'
}

---@diagnostic disable-next-line: unused-local
-- local vim_surround = {
--   mappings = { add = 'ys', delete = 'ds', find = '', find_left = '', highlight = '', replace = 'cs', update_n_lines = '', suffix_last = '', suffix_next = '', }, search_method = 'cover_or_next',
-- }

-- TODO: yank surround text-obj
-- TODO: n/N traverses them

local custom_surroundings = {
  -- Lua long brackets - ysiwS
  B = {
    -- Configuration for "input" (like for delete) is done with Lua patterns
    input = { find = "%[%[.-%]%]", extract = "^(..).*(..)$" },
    -- Configuration for "output" (like for add) is done with plain text
    output = { left = "[[", right = "]]" },
  },
  -- Use `(` to insert with spaces, `)` will still add without them
  ["("] = { output = { left = "( ", right = " )" } },
}

-- stylua: ignore
local cfg = {
  -- custom_surroundings = custom_surroundings,
  mappings = {
    add               = 's', -- Add surrounding in Normal and Visual modes
    delete            = 'ds', -- Add surrounding in Normal and Visual modes
    replace           = 'cs', -- Replace surrounding
    find              = 'sf', -- Find surrounding (to the right) (dot repeat)
    find_left         = 'sF', -- Find surrounding (to the left) (dot repeat)
    -- highlight         = 'ghis', -- Highlight surrounding
    highlight         = 'sh', -- Highlight surrounding
    update_n_lines    = '',
    -- update_n_lines = 'sn', -- Update `n_lines`
    suffix_last       = 'N', -- Suffix to search with "prev" method
    suffix_next       = 'n', -- Suffix to search with "next" method
    -- suffix_last = 'l', -- Suffix to search with "prev" method
    -- suffix_next = 'n', -- Suffix to search with "next" method
  },
  highlight_input = true,
  highlight_duration = 400,
  n_lines = 40,
  respect_selection_type = true,
  search_method = 'cover_or_next',
  -- search_method = 'cover_or_nearest',
  silent = false,
}

--stylua: ignore
require('mini.surround').setup(cfg)

local extra_mappings = function()
  local get_opts = function(desc)
    return { silent = true, remap = true, desc = desc }
  end
  local map = vim.keymap.set
  -- vim.keymap.set('x', 'ys', 's', { silent = true, remap = true, desc = '󰅪 mini surround add visual selection' })
  -- vim.keymap.set('x', 'ys', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
  map("n", "ys", "s", get_opts("󰅪 mini surround add operator"))
  map("n", "yS", "ys$", get_opts("󰅪 mini surround to end of line"))
  map("n", "sS", "s0", get_opts("󰅪 mini surround to begin of line"))
  map("n", "yss", "^ys$", get_opts("󰅪 mini surround add line"))
  map(
    "n",
    "s<space>",
    "<cmd>execute 'normal hwst )<esc>'<cr>",
    get_opts("󰅪 mini surround quick add")
  )
  -- vim.keymap.set('n', 'yss', 'ys_', { remap = true })
  -- lua vim.cmd ("execute 'silent! normal hwst )<esc>'")
  -- execute "silent! normal hwst\<space>)\\<esc>"
  -- vim.cmd("execute normal 'hwst ' . nr2char(getchar()) . '<esc>'"),
  -- execute "silent! normal hwst\<space>)" | execute "normal <esc>"
  -- "<cmd>execute 'silent! normal hwst )" .. vim.fn.nr2char(vim.fn.getchar()) .. "'<cr>",
  map("n", "ss", "<cmd>execute 'normal hwst ('<cr>", get_opts("󰅪 mini surround quick add word"))
end

-- silent! normal hwst (<esc>
-- <Cmd>execute "silent! normal hwst\ " . nr2char(getchar()) . "<Esc>"<CR>
-- <Cmd>execute "silent! normal hwst " . nr2char(getchar()) . "<Esc>"<CR>

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
--  `'cover'` - use only covering match. Don't use either previous or next; report that there is no surrounding found.
--  `'cover_or_next'` (default) - use covering match. If not found, use next.
--  `'cover_or_prev'` - use covering match. If not found, use previous.
--  `'cover_or_nearest'` - use covering match. If not found, use nearest.
--  `'next'` - use next match.
--  `'previous'` - use previous match.
--  `'nearest'` - use nearest match.
