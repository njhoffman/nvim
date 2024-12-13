local config = require("hover.config")
local state = require("hover.state")
local ui_title = require("hover.ui.title")

local function get_max_height(num)
  if string.find(tostring(num), "%%") then
    local pct = string.match(tostring(num), "([0-9]+)%%")
    local currheight = vim.api.nvim_win_get_height(0)
    return math.floor(currheight * pct / 100)
  end
  return num
end

local function get_max_width(num)
  if string.find(tostring(num), "%%") then
    local pct = string.match(tostring(num), "([0-9]+)%%")
    local currwidth = vim.api.nvim_win_get_width(0)
    return math.floor(currwidth * pct / 100)
  end
  return num
end

local function get_lines_width(lines)
  local width = 0
  for _, line in ipairs(lines) do
    if #line > width then
      width = #line
    end
  end
  return width
end

local function get_lines_height(lines)
  -- TODO: rules should include two rows of ""
  local height = #lines
  local sub = 0
  for _, line in ipairs(lines) do
    if string.match(line, "^```") then
      sub = sub + 1
    elseif string.match(line, "^---$") then
      sub = sub + 2
    end
  end
  return height - sub
end

local function get_dimensions(lines, max, provider_id)
  local _, title_width = ui_title.get_title(provider_id)
  local dimensions = {
    old_w = state.width,
    old_h = state.height,
  }
  state.height_full = get_lines_height(lines)
  state.width_full = get_lines_width(lines)
  state.height_minimized = 1
  state.width_minimized = title_width

  -- if height > max.h then
  --   height = max.h
  -- elseif height < 1 then
  --   height = config.get().min_height
  -- end
  if state.height_full > max.h then
    state.height = max.h
  elseif state.height_full < config.get().min_height then
    state.height = config.get().min_height
  else
    state.height = state.height_full
  end

  if state.width_full > max.w then
    state.width = max.w
  elseif state.width_full < config.get().min_width then
    state.width = config.get().min_width
  else
    state.width = state.width_full
  end
  state.width = title_width > state.width and title_width or state.width

  return vim.tbl_deep_extend("force", dimensions, { new_w = state.width, new_h = state.height })
end

return {
  get_dimensions = get_dimensions,
  get_max_height = get_max_height,
  get_max_width = get_max_width,
}
