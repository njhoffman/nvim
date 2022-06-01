-- only logger
-- logger + notify
-- debug logger + notify

local log = require("debuglog")
local obj = vim.lsp.log_levels

-- debug logger with text
-- for lvl in "trace debug info warn error" do
for _, lvl in ipairs({ "trace", "debug", "info", "warn", "error" }) do
  local level = string.upper(lvl)
  log[lvl]("TESTING " .. level)
end

-- debug logger with obj
for _, lvl in ipairs({ "trace", "debug", "info", "warn", "error" }) do
  log[lvl](obj)
end

-- debug logger with string and obj
for _, lvl in ipairs({ "trace", "debug", "info", "warn", "error" }) do
  local level = string.upper(lvl)
  log[lvl]("TABLE " .. level, obj)
end

-- debug logger with  table
for _, lvl in ipairs({ "trace", "debug", "info", "warn", "error" }) do
  local level = string.upper(lvl)
  log[lvl]({ "TABLE " .. level, obj })
end

vim.logger:trace("test")
vim.logger:info("info test")
vim.logger:error("error test")
