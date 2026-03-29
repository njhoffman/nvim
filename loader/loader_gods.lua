local M = {}

local cached_gods = nil

-- Parse greekgods.txt: each line is "NAME  | description"
-- Returns lowercase first field
local function parse_gods_file(filepath)
  local gods = {}
  local f = io.open(filepath, "r")
  if not f then
    return gods
  end
  for line in f:lines() do
    local name = line:match("^([^|]+)")
    if name then
      name = name:gsub("%s+", ""):lower()
      if #name > 0 then
        gods[#gods + 1] = name
      end
    end
  end
  f:close()
  return gods
end

function M.random(gods_file)
  if not cached_gods then
    cached_gods = parse_gods_file(gods_file)
  end
  if #cached_gods == 0 then
    return "unknown"
  end
  return cached_gods[math.random(#cached_gods)]
end

-- Exposed for testing
M._parse_gods_file = parse_gods_file

return M
