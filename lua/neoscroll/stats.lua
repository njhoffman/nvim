local history = {}
local state = { steps = {}, params = {}, start = nil, duration = nil }

local events = { 'WinScrolled', 'CursorMoved' }
-- local events = {}
local ts_ctx = require('treesitter-context')

local summarize_scroll = function(steps)
  local stats = { steps = '', time = 0, max = 0, min = nil, avg = 0, median = 0 }
  local time_steps = {}
  for _, step in ipairs(steps) do
    local time_step, to_scroll, lines, n = table.unpack(step)
    table.insert(time_steps, time_step)
    stats.time = stats.time + time_step
    if time_step > stats.max then
      stats.max = time_step
    end
    if not stats.min or time_step < stats.min then
      stats.min = time_step
    end
    stats.steps = stats.steps .. ' ' .. time_step
  end
  stats.avg = string.format('%.2f', (stats.time / #time_steps))
  stats.num = #time_steps
  table.sort(time_steps)
  stats.median = time_steps[math.floor(#time_steps / 2)]
  return stats
end

local hooks = {}
hooks.pre_hook = function(info, params)
  state.params = params
  state.start = vim.fn.reltime()

  vim.opt.eventignore:append(events)
  ts_ctx.disable()
end

hooks.steps_hook = function(...)
  table.insert(state.steps, {
    n = #state.steps + 1,
    ...,
  })
end

hooks.post_hook = function(info)
  -- vim.defer_fn(function()
  --   require('neoscroll').zz(zz_time_ms, easing)
  -- end, defer_time_ms)
  -- if info == 'centercursor' then
  --   vim.cmd('normal zz')
  -- end

  vim.opt.eventignore:remove(events)
  ts_ctx.enable()

  if #state.steps > 0 then
    state.duration = table.insert(history, {
      n = #history + 1,
      duration = vim.fn.reltimestr(vim.fn.reltime(state.start)),
      info = info,
      steps = summarize_scroll(state.steps),
      params = state.params,
    })
    state.steps = {}
    state.params = {}
  end
end

return {
  history = history,
  state = state,
  hooks = hooks,
}

-- The `defer_fn` is a bit of a hack.
-- We use it so that `neoscroll.init.scroll` will be false when we call `neoscroll.zz`
-- As long as we don't input another neoscroll mapping in the timeout,
-- we should be able to center the cursor.
-- local easing = 'sine'
-- local zz_time_ms = 100
-- local jump_time_ms = 200
-- local defer_time_ms = 10
