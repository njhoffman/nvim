local differ = require('watcher.differ')
local config = require('watcher.opts')
local logger = require('watcher.logger')
local output = require('watcher.output')

if not vim.g.watchertimers then
  vim.api.nvim_set_var('watchertimers', {})
end

local difflist = { curr = nil, prev = nil, timers = {} }
difflist.timers = vim.api.nvim_get_var('watchertimers') or {}


local check_list = function(list)
  logger = logger.init(list.name)
  return function()
    difflist.curr = list.get_data()
    vim.dbglog('got list data for ' .. list.name .. ' - ' .. #vim.fn.keys(difflist.curr) .. ' items')
    -- no need to calculate on first pass
    if difflist.prev == nil then
      difflist.prev = difflist.curr
      return false
    end

    local diffs = differ.get_diff(difflist.curr, difflist.prev) or {}
    if diffs.total == 0 then
      vim.dbglog('no differences for ' .. list.name)
    else
      vim.dbglog(diffs.total .. 'diffs in list: ' .. list.name)
    end
    difflist.prev = difflist.curr
    output.diff(diffs)
  end
end

local clear_timers = function()
  local global_timers = vim.fn.timer_info()

  for i, timer in pairs(difflist.timers) do
    logger:debug('stopping timer id: ' .. i .. ' out of ' .. #global_timers)
    vim.fn.timer_stop(timer)
    table.remove(difflist.timers, timer)
  end
end

local create_timer = function(list)
  local timer = vim.fn.timer_start(
    config.interval,
    check_list(list),
    { ["repeat"] = -1 }
  )

  logger:debug('created timer: ' .. timer .. ' for ' .. list.name)
  table.insert(difflist.timers, timer)
  vim.api.nvim_set_var('watchertimers', difflist.timers)
end

return {
  clear_timers = clear_timers,
  create_timer = create_timer,
}
