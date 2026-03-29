local layout = require("tmux.layout")
local log = require("tmux.log")
local nvim = require("tmux.wrapper.nvim")
local options = require("tmux.configuration.options")
local tmux = require("tmux.wrapper.tmux")

local opposite_directions = { h = "l", j = "k", k = "j", l = "h" }
local i3_directions = { j = "down", l = "right", k = "up", h = "left" }

local M = {}
function M.has_tmux_target(direction)
  if not tmux.is_tmux then
    return false
  end
  if tmux.is_zoomed() and options.navigation.persist_zoom then
    return false
  end
  if not layout.is_border(direction) then
    return true
  end
  return options.navigation.cycle_navigation
    and not layout.is_border(opposite_directions[direction])
end

function M.to(direction)
  local is_tmux_target = M.has_tmux_target(direction)
  local is_nvim_border = nvim.is_nvim_border(direction)
  local is_float = vim.tbl_get(vim.api.nvim_win_get_config(0), "relative") ~= ""
  log.debug(
    "navigate_to: "
      .. direction
      .. ", nvim border: "
      .. tostring(is_nvim_border)
      .. ", tmux target: "
      .. tostring(is_tmux_target)
  )

  if (is_nvim_border or is_float) and is_tmux_target then
    tmux.change_pane(direction)
  elseif is_nvim_border and options.navigation.cycle_navigation then
    nvim.wincmd(opposite_directions[direction], 999)
  elseif not is_float and not is_nvim_border then
    nvim.wincmd(direction, vim.v.count)
  elseif i3_directions[direction] ~= nil then
    -- Last resort: delegate to i3 window manager
    vim.fn.system("i3-msg 'focus " .. i3_directions[direction] .. "'")
  end
end

return M
