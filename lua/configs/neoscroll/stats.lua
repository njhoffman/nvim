local history = {}

local summarize_scroll = function(steps, params)
  local stats = {
    steps = '',
    time = 0,
    max = nil,
    min = nil,
    avg = 0,
    median = 0,
  }
  local time_steps = {}

  for _, step in ipairs(steps) do
    local time_step, to_scroll, lines, n = table.unpack(step)
    table.insert(time_steps, time_step)
    stats.time = stats.time + time_step
    if type(stats.max) ~= 'number' or time_step > stats.max then
      stats.max = time_step
    end
    if type(stats.min) ~= 'number' or time_step < stats.min then
      stats.min = time_step
    end
    stats.steps = stats.steps .. ' ' .. time_step
  end
  stats.avg = params.lines / (stats.time / 1000)
  stats.num = #time_steps
  table.sort(time_steps)
  stats.median = time_steps[math.floor(#time_steps / 2)]
  return stats
end

return { summarize_scroll = summarize_scroll, history = history }

-- The `defer_fn` is a bit of a hack.
-- We use it so that `neoscroll.init.scroll` will be false when we call `neoscroll.zz`
-- As long as we don't input another neoscroll mapping in the timeout,
-- we should be able to center the cursor.
-- local easing = 'sine'
-- local zz_time_ms = 100
-- local jump_time_ms = 200
-- local defer_time_ms = 10
