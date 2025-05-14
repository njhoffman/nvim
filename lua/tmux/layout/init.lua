local log = require("tmux.log")
local parse = require("tmux.layout.parse")
local tmux = require("tmux.wrapper.tmux")

local direction_checks = {
  ["h"] = function(_, pane)
    return pane.x == 0
  end,
  ["j"] = function(layout, pane)
    return pane.y + pane.height == layout.height
  end,
  ["k"] = function(_, pane)
    return pane.y == 0
  end,
  ["l"] = function(layout, pane)
    return pane.x + pane.width == layout.width
  end,
}

local function get_pane(id, panes)
  log.debug("get_pane: ", id)
  for _, pane in pairs(panes) do
    if pane.id == id then
      log.debug(
        "get_tmux_pane: "
          .. table.concat({ id, pane.id }, " ")
          .. " > "
          .. table.concat({ pane.x, pane.y, pane.width, pane.height }, ",")
      )
      return pane
    end
  end
  log.debug("get_tmux_pane > nil")
  return nil
end

local function check_is_border(display, id, direction)
  log.debug("check_is_border: ", table.concat({ display, id, direction }), " ")

  local layout = parse.parse(display)
  if layout == nil then
    log.debug("check_tmux_border > nil (layout)")
    return nil
  end

  local pane = get_pane(id, layout.panes)
  if pane == nil then
    log.debug("check_tmux_border > nil (no tmux pane)")
    return nil
  end

  local check = direction_checks[direction]
  if check ~= nil then
    local dircheck = check(layout, pane)
    log.debug("check_tmux_direction  " .. direction .. " > " .. tostring(dircheck))
    return dircheck
  end

  log.debug("check_tmux_direction " .. direction .. " > nil")
  return nil
end

local M = {}

function M.is_border(direction)
  log.debug("tmux is_border: ", direction or "nil")

  local display = tmux.get_window_layout()
  local id = tmux.get_current_pane_id()
  local result = check_is_border(display, id, direction)

  log.debug(
    "tmux is_border > ",
    table.concat({ direction, tostring(id), tostring(result) or "false" }, " ")
  )

  return result
end

return M
