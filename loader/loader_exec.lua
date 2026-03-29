local M = {}

-- Capture stdout from a shell command, trimming trailing newline
function M.capture(cmd)
  local handle = io.popen(cmd, "r")
  if not handle then
    return nil
  end
  local result = handle:read("*a")
  handle:close()
  if result then
    result = result:gsub("%s+$", "")
  end
  return result
end

-- Run a command, blocking until it exits. Returns exit code.
-- Terminal is forwarded (stdin/stdout/stderr inherited).
function M.run(cmd)
  local ok, exit_type, code = os.execute(cmd)
  if ok then
    return 0
  end
  -- Lua 5.1 vs 5.2+ handle os.execute differently
  if type(ok) == "number" then
    -- Lua 5.1: os.execute returns exit code directly
    return ok
  end
  return code or 1
end

-- Fire-and-forget a command (background, no output capture)
function M.spawn(cmd)
  os.execute(cmd .. " >/dev/null 2>&1 &")
end

-- Check if a file exists
function M.file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

-- Remove a file, returns true on success
function M.remove(path)
  return os.remove(path)
end

-- Rename a file, returns true on success
function M.rename(old, new)
  return os.rename(old, new)
end

-- Ensure a directory exists (mkdir -p)
function M.mkdir_p(path)
  local lfs = require("lfs")
  -- Walk each component
  local sep = "/"
  local current = ""
  for part in path:gmatch("[^/]+") do
    current = current .. sep .. part
    local attr = lfs.attributes(current)
    if not attr then
      lfs.mkdir(current)
    end
  end
end

return M
