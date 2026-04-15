local function test_outputs(logger)
  local levels = { "trace", "debug", "info", "warn", "error" }
  local obj = vim.lsp.handlers
  for _, lvl in ipairs(levels) do
    -- debug logger with text
    -- for lvl in "trace debug info warn error" do
    if logger and type(logger[lvl]) == "function" then
      local level = string.upper(lvl)
      logger[lvl]("TESTING " .. level)
      -- debug logger with obj
      logger[lvl](obj)
      -- debug logger with string and obj
      logger[lvl]("TABLE " .. level, obj)
      -- debug logger with  table
      logger[lvl]({ "TABLE " .. level, obj })
    end
  end
end

local function test_level_change(logger)
  local function log_event()
    logger:info("info event")
    logger:debug("debug event")
    logger:trace("trace event")
    -- vim.dbglog(logger.sinks[1].name, logger.sinks[1].level)
    vim.defer_fn(log_event, 3000)
  end

  if logger then
    vim.defer_fn(log_event, 3000)
  end
end

local logger = require("logger").init("test")
test_outputs(logger)
test_level_change(logger)
