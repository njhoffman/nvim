require("globals.importer")

vim.import("globals.variables")
vim.import("user-options")
vim.import("vim-options")

local _nil = function()
  return nil
end

local debuglog = vim.import("debuglog")
if debuglog then
  vim.dbg = debuglog.dbg or _nil()
  vim.dbglog = debuglog.log or _nil()
  vim.dbgbuf = debuglog.buf or _nil()
  vim.dbgtime = debuglog.timer or _nil()
  -- vim.inspect = debuglog.dump or vim.inspect
  vim.dump = debuglog.dump
end

local logger = vim.import("logger")
if logger ~= nil and logger.init ~= nil then
  vim.logger = logger.init("root")
  vim.notify = logger.notify
end

-- vim.notify(string.format("Initializing neovim at %s ... ", os.date("%H:%M:%S")), "debug")
