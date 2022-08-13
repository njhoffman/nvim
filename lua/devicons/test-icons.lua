#!/usr/bin/env lua

local devicons = require('devicons')
-- for _, file in ipairs(files) do
--   devicons.get_icon(file)
-- end
-- vim.dbgtime('test')
-- vim.fn.timer_start(3000, function()
--   vim.dbgtime('test')
-- end)
--
local stdin = io.stdin:lines()
local stdout = io.write
for line in stdin do
  stdout(line)
end
