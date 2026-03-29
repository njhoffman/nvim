local exec = require("loader_exec")

local M = {}

function M.is_active()
  local tmux = os.getenv("TMUX")
  return tmux ~= nil and tmux ~= ""
end

-- Run tmux display -p with a format string, return trimmed result
local function tmux_display(fmt)
  return exec.capture("tmux display -p '" .. fmt .. "'")
end

function M.session_id()
  local id = tmux_display("#{session_id}")
  if id then
    id = id:gsub("%$", "")
  end
  return id
end

function M.window_id()
  local id = tmux_display("#{window_id}")
  return id
end

function M.session_name()
  return tmux_display("#{session_name}")
end

-- Find pane running nvim in current window
function M.get_nvim_pane()
  local output = exec.capture("tmux list-panes -F '#{pane_id} #{pane_current_command}'")
  if not output then
    return nil
  end
  for line in output:gmatch("[^\n]+") do
    if line:match("nvim$") then
      return line:match("^(%S+)")
    end
  end
  return nil
end

function M.focus_pane(pane_id)
  if pane_id then
    os.execute("tmux select-pane -t " .. pane_id)
  end
end

return M
