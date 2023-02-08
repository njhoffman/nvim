local M = {}
local config = require("debuglog.config")

local round = function(x, increment)
  increment = increment or 1
  x = x / increment
  return (x > 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)) * increment
end

M.make_string = function(...)
  local t = {}
  for i = 1, select("#", ...) do
    local x = select(i, ...)

    if type(x) == "number" and config.float_precision then
      x = tostring(round(x, config.float_precision))
    elseif type(x) == "table" then
      x = vim.inspect(x)
    else
      x = tostring(x)
    end

    t[#t + 1] = x
  end
  return table.concat(t, " ")
end

M.wrap = function(str, limit, indent, indent1)
  if type(str) ~= "string" then
    return str
  end
  indent = indent or ""
  indent1 = indent1 or indent
  limit = limit or 30
  local here = 1 - #indent1
  return indent1
    .. str:gsub("(%s+)()(%S+)()", function(sp, st, word, fi)
      if fi - here > limit then
        here = st - #indent
        return "\n" .. indent .. word
      end
    end)
end

M.log_level_number = function(name)
  name = name or "info"
  local levels = { "trace", "debug", "info", "warn", "error" }
  local level_n = 1
  for i, level in ipairs(levels) do
    if level == name then
      level_n = i
    end
  end
  return level_n
end

M.log_level_name = function(num)
  local levels = { "trace", "debug", "info", "warn", "error" }
  local level_name = ""
  for i, level in ipairs(levels) do
    if i == num + 1 then
      level_name = level
    end
  end
  return level_name
end

return M
