-- :let newItems = [{'filename' : 'a.txt', 'lnum' : 10, 'text' : "Apple"},
--   \ {'filename' : 'b.txt', 'lnum' : 20, 'text' : "Orange"}]
-- :call setqflist([], 'a', {'id' : qfid, 'items' : newItems})
-- local histories = require('telescope.actions.history')
-- vim.dbglog(entries:get())

-- 27

-- pcall(require('telescope').load_extension, 'smart_history')
-- local opts = { cache_index = 2 }
local opts = {}
require('telescope.run')('builtin', 'pickers', opts)
