local config = require("unicode.config")
local cache = require("unicode.cache")

local M = {}

local function warn(msg)
  vim.notify("UnicodePlugin: " .. msg, vim.log.levels.WARN)
end

--- Ensure directory exists.
--- @param dir string
--- @return boolean
local function ensure_dir(dir)
  if vim.fn.isdirectory(dir) == 0 then
    local ok, err = pcall(vim.fn.mkdir, dir, "p")
    if not ok then
      warn("Error creating directory: " .. dir .. " " .. (err or ""))
      return false
    end
  end
  return true
end

--- Download UnicodeData.txt from the configured URL.
--- @param force boolean If true, re-download even if file exists
--- @param silent boolean|nil If true, skip confirmation dialog
--- @return boolean Success
function M.download(force, silent)
  local data_file = config.data_file()

  local needs_download = not vim.fn.filereadable(data_file)
    or vim.fn.getfsize(data_file) == 0
    or force

  if not needs_download then
    return true
  end

  if not force then
    warn("File " .. data_file .. " does not exist or is zero.")
  else
    warn("Updating " .. data_file)
  end
  warn("Let's see, if we can download it.")
  warn("If this doesn't work, you should download ")
  warn(config.url .. " and save it as " .. data_file)

  -- Confirm download
  if not silent then
    local choice = vim.fn.confirm(
      "Download " .. config.url .. " now?",
      "&Yes\n&No",
      1,
      "Question"
    )
    if choice == 0 or choice == 2 then
      warn("Not downloading file. You can retry by executing :UnicodeDownload")
      return false
    end
  end

  -- Remove cache files (will be re-created)
  if config.use_cache then
    local cache_file = config.data_cache_file()
    local table_cache = config.table_cache_file()
    if vim.fn.filereadable(cache_file) == 1 then
      vim.fn.delete(cache_file)
    end
    if vim.fn.filereadable(table_cache) == 1 then
      vim.fn.delete(table_cache)
    end
  end

  if not vim.fn.executable("curl") then
    warn("curl not found; cannot download file")
    warn("Please download " .. config.url)
    warn("and save it as " .. data_file)
    return false
  end

  if not ensure_dir(config.data_dir) then
    return false
  end

  -- Download using vim.system (async with callback)
  warn("Downloading...")
  local result = vim.system({ "curl", "-sL", "-o", data_file, config.url }):wait()

  if result.code ~= 0 then
    warn("Error fetching file from " .. config.url)
    return false
  end

  -- Verify download
  if vim.fn.getfsize(data_file) == 0 then
    warn("Error fetching file from " .. config.url .. " (empty file)")
    return false
  end

  -- Try to parse to verify structure
  local ok, err = pcall(function()
    local data_mod = require("unicode.data")
    data_mod.clear()
    data_mod.load()
  end)

  if not ok then
    warn("Error loading UnicodeData file: " .. (err or "unknown"))
    warn("Please verify the structure of: " .. data_file)
    return false
  end

  warn("Download complete: " .. data_file)
  return true
end

return M
