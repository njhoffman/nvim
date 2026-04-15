-- profiling startup setup: PROF=1 nvim
if vim.env.PROF then
  local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  if snacks then
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup({
      startup = { event = "VimEnter" },
    })
  end
end

-- global require handler
require("globals.importer")
vim.import("globals.variables")
vim.import("user-options")
vim.import("vim-options")
vim.import("neovide")

local _nil = function()
  return nil
end

-- setup lodash global
vim._ = require("lodash")

-- Wire the debug helpers from logger.debug onto the vim table
local debuglog = vim.import("logger.debug")
if debuglog then
  vim.inspect = debuglog.inspect or vim.inspect
  vim.dbg = debuglog.dbg or _nil()
  vim.dbglog = debuglog.log or _nil()
  vim.dbgbuf = debuglog.buf or _nil()
  vim.dbgtime = debuglog.timer or _nil()
  vim.print = debuglog.dbg

  local log_lines = function(lines)
    debuglog.log(type(lines) == "string" and lines or table.concat(lines, "\n  "))
  end

  vim.dbgout = {}
  vim.dbgout.dump = function(val, indent, padding, filter, udata)
    log_lines(debuglog.dump(val, indent, padding, filter, udata))
  end

  vim.dbgout.ns = function()
    log_lines(debuglog.namespaces({ buf = -1, show_extmarks = false }))
  end

  vim.dbgout.buf = function()
    log_lines(debuglog.namespaces({ buf = 0, show_extmarks = false }))
  end

  vim.dbgout.extmarks = function(ns)
    log_lines(debuglog.namespaces({ buf = -1, show_extmarks = true, ns = ns }))
  end

  vim.dbgout.extmarks_buf = function(ns)
    log_lines(debuglog.namespaces({ buf = 0, show_extmarks = true, ns = ns }))
  end
end

-- luacheck: globals RELOAD R
RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(...)
  RELOAD(...)
  return require(...)
end
