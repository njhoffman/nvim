local structlog = require("logger.structlog")
local logfile = vim.fn.stdpath("data") .. "/nvim.log"

local init = function(name)
  name = name or "watcher"
  structlog.configure({
    [name] = {
      sinks = {
        structlog.sinks.File(structlog.level.TRACE, logfile, {
          processors = {
            structlog.processors.Namer(),
            structlog.processors.StackWriter({ "line", "file" }, {
              max_parents = 12,
              stack_level = 0,
            }),
            structlog.processors.Timestamper("%H:%M:%S"),
            function(_, kwargs)
              if type(kwargs["msg"]) == "table" then
                kwargs["msg"] = vim.inspect(kwargs["msg"])
              end
              return kwargs
            end,
          },
          formatter = structlog.formatters.Format(
            "%s [%s] %s: %-30s",
            { "timestamp", "level", "logger_name", "msg" },
            {
              level = structlog.formatters.FormatColorizer.color_level(),
            }
          ),
        }),
      },
    },
  })
  return structlog.get_logger(name)
end

local logger = init()
logger.init = init

return logger
