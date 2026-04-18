--- The logger package.

--- The logger class.
-- @type Logger
local Logger = {}
Logger.__index = Logger

--- Create a new logger.
-- @function Logger
-- @param name The name of the logger
-- @param sinks The list of sinks to write the log entries in
setmetatable(Logger, {
  __call = function(cls, ...)
    return cls:new(...)
  end,
})

local Level = require("logger.structlog.level")
local pattern_filter = require("logger.structlog.pattern")

local levels = { "trace", "debug", "info", "warn", "error" }

local function handle_sink(logger, kwargs, msg, level)
  kwargs.msg = msg
  for _, sink in ipairs(logger.sinks or {}) do
    local sink_args = vim.deepcopy(kwargs)
    for _, processor in ipairs(sink.processors) do
      sink_args = processor(logger, kwargs)
    end
    sink_args = sink.formatter(sink_args)

    if level >= sink.level and sink.level ~= -1 then
      sink:write(sink_args)
    end
  end
end

local function log(logger, level, msg, events)
  if pattern_filter(logger.name, level, msg) then
    return false
  end

  local kwargs = {
    level = Level.name(level),
    events = events or {},
  }
  for key, value in pairs(logger.context or {}) do
    kwargs[key] = value
  end
  handle_sink(logger, kwargs, msg, level)
end

function Logger:new(name, sinks)
  local logger = setmetatable({
    name = name,
    sinks = sinks,
    context = {},
  }, Logger)

  for _, lvl in ipairs(levels) do
    local level_const = Level[lvl:upper()]
    logger[lvl] = function(first, msg, events)
      if first == logger then
        log(logger, level_const, msg, events)
      else
        log(logger, level_const, first, msg)
      end
    end
  end

  return logger
end

function Logger:clone()
  local logger = self:new(self.name, self.sinks)
  logger.context = vim.deepcopy(self.context)

  return logger
end

function Logger:log(level, msg, events)
  log(self, level, msg, events)
end

return Logger
