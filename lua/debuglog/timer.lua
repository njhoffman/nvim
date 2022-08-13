local timers = {}
local anon_timer = nil
local finished = { _ = {} }

local convert_time = function(time_ns)
  -- convert to seconds if nanoseconds above 1s
  if time_ns > 1000000000 then
    return math.floor(time_ns / 1000000000 * 100) / 100 .. " s"
  else
    return math.floor(time_ns / 1000000 * 100) / 100 .. " ms"
  end
end

local output_time = function(interval, name)
  name = name or ''
  local msg = name .. ': ' .. convert_time(interval) .. " ms"
  vim.notify(msg)
end

local stop_time = function(start, name)
  local interval = vim.loop.hrtime() - start
  if name ~= nil then
    finished[name] = finished[name] or {}
    table.insert(finished[name], interval)
    timers[name] = nil
  else
    table.insert(finished[_], interval)
    anon_timer = nil
  end
  output_time(interval, name)
end

local timer = function(name)
  if name ~= nil and string.len(name) > 0 then
    if timers[name] ~= nil then stop_time(timers[name], name)
    else timers[name] = vim.loop.hrtime() end
  else
    if anon_timer ~= nil then stop_time(anon_timer, vim.loop.hrtime())
    else anon_timer = vim.loop.hrtime() end
  end
end

-- timer('test')
-- vim.fn.timer_start(3000, function()
--   timer('test')
-- end)

return timer
