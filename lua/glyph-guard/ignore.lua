local M = {}

local function glob_to_pattern(glob)
  local out = glob:gsub("([%(%)%.%%%+%-%[%]%^%$])", "%%%1")
  out = out:gsub("%*%*", "\0")
  out = out:gsub("%*", "[^/]*")
  out = out:gsub("%?", ".")
  out = out:gsub("%z", ".*")
  return "^" .. out .. "$"
end

function M.matcher(patterns)
  if not patterns or #patterns == 0 then
    return function()
      return false
    end
  end

  local plain, globs = {}, {}
  for _, p in ipairs(patterns) do
    if p:find("[%*%?]") then
      table.insert(globs, glob_to_pattern(p))
    else
      plain[p] = true
    end
  end

  return function(path)
    for seg in path:gmatch("[^/]+") do
      if plain[seg] then
        return true
      end
    end
    for _, pat in ipairs(globs) do
      if path:match(pat) then
        return true
      end
    end
    return false
  end
end

return M
