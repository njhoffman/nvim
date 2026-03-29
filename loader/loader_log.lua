local M = {}

local home = os.getenv("HOME") or ""
local config = nil

function M.setup(cfg)
  config = cfg
end

local function replace_home(msg)
  if #home > 0 then
    return msg:gsub(home, "~")
  end
  return msg
end

function M.info(msg)
  if not config then
    return
  end
  local clean = replace_home(msg)

  -- Append to log file
  local f = io.open(config.log_file, "a")
  if f then
    f:write(clean .. "\n")
    f:close()
  end

  -- Syslog
  if config.syslog then
    os.execute('logger --tag=nvim "' .. clean:gsub('"', '\\"') .. '"')
  end
end

return M
