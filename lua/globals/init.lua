-- debugging init scripts
-- require('globals.record-events')
-- require('globals.overrides')

-- global require handler
require("globals.importer")
vim.import("globals.variables")
vim.import("user-options")
vim.import("vim-options")
vim.import("neovide")

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

  local log_lines = function(lines)
    debuglog.log(type(lines) == "string" and lines or table.concat(lines, "\n  "))
  end

  vim._log_dump = function(val, indent, padding, filter, udata)
    log_lines(debuglog.dump(val, indent, padding, filter, udata))
  end

  vim._log_ns = function()
    log_lines(debuglog.namespaces({ buf_id = -1, show_extmarks = false }))
  end

  vim._log_buf = function()
    log_lines(debuglog.namespaces({ buf_id = 0, show_extmarks = false }))
  end

  vim._log_extmarks = function(ns)
    log_lines(debuglog.namespaces({ buf_id = -1, show_extmarks = true, ns = ns }))
  end

  vim._log_extmarks_buf = function(ns)
    log_lines(debuglog.namespaces({ buf_id = 0, show_extmarks = true, ns = ns }))
  end
end

-- local logger = vim.import('logger')
-- if logger ~= nil and logger.init ~= nil then
--   vim.logger = logger.init('root')
--   vim.notify = logger.notify
-- end

N = vim.dbg

D = vim.dbglog

RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(...)
  RELOAD(...)
  return require(...)
end
