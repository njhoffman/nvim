local log = require("tmux.log")

local M = {}

function M.parse(display)
  log.debug("parse: ", display or "nil")

  if display == "" or display == nil then
    return nil
  end

  local msgs = {}
  local panes = {}
  for pane in display:gmatch("(%d+x%d+,%d+,%d+,%d+)") do
    table.insert(panes, {
      id = tonumber(pane:match("%d+x%d+,%d+,%d+,(%d+)")),
      x = tonumber(pane:match("%d+x%d+,(%d+),%d+,%d+")),
      y = tonumber(pane:match("%d+x%d+,%d+,(%d+),%d+")),
      width = tonumber(pane:match("(%d+)x%d+")),
      height = tonumber(pane:match("%d+x(%d+)")),
    })
    table.insert(msgs, "pane: " .. #panes .. " > " .. table.concat({
      tostring(pane.id),
      table.concat({ tostring(pane.x), tostring(pane.y) }, ":"),
      table.concat({ tostring(pane.width), tostring(pane.height) }, "x"),
    }, " "))
  end
  if #panes == 0 then
    log.error("window_layout returned no valid panes")
    return nil
  end

  local width = display:match("^%w+,(%d+)x%d+")
  local height = display:match("^%w+,%d+x(%d+)")

  if width == nil and height == nil then
    log.error("window_layout returned invalid format")
    return nil
  end

  local result = {
    width = tonumber(width),
    height = tonumber(height),
    panes = panes,
  }

  log.debug(
    "parse tmux display > "
      .. #panes
      .. " panes - "
      .. table.concat({ result.height, result.width }, "x")
  )

  return result
end

return M
