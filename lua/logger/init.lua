local M = {}
local log = require("structlog")
local logfile = vim.fn.stdpath("data") .. "/nvim.log"
local notify = require('logger.notify').notify

local console_sink = function()
  return log.sinks.Console(
    log.level.WARN,
    {
      processors = {
        log.processors.Namer()
        -- log.processors.Timestamper("%H:%M:%S"),
      },
      formatter = log.formatters.FormatColorizer(
        "[%s] %s: %-30s",
        { "level", "logger_name", "msg" },
        { level = log.formatters.FormatColorizer.color_level() }
      -- "%s [%s] %s: %-30s",
      -- { "timestamp", "level", "logger_name", "msg" },
      )
    }
  )
end

local notify_sink = function()
  return log.sinks.NvimNotify(
    log.level.WARN,
    {
      processors = {
        log.processors.Namer()
      },
      formatter = log.formatters.Format("%s", { "msg" }, { blacklist = { "level", "logger_name" } }), --
      params_map = { title = "logger_name" }
    }
  )
end

local file_sink = function()
  return log.sinks.File(
    log.level.TRACE,
    logfile,
    {
      processors = {
        log.processors.Namer(),
        log.processors.StackWriter({ "line", "file" }, { max_parents = 12, stack_level = 0 }),
        log.processors.Timestamper("%H:%M:%S")
      },
      formatter = log.formatters.Format(
      --
        "%s [%s] %s: %-30s",
        { "timestamp", "level", "logger_name", "msg" },
        { level = log.formatters.FormatColorizer.color_level() }
      )
    }
  )
end

M.init = function(name)
  name = name or "root"
  log.configure(
    {
      [name] = {
        sinks = {
          -- console_sink,
          -- notify_sink,
          file_sink()
        }
      }
    }
  )
  return log.get_logger(name)
end

M.notify = notify

return M
