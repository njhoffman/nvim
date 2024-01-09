local pattern_filter = function(name, level, msg)
  -- additional filtering based on scope and pattern
  local skip = false
  local lvl_patterns = require('logger.levels').patterns
  for scope, filter in pairs(lvl_patterns) do
    local pattern, scope_lvl = filter[1], filter[2]
    if name == scope and string.match(msg, pattern) and level <= scope_lvl then
      skip = true
    end
  end
  return skip
end

local level = 1
local msg = '[devdocs] Installing required docs'
vim.dbglog(string.match(msg, '^%[devdocs%]'))
-- pattern_filter('notify', level, msg)
