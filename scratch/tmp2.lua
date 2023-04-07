local start = vim.fn.reltime()

vim.dbglog(vim.fn.reltimestr(vim.fn.reltime(start)))
