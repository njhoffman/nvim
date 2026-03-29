local exec = require("loader_exec")
local lfs = require("lfs")

local M = {}

-- Build socket prefix from tmux context
-- Returns prefix like "nvim_0_@0" or "nvim_0" or nil if not in tmux
function M.get_prefix(config, tmux)
  if not tmux.is_active() then
    return nil
  end

  -- Explicit listen address overrides everything
  if config.remote.listen_address then
    return config.remote.listen_address:gsub("^/tmp/", "")
  end

  local session_id = tmux.session_id()
  if not session_id then
    return nil
  end

  local prefix = "nvim_" .. session_id

  if config.remote.attach_on == "tmux_window" then
    local window_id = tmux.window_id()
    if window_id then
      prefix = prefix .. "_" .. window_id
    end
  end

  return prefix
end

-- Scan sockets_dir for existing socket matching prefix
function M.find_existing(sockets_dir, prefix)
  if not prefix then
    return nil
  end
  local pattern = "^" .. prefix:gsub("([%.%-%+%[%]%(%)%$%^])", "%%%1") .. "_"
  for entry in lfs.dir(sockets_dir) do
    if entry:match(pattern) then
      return sockets_dir .. "/" .. entry
    end
  end
  return nil
end

-- Check if a socket is alive by trying to communicate with the nvim instance
function M.is_alive(socket_path, nvim_bin)
  nvim_bin = nvim_bin or "nvim"
  local cmd = nvim_bin .. ' --server "' .. socket_path .. '" --remote-expr "1" >/dev/null 2>&1'
  return exec.run(cmd) == 0
end

-- Generate new socket path
function M.create(sockets_dir, prefix, god_name)
  return sockets_dir .. "/" .. prefix .. "_" .. god_name
end

-- Remove a stale socket file
function M.cleanup(socket_path, log)
  if log then
    log.info("removing stale socket: " .. socket_path)
  end
  exec.remove(socket_path)
end

return M
