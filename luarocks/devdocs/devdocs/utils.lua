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
  local count = { ['*'] = 0 }
  local index = read_index(config) or {}
  for _, alias in pairs(aliases) do
    if index[alias] then
      count[alias] = #index[alias].entries
      count['*'] = count['*'] + count[alias]
    end
  end
  return count
end

local split = function(str, sep)
  local result = {}
  local regex = ('([^%s]+)'):format(sep)
  for each in str:gmatch(regex) do
    table.insert(result, each)
  end
  return result
end

local read_entry = function(config, entry)
  local splited_path = split(entry.path, ',')
  local file = splited_path[1]
  local file_path = config.DOCS_DIR:joinpath(entry.alias, file .. '.md')
  local content = file_path:read()
  local pattern = splited_path[2]
  local next_pattern = nil

  if entry.next_path ~= nil then
    next_pattern = split(entry.next_path, ',')[2]
  end

  local lines = split(content, '\n')

  -- https://stackoverflow.com/a/34953646/516188
  local function create_pattern(text)
    return text:gsub('([^%w])', '%%%1')
  end

  local filtered_lines = {}
  local found = false
  local pattern_lines = split(pattern, '\n')
  local search_pattern = create_pattern(pattern_lines[1]) -- only search the first line
  local next_search_pattern = nil

  if next_pattern then
    local next_pattern_lines = split(next_pattern, '\n')
    next_search_pattern = create_pattern(next_pattern_lines[1]) -- only search the first line
  end

  for _, line in ipairs(lines) do
    if found and next_search_pattern then
      if line:match(next_search_pattern) then
        break
      end
    end
    if line:match(search_pattern) then
      found = true
    end
    if found then
      table.insert(filtered_lines, line)
    end
  end

  if not found then
    return lines
  end

  return filtered_lines
end

local debug = function(...)
  print(inspect(...))
end

local tbl_contains = function(tbl, value)
  for _, v in ipairs(tbl) do
    if v == value then
      return true
    end
  end
  return false
end

return {
  debug = debug,
  get_count = get_count,
  get_installed = get_installed,
  read_entry = read_entry,
  read_index = read_index,
  read_lockfile = read_lockfile,
  file_exists = file_exists,
  get_keys = get_keys,
  tbl_contains = tbl_contains,
  split = split,
}
