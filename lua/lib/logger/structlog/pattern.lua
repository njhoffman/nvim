-- Drops log messages that match a scope's filter pattern in lib.logger.levels.

local pattern_filter = function(name, level, msg)
  -- additional filtering based on scope and pattern
  local skip = false
  local lvl_patterns = require("lib.logger.levels").patterns
  for scope, filter in pairs(lvl_patterns) do
    local pattern, scope_lvl = filter[1], filter[2]
    if name == scope and string.match(msg, pattern) and level <= scope_lvl then
      skip = true
    end
  end
  return skip
end

return pattern_filter
