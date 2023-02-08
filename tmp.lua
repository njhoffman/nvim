local dump = require("globals.dump")
local obj = vim.lsp.get_active_clients()
vim.dbglog(dump(obj))
