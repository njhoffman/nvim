local config = require("unicode.config")
local cache = require("unicode.cache")

local M = {}

local uni_dict = nil

--- Parse UnicodeData.txt and return a dictionary of decimal -> name.
--- @param path string Path to UnicodeData.txt
--- @return table dict, table index
function M.parse(path)
  local dict = {}
  local index = {}
  local lines = vim.fn.readfile(path)

  for _, line in ipairs(lines) do
    local fields = vim.split(line, ";", { plain = true })
    if #fields >= 11 then
      local hex = fields[1]
      local name = fields[2]
      local category = fields[3]

      -- Append general category
      if category and category ~= "" then
        name = name .. " (" .. category .. ")"
      end

      -- Use Unicode_1_Name (field 11) for <control> entries
      local old_name = fields[11]
      if name:sub(1, 1) == "<" and old_name and old_name ~= "" then
        name = vim.split(old_name, "(", { plain = true })[1]
      end

      -- Trim trailing spaces
      name = name:gsub("%s+$", "")

      local dec = tonumber(hex, 16)
      if dec then
        dict[dec] = name
        index[#index + 1] = dec
      end
    end
  end

  return dict, index
end

--- Load the unicode dictionary, using cache when available.
--- @return table
function M.load()
  if uni_dict then
    return uni_dict
  end

  local data_file = config.data_file()
  local cache_file = config.data_cache_file()

  -- Try loading from cache
  if config.use_cache and vim.fn.filereadable(cache_file) == 1 then
    local data_mtime = vim.fn.getftime(data_file)
    local cache_mtime = vim.fn.getftime(cache_file)
    local cache_size = vim.fn.getfsize(cache_file)

    if cache_mtime >= data_mtime and cache_size > 100 then
      local cached = cache.read(cache_file)
      if cached then
        uni_dict = cached
        cache.cleanup_old()
        return uni_dict
      end
    end
  end

  -- Parse from source file
  if vim.fn.filereadable(data_file) == 0 or vim.fn.getfsize(data_file) == 0 then
    vim.notify("UnicodePlugin: " .. data_file .. " not found. Run :UnicodeDownload", vim.log.levels.WARN)
    uni_dict = {}
    return uni_dict
  end

  local dict, index = M.parse(data_file)
  uni_dict = dict

  -- Write cache
  if config.use_cache then
    cache.write(cache_file, dict, index)
  end

  cache.cleanup_old()
  return uni_dict
end

--- Get the loaded dictionary (loads if needed).
--- @return table
function M.get()
  return M.load()
end

--- Clear the in-memory dictionary (forces reload on next access).
function M.clear()
  uni_dict = nil
end

return M
