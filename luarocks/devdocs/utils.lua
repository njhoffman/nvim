local dkjson = require('dkjson')
local inspect = require('inspect')

local file_exists = function(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local read_file = function(path)
  local file = io.open(path, 'rb')
  if not file then
    return
  end
  local content = file:read('*all')
  file:close()
  return content
end

local get_keys = function(t)
  local keys = {}
  for k, _ in pairs(t) do
    table.insert(keys, k)
  end
  return keys
end
local read_lockfile = function(config)
  if not file_exists(config.LOCK_PATH) then
    return
  end
  local buf = read_file(config.LOCK_PATH)
  -- json_decode buf
  return dkjson.decode(buf)
end

local read_index = function(config)
  if not file_exists(config.INDEX_PATH) then
    return
  end
  local buf = read_file(config.INDEX_PATH)
  return dkjson.decode(buf)
end

local get_installed = function(config)
  local lockfile = read_lockfile(config) or {}
  return get_keys(lockfile)
end

local get_count = function(config, aliases)
  local count = {}
  local index = read_index(config) or {}
  for _, alias in pairs(aliases) do
    if index[alias] then
      count[alias] = #index[alias].entries
    end
  end
  return count
end

local debug = function(...)
  print(inspect(...))
end

return {
  debug = debug,
  get_count = get_count,
  get_installed = get_installed,
  read_index = read_index,
  read_lockfile = read_lockfile,
  file_exists = file_exists,
  get_keys = get_keys,
}
