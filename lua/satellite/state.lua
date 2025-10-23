local api = vim.api

local M = {}

--- @type table<integer, "active"|"inactive"|"scrolling">
local window_states = {}

--- @type table<integer, number>
local scroll_timers = {}

local SCROLL_TIMEOUT_MS = 300 -- Time to keep "scrolling" state after scroll ends

--- Get the current state for a window
--- @param winid integer
--- @return "active"|"inactive"|"scrolling"
function M.get_state(winid)
  return window_states[winid] or "inactive"
end

--- Set a window to active state
--- @param winid integer
function M.set_active(winid)
  window_states[winid] = "active"
end

--- Set a window to inactive state
--- @param winid integer
function M.set_inactive(winid)
  -- Don't override scrolling state
  if window_states[winid] ~= "scrolling" then
    window_states[winid] = "inactive"
  end
end

--- Set a window to scrolling state (temporary)
--- @param winid integer
function M.set_scrolling(winid)
  window_states[winid] = "scrolling"

  -- Cancel existing timer if any
  if scroll_timers[winid] then
    vim.fn.timer_stop(scroll_timers[winid])
  end

  -- Set timer to revert to previous state after timeout
  scroll_timers[winid] = vim.fn.timer_start(SCROLL_TIMEOUT_MS, function()
    scroll_timers[winid] = nil
    -- Revert to active or inactive based on current window
    local current_win = api.nvim_get_current_win()
    if winid == current_win then
      window_states[winid] = "active"
    else
      window_states[winid] = "inactive"
    end
    -- Trigger refresh
    vim.schedule(function()
      if api.nvim_win_is_valid(winid) then
        require("satellite.view").refresh_bars()
      end
    end)
  end)
end

--- Clear state for a window (when it's closed)
--- @param winid integer
function M.clear_state(winid)
  window_states[winid] = nil
  if scroll_timers[winid] then
    vim.fn.timer_stop(scroll_timers[winid])
    scroll_timers[winid] = nil
  end
end

--- Update all window states based on current focus
function M.update_all_states()
  local current_win = api.nvim_get_current_win()

  for _, winid in ipairs(api.nvim_list_wins()) do
    if api.nvim_win_is_valid(winid) then
      -- Don't override scrolling state
      if window_states[winid] ~= "scrolling" then
        if winid == current_win then
          window_states[winid] = "active"
        else
          window_states[winid] = "inactive"
        end
      end
    end
  end
end

return M
