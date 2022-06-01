local M = {}
M.log = require("logger").init("test")

local obj = vim.lsp.log_levels
-- debug logger with text
-- for lvl in "trace debug info warn error" do
for _, lvl in ipairs({ "trace", "debug", "info", "warn", "error" }) do
  local level = string.upper(lvl)
  M.log[lvl]("TESTING " .. level)
end

-- debug logger with obj
for _, lvl in ipairs({ "trace", "debug", "info", "warn", "error" }) do
  M.log[lvl](obj)
end

-- debug logger with string and obj
for _, lvl in ipairs({ "trace", "debug", "info", "warn", "error" }) do
  local level = string.upper(lvl)
  M.log[lvl]("TABLE " .. level, obj)
end

-- debug logger with  table
for _, lvl in ipairs({ "trace", "debug", "info", "warn", "error" }) do
  local level = string.upper(lvl)
  M.log[lvl]({ "TABLE " .. level, obj })
end
