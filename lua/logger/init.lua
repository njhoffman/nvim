local ok, structlog = pcall(require, 'structlog')
if not ok then return {} end

local sinks = require('logger.sinks')
local M = {}
M.init = function(name)
  name = name or "root"
  structlog.configure(
    {
      [name] = {
        sinks = {
          sinks.file()
        }
      }
    }
  )
  return structlog.get_logger(name)
end

M.notify = require('logger.notify').notify

return M
