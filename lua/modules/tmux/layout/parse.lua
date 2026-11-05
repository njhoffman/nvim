-- Parses tmux window layouts from JSON or the classic format.

local log = require("modules.tmux.log")

local M = {}

-- Collect leaf panes from a JSON layout node ({"t":"p"|"h"|"v", "w","h","x","y", "I":"%id", "c":[...]}).
local function collect_json_panes(node, panes)
  if type(node) ~= "table" then
    return
  end
  if node.t == "p" then
    local id = type(node.I) == "string" and tonumber(node.I:match("^%%(%d+)$")) or nil
    if id and node.x and node.y and node.w and node.h then
      table.insert(panes, { id = id, x = node.x, y = node.y, width = node.w, height = node.h })
    end
    return
  end
  for _, child in ipairs(node.c or {}) do
    collect_json_panes(child, panes)
  end
end

-- tmux next-3.9+ prints #{window_layout} as JSON: {"V":2,"L":{...}}
local function parse_json(display)
  local ok, decoded = pcall(vim.json.decode, display)
  if not ok or type(decoded) ~= "table" or type(decoded.L) ~= "table" then
    log.error("window_layout returned invalid JSON")
    return nil
  end

  local root = decoded.L
  local panes = {}
  collect_json_panes(root, panes)
  if #panes == 0 then
    log.error("window_layout returned no valid panes")
    return nil
  end

  return { width = tonumber(root.w), height = tonumber(root.h), panes = panes }
end

-- Classic format: checksum,WxH,x,y{...} with leaf panes as WxH,x,y,id
local function parse_classic(display)
  local panes = {}
  for w, h, x, y, id in display:gmatch("(%d+)x(%d+),(%d+),(%d+),(%d+)") do
    table.insert(panes, {
      id = tonumber(id),
      x = tonumber(x),
      y = tonumber(y),
      width = tonumber(w),
      height = tonumber(h),
    })
  end
  if #panes == 0 then
    log.error("window_layout returned no valid panes")
    return nil
  end

  local width, height = display:match("^%w+,(%d+)x(%d+)")
  if width == nil then
    log.error("window_layout returned invalid format")
    return nil
  end

  return { width = tonumber(width), height = tonumber(height), panes = panes }
end

function M.parse(display)
  log.debug("parse: ", display or "nil")

  if display == nil then
    return nil
  end
  display = vim.trim(display)
  if display == "" then
    return nil
  end

  local result
  if display:sub(1, 1) == "{" then
    result = parse_json(display)
  else
    result = parse_classic(display)
  end
  if result == nil then
    return nil
  end

  log.debug(
    "parse tmux display > "
      .. #result.panes
      .. " panes - "
      .. table.concat({ result.height, result.width }, "x")
  )

  return result
end

return M
