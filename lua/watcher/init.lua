local config = { interval = 3000, list = {} }
-- local get_changelist = require('watcher.changelist')

local envlist = {
  ["FONT_SIZE"] = 8.5,
  ["PWD"] = '/home/nicholas/bin',
  ["ZCONVEY_ID"] = 29
}


local get_envlist = function()
  return envlist
end

local watch_list = function()
  local curr = get_envlist()
  for i, line in pairs(curr) do
    vim.notify(line)
  end
end

local timer = vim.fn.timer_start(
  config.interval, watch_list, { ["repeat"] = -1 }
)
