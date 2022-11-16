local structlog = require("structlog")
local logfile = vim.fn.stdpath("data") .. "/nvim.log"

local M = {}
M.console = function()
  return structlog.sinks.Console(structlog.level.WARN, {
    processors = {
      structlog.processors.Namer(),
      -- structlog.processors.Timestamper("%H:%M:%S"),
    },
    formatter = structlog.formatters.FormatColorizer(
      "[%s] %s: %-30s",
      { "level", "logger_name", "msg" },
      { level = structlog.formatters.FormatColorizer.color_level() }
    -- "%s [%s] %s: %-30s",
    -- { "timestamp", "level", "logger_name", "msg" },
    ),
  })
end

M.notify = function()
  return structlog.sinks.NvimNotify(structlog.level.WARN, {
    processors = {
      structlog.processors.Namer(),
    },
    formatter = structlog.formatters.Format("%s", { "msg" }, { blacklist = { "level", "logger_name" } }), --
    params_map = { title = "logger_name" },
  })
end

M.file = function()
  return structlog.sinks.File(structlog.level.TRACE, logfile, {
    processors = {
      structlog.processors.Namer(),
      -- structlog.processors.StackWriter({ "line", "file" }, {
      --   max_parents = 12,
      --   stack_level = 0,
      -- }),
      structlog.processors.Timestamper("%H:%M:%S"),
      function(_, kwargs)
        if type(kwargs["msg"]) == "table" then
          kwargs["msg"] = vim.inspect(kwargs["msg"])
        end
        return kwargs
      end,
    },
    formatter = structlog.formatters.Format("%s [%s] %s: %-30s", { "timestamp", "level", "logger_name", "msg" }, {
      level = structlog.formatters.FormatColorizer.color_level(),
    }),
  })
end

return M
