local tmp = { 3, 4 }

local test
local test2
test, test2 = unpack(tmp)

vim.dbglog(test, test2)
