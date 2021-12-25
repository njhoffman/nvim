local M = require("mappings.mapper")

M.map("CommandWin", "c", "<c-s>", "save")
M.map("CommandWin", "c", "<c-y>", "yank")
M.map("CommandWin", "c", "<C-n>", "next1") -- virtual
M.map("CommandWin", "c", "<C-p>", "prev1") -- virtual
M.map("CommandWin", "c", "<tab>", "next2") -- virtual
M.map("CommandWin", "c", "<s-tab>", "prev2") -- virtual
