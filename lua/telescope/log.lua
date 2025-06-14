local plenary_log = require("plenary.log").new({ plugin = "telescope", level = "info" })

local log = function(lvl, ...)
  -- notify(message, vim.log.levels.ERROR)
  if lvl ~= "trace" then
    vim.dbglog(lvl .. " ", ...)
  end
  plenary_log[lvl](...)
end

local M = {}
M.trace = function(...)
  log("trace", ...)
end

M.debug = function(...)
  log("debug", ...)
end

M.info = function(...)
  log("info", ...)
end

M.warn = function(...)
  log("warn", ...)
end

M.error = function(...)
  log("error", ...)
end

return M
