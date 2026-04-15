local uv = vim.uv or vim.loop

local timers = {}
local anon_timer = nil
local finished = { ["_"] = {} }

local convert_time = function(time_ns)
  -- convert to seconds if nanoseconds above 1s
  if time_ns > 1000000000 then
    return math.floor(time_ns / 1000000000 * 100) / 100 .. " s"
  else
    return math.floor(time_ns / 1000000 * 100) / 100 .. " ms"
  end
end

local output_time = function(interval, name)
  name = name or ""
  local msg = name .. ": " .. convert_time(interval)
  vim.notify(msg)
end

local stop_time = function(start, name)
  local interval = uv.hrtime() - start
  if name ~= nil then
    finished[name] = finished[name] or {}
    table.insert(finished[name], interval)
    timers[name] = nil
  else
    table.insert(finished["_"], interval)
    anon_timer = nil
  end
  output_time(interval, name)
  return interval
end

local timer = function(name)
  if name ~= nil and string.len(name) > 0 then
    if timers[name] ~= nil then
      return stop_time(timers[name], name)
    else
      timers[name] = uv.hrtime()
    end
  else
    if anon_timer ~= nil then
      return stop_time(anon_timer)
    else
      anon_timer = uv.hrtime()
    end
  end
end

return timer
