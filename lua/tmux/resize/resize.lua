local log = require("tmux.log")
local options = require("tmux.configuration.options")
local tmux = require("tmux.wrapper.tmux")
local layout = require("tmux.layout")
local nvim = require("tmux.wrapper.nvim")

local state = { timer = nil, augroup_id = nil, last_resize = nil, aucmd_id = nil }
state.augroup_id = vim.api.nvim_create_augroup("tmux-resize", { clear = true })

local dir_to_hjkl = { left = "h", right = "l", up = "k", down = "j" }
local axis_for = { left = "x", right = "x", up = "y", down = "y" }

local function is_only_window(border)
  if border == "h" or border == "l" then
    return nvim.winnr("1h") == nvim.winnr("1l")
  else
    return nvim.winnr("1j") == nvim.winnr("1k")
  end
end

-- Tmux pane is a valid resize target if there's an adjacent pane,
-- or if nvim is the only window (no splits to resize instead)
local function is_tmux_target(border)
  if not tmux.is_tmux then
    return false
  end
  return not layout.is_border(border) or is_only_window(border)
end

-- Temporarily disable mini.animate during resize, re-enable after 1s of inactivity
local function disable_animation()
  local timer_delay = 1000
  if state.aucmd_id == nil then
    state.aucmd_id = vim.api.nvim_create_autocmd("WinResized", {
      group = state.augroup_id,
      buffer = vim.api.nvim_get_current_buf(),
      callback = function()
        state.last_resize = vim.fn.reltime()
      end,
    })
  end
  if vim.g.minianimate_disable ~= true then
    vim.g.minianimate_disable = true
    if state.timer == nil or not state.timer:is_active() then
      state.timer = vim.loop.new_timer()
      state.timer:start(100, timer_delay, function()
        vim.schedule(function()
          if
            state.last_resize ~= nil
            and vim.fn.reltimefloat(vim.fn.reltime(state.last_resize)) > (timer_delay / 1000)
          then
            vim.g.minianimate_disable = false
            state.aucmd_id = vim.api.nvim_del_autocmd(state.aucmd_id)
            state.last_resize = nil
            state.timer:stop()
            state.timer:close()
            state.timer = nil
          end
        end)
      end)
    end
  end
end

-- Resize nvim splits by pushing a border in the given direction.
-- Uses win_move_separator (horizontal) and win_move_statusline (vertical)
-- for precise control over which border moves.
local function resize_nvim(direction, step)
  local curr = nvim.winnr()
  local left = nvim.winnr("h")
  local right = nvim.winnr("l")
  local up = nvim.winnr("k")
  local down = nvim.winnr("j")

  if direction == "left" then
    if left ~= curr then
      nvim.win_move_separator(left, -step)
    elseif right ~= curr then
      nvim.win_move_separator(curr, -step)
    else
      return false
    end
  elseif direction == "right" then
    if right ~= curr then
      nvim.win_move_separator(curr, step)
    elseif left ~= curr then
      nvim.win_move_separator(left, step)
    else
      return false
    end
  elseif direction == "up" then
    if up ~= curr then
      nvim.win_move_statusline(up, -step)
    elseif down ~= curr then
      nvim.win_move_statusline(curr, -step)
    else
      return false
    end
  elseif direction == "down" then
    if down ~= curr then
      nvim.win_move_statusline(curr, step)
    elseif up ~= curr then
      nvim.win_move_statusline(up, step)
    else
      return false
    end
  end

  return true
end

local M = {}

function M.to(direction, large)
  disable_animation()

  local ax = axis_for[direction]
  local hjkl = dir_to_hjkl[direction]
  local step = large and options.resize["large_" .. ax] or options.resize["step_" .. ax]

  log.debug("resize_to: " .. direction .. ", step: " .. step)

  if not resize_nvim(direction, step) then
    if is_tmux_target(hjkl) then
      tmux.resize(hjkl, step)
    end
  end
end

return M
