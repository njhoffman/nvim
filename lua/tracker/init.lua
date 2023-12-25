local defaults = require('tracker.defaults')
local sources = require('tracker.sources')
local log = require('debuglog').log

local get_func = function(self, name)
  return type(self[name]) == 'function' and self[name] or defaults[name]
end

local calculate_diff = function(self)
  local opts = self._opts or {}
  local state = require('tracker.state')
  local p_state = state.history[self.name]
    or {
      time_get = 0,
      time_diff = 0,
      prev_items = {},
      col_lengths = {},
    }

  local start = vim.fn.reltime()
  local items = self.get(self)
  p_state.time_get = vim.fn.reltimestr(vim.fn.reltime(start)) * 100000
  local id_fields = self.id_fields or vim.tbl_keys(items[1])

  start = vim.fn.reltime()
  local curr_items = get_func(self, 'serialize')(items, id_fields)
  local delta = get_func(self, 'diff')(p_state.prev_items, curr_items)
  p_state.time_diff = vim.fn.reltimestr(vim.fn.reltime(start)) * 100000
  p_state.prev_items = curr_items
  -- opts.col_lengths = p_state.col_lengths
  state.history[self.name] = p_state
  return delta
end

local setup_timer = function(opts)
  local state = require('tracker.state')
  local timer_interval = 1000
  local n = timer_interval
  local max_interval = timer_interval

  local timer_handler = function()
    for _, timer in ipairs(state.timers) do
      local interval, source = timer[1], timer[2]
      max_interval = math.max(interval, max_interval)
      if n % interval == 0 then
        local delta = calculate_diff(source)
        get_func(source, 'output')(source, delta)
      end
    end
    n = max_interval - timer_interval == n and timer_interval or n + timer_interval
  end
  local timer = state.timers['main'] or {}
  timer.id = vim.fn.timer_start(timer_interval, timer_handler, { ['repeat'] = -1 })
end

local stop_timer = function()
  local state = require('tracker.state')
  local timer = state.timers['main'] or {}
  if timer.id then
    vim.fn.timer_stop(timer.id)
  end
end

local load_sources = function(sources_list, opts)
  local state = require('tracker.state')
  for name, source_cfg in pairs(sources_list) do
    local source = sources[name]
    if state.initialized[name] == true then
      vim.notify('source ' .. name .. ' already initialized')
    else
      opts = vim.tbl_deep_extend('force', opts or {}, source_cfg or {})
      source._opts = opts
      local init_func = source.init or defaults.init
      local timer_interval = init_func(source)
      if timer_interval then
        table.insert(state.timers, { timer_interval, source })
      end
      state.initialized[name] = true
      local results = source:get()
      log('monitoring ' .. #results .. ' ' .. (source.label or source.name))
    end
  end
end

local setup = function(opts)
  -- local opts = config.setup(_opts)
  local opts = opts or {}
  load_sources(opts.lists, opts.defaults)
  -- load_sources(opts.counts, opts, true)
  setup_timer(opts)
  -- vim.keymap.set("n", lhs, commands[key], { noremap = true })
end

return { setup = setup }
