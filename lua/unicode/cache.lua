local config = require("unicode.config")

local M = {}

--- Read a Lua cache file that returns a table.
--- @param path string
--- @return table|nil
function M.read(path)
  if not path or vim.fn.filereadable(path) == 0 then
    return nil
  end
  local ok, data = pcall(loadfile, path)
  if ok and data then
    local success, result = pcall(data)
    if success and type(result) == "table" then
      return result
    end
  end
  return nil
end

--- Write a unicode dictionary to a Lua cache file.
--- @param path string
--- @param data table Dictionary of decimal -> name
--- @param index table|nil Sorted list of decimal keys (for deterministic output)
function M.write(path, data, index)
  if not config.use_cache then
    return
  end

  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    local ok, err = pcall(vim.fn.mkdir, dir, "p")
    if not ok then
      vim.notify("UnicodePlugin: Error creating directory: " .. dir .. " " .. (err or ""), vim.log.levels.WARN)
      return
    end
  end

  local lines = {
    "-- Internal cache file for unicode.lua plugin",
    "-- This file can safely be removed; it will be recreated if needed",
    "",
    "return {",
  }

  local keys = index or {}
  if #keys == 0 then
    for k in pairs(data) do
      keys[#keys + 1] = k
    end
    table.sort(keys)
  end

  for _, dec in ipairs(keys) do
    local name = data[dec]
    if name then
      lines[#lines + 1] = string.format("  [0x%04X] = %q,", dec, name)
    end
  end

  lines[#lines + 1] = "}"
  vim.fn.writefile(lines, path)
end

--- Clean up old VimScript cache file if it exists.
function M.cleanup_old()
  local old_path = config.old_vim_cache_file()
  if vim.fn.filereadable(old_path) == 1 then
    vim.fn.delete(old_path)
  end
end

return M
