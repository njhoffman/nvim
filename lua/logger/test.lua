local M = {}
local logger = require('logger').init('test')
local obj = vim.lsp.handlers

local levels = { 'trace', 'debug', 'info', 'warn', 'error' }

-- debug logger with text
-- for lvl in "trace debug info warn error" do
for _, lvl in ipairs(levels) do
  local level = string.upper(lvl)
  logger[lvl]('TESTING ' .. level)
end

-- debug logger with obj
for _, lvl in ipairs(levels) do
  M.log[lvl](obj)
end

-- debug logger with string and obj
for _, lvl in ipairs(levels) do
  local level = string.upper(lvl)
  logger[lvl]('TABLE ' .. level, obj)
end

-- debug logger with  table
for _, lvl in ipairs(levels) do
  local level = string.upper(lvl)
  logger[lvl]({ 'TABLE ' .. level, obj })
end
