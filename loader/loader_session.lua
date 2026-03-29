local exec = require("loader_exec")
local lfs = require("lfs")

local M = {}

-- Find a _runonce.vim reload session matching the socket prefix
function M.get_reload(load_dir, prefix)
  if not prefix then
    return nil
  end
  exec.mkdir_p(load_dir)
  local pattern = "^" .. prefix:gsub("([%.%-%+%[%]%(%)%$%^])", "%%%1") .. ".*_runonce%.vim$"
  for entry in lfs.dir(load_dir) do
    if entry:match(pattern) then
      local path = load_dir .. "/" .. entry
      if exec.file_exists(path) then
        return path
      end
    end
  end
  return nil
end

-- Find a saved session by tmux session name
function M.get_saved(saved_dir, tmux_session_name)
  if not tmux_session_name then
    return nil
  end
  exec.mkdir_p(saved_dir)
  for entry in lfs.dir(saved_dir) do
    if entry == tmux_session_name then
      local path = saved_dir .. "/" .. entry
      if exec.file_exists(path) then
        return path
      end
    end
  end
  return nil
end

-- Clean up dangling _temp.vim sessions
function M.clean_temp(load_dir, prefix)
  if not prefix then
    return
  end
  exec.mkdir_p(load_dir)
  local pattern = "^" .. prefix:gsub("([%.%-%+%[%]%(%)%$%^])", "%%%1") .. ".*_temp%.vim$"
  for entry in lfs.dir(load_dir) do
    if entry:match(pattern) then
      local path = load_dir .. "/" .. entry
      if exec.file_exists(path) then
        exec.remove(path)
      end
    end
  end
end

-- Rename _runonce.vim to _temp.vim to enable session reloading
-- Returns the new path
function M.prepare_reload(path)
  local new_path = path:gsub("_runonce%.vim$", "_temp.vim")
  exec.rename(path, new_path)
  return new_path
end

return M
