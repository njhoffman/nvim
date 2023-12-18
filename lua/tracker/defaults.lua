local debuglog = require('debuglog').log
local output = require('tracker.output')

local defaults = {}
defaults.output = function(source, opts, delta)
  if #delta.added > 0 or #delta.removed > 0 then
    local props = {
      name = source.name,
      icon = source.icon,
      label = source.label,
      desc_fields = source.desc_fields,
    }
    if opts.only_metrics then
      output.output_metric(props, delta)
    else
      output.output_diff(props, delta)
    end
  end
end

defaults.diff = function(source, opts)
  return function()
    local diff = require('tracker.diff.delta')
    local state = require('tracker.state')
    local p_state = state.history[source.name] or {}
    local start = vim.fn.reltime()
    local delta = { added = {}, removed = {} }
    if type(p_state.time_get) == 'nil' then
      p_state.time_get = 0
      p_state.time_diff = 0
      p_state.prev_items = diff.serialize_data(source.get(), source.id_fields)
    else
      p_state.time_get = vim.fn.reltimestr(vim.fn.reltime(start)) * 100000
      start = vim.fn.reltime()
      local curr_items = diff.serialize_data(source.get(), source.id_fields)
      delta = diff.get_diff(p_state.prev_items, curr_items)
      p_state.time_diff = vim.fn.reltimestr(vim.fn.reltime(start)) * 100000
      p_state.prev_items = curr_items
    end
    if type(source.output) == 'function' then
      source.output(opts, delta)
    else
      defaults.output(source, opts, delta)
    end
    state.history[source.name] = p_state
  end
end

defaults.init = function(source, opts)
  local state = require('tracker.state')
  if state.initialized[source.name] == true then
    vim.notify('source ' .. source.name .. ' already initialized')
    return
  end
  local timer = vim.fn.timer_start(
    opts.interval or 1000,
    type(source.diff) == 'function' and source.diff(opts) or defaults.diff(source, opts),
    { ['repeat'] = -1 }
  )
  if type(state.timers[source.name]) == 'nil' then
    state.timers[source.name] = {}
  end
  table.insert(state.timers[source.name], timer)
  state.initialized[source.name] = true
  debuglog('monitoring ' .. source.name)
end

return defaults
