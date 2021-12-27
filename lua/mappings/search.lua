local M = require("mappings.mapper")

-- vim.cmd([[nnoremap / /\v]])
-- vim.cmd([[vnoremap / /\v]])
-- vim.cmd([[cnoremap %s/ %smagic/]])
-- vim.cmd([[cnoremap \>s/ \>smagic/]])

-- vim.cmd([[nnoremap :g/ :g/\v]])
-- vim.cmd([[nnoremap :g// :g//]])
-- vim.cmd([[vnoremap :g// :g//]])
-- let g:VeryMagic = 0
-- nnoremap / /\v
-- nnoremap ? ?\v
-- vnoremap / /\v
-- vnoremap ? ?\v
-- " If I type // or ??, I don't EVER want \v, since I'm repeating the previous
-- " search.
-- noremap // //
-- noremap ?? ??
-- " no-magic searching
-- noremap /v/ /\V
-- noremap ?V? ?\V
M.map("Search", "n", "/", "search_magic_1")
M.map("Search", "v", "/", "search_magic_2")
M.map("Search", "c", "%s/", "sub_magic_1")
M.map("Search", "n", "<M-S>", "sub_magic_3")
M.map("Search", "v", "<M-S>", "sub_magic_4")
-- ,/ : toggle whole word matching
-- ,/ visual block search within
-- ClearAllButMatches, SearchForAnyLine
-- visual g* g# to search for selected text
-- Substituting
-- Visual && to do :&& on selected text (repeat last substitute with the same flags).

-- Make g& work how you'd expect on visual selections: only act on the visual selection.
-- Unlike &&, it uses the current search query.
M.map("Search", "n", "_", "rmhl")
M.map("Search", "n", "<M-_>", "rmhl_refresh")
M.map("Search", "n", "n", "next")
M.map("Search", "n", "N", "prev")
M.map("Search", "n", "*", "cursor_next1")
M.map("Search", "n", "#", "cursor_prev1")
M.map("Search", "n", "g*", "cursor_next2")
M.map("Search", "n", "g#", "cursor_prev2")
M.map("Search", "n", "gn", "last_match")
M.map("Search", "n", "<leader>sr", "cursor_replace")
