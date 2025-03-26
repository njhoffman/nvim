-- debugging init scripts
-- require('globals.record-events')
-- require('globals.overrides')

-- profiling startup setup : PROF=1 nvim
if vim.env.PROF then
  local local_path = vim.fn.getenv("home") .. "/git/snacks.nvim"
  local lazy_path = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
  local snacks = vim.fn.isdirectory(local_path) == 1 and local_path
    or vim.fn.isdirectory(lazy_path) and lazy_path
  if snacks then
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup({
      startup = {
        event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
        -- event = "UIEnter",
        -- event = "VeryLazy",
      },
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

local lodash = require("lodash")
vim._ = lodash

local debuglog = vim.import("debuglog")
if debuglog then
  vim.dbg = debuglog.dbg or _nil()
  vim.dbglog = debuglog.log or _nil()
  vim.dbgbuf = debuglog.buf or _nil()
  vim.dbgtime = debuglog.timer or _nil()
  vim.print = debuglog.dbg
  -- vim.dbg.log = vim.dbglog
  -- vim.inspect = debuglog.dump or vim.inspect

  local log_lines = function(lines)
    debuglog.log(type(lines) == "string" and lines or table.concat(lines, "\n  "))
  end

  vim.dbgout = {}
  vim.dbgout.dump = function(val, indent, padding, filter, udata)
    log_lines(debuglog.dump(val, indent, padding, filter, udata))
  end

  vim.dbgout.ns = function()
    log_lines(debuglog.namespaces({ buf_id = -1, show_extmarks = false }))
  end

  vim.dbgout.buf = function()
    log_lines(debuglog.namespaces({ buf_id = 0, show_extmarks = false }))
  end

  vim.dbgout.extmarks = function(ns)
    log_lines(debuglog.namespaces({ buf_id = -1, show_extmarks = true, ns = ns }))
  end

  vim.dbgout.extmarks_buf = function(ns)
    log_lines(debuglog.namespaces({ buf_id = 0, show_extmarks = true, ns = ns }))
  end
end

N = vim.dbg

D = vim.dbglog

RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(...)
  RELOAD(...)
  return require(...)
end

-- setup module helpers to attach to lodash global
-- --stylua: ignore
-- local mods_map = {
--   -- { "buffers",    "buf", "Buffers functions" },
--   { require('globals.mods.windows'),    "win", "Windows functions" },
--   -- { "treesitter", "ts",  "Treesiter helpers" },
--   -- { "extmarks",   "ext", "Highlights and extmarks" },
--   -- { "trace",      "tr", "Tracing functions and utilities" },
-- }

-- for i, modkeys in ipairs(mods_map) do
--   mods[i][4] = win_fns
-- end

-- _G._mods = mods

-- local logger = vim.import('logger')
-- if logger ~= nil and logger.init ~= nil then
--   vim.logger = logger.init('root')
--   vim.notify = logger.notify
-- end

-- _ = require("lodash")
