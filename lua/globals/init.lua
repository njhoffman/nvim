require("globals.impatient")
require("globals.importer")
vim.inspect = require("inspect")

vim.import("globals.variables")
vim.import("user-options")
vim.import("vim-options")

local debuglog = vim.import("debuglog")
vim.dbg = debuglog.dbg
vim.dbglog = debuglog.log
vim.dbgbuf = debuglog.buf
vim.dbgtime = debuglog.timer

local logger = vim.import("logger")
vim.logger = logger.init("root")
vim.notify = logger.notify
vim.notify(string.format("Initializing neovim at %s ... ", os.date("%H:%M:%S")), "debug")
