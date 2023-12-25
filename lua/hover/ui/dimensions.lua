local config = require('hover.config')
local state = require('hover.state')
local ui_title = require('hover.ui.title')

local function get_max_height(num)
  if string.find(tostring(num), '%%') then
    local pct = string.match(tostring(num), '([0-9]+)%%')
    local currheight = vim.api.nvim_win_get_height(0)
    return math.floor(currheight * pct / 100)
  end
  return num
end

local function get_max_width(num)
  if string.find(tostring(num), '%%') then
    local pct = string.match(tostring(num), '([0-9]+)%%')
    local currwidth = vim.api.nvim_win_get_width(0)
    return math.floor(currwidth * pct / 100)
  end
  return num
end

local function get_lines_height(lines)
  -- TODO: rules should include two rows of ""
  local height = #lines + 1
  local sub = 0
  for _, line in ipairs(lines) do
    if string.match(line, '^```') then
      sub = sub + 1
    elseif string.match(line, '^---$') then
      sub = sub + 2
    end
  end
  return height - sub
end

local function get_dimensions(lines, max, provider_id)
  local dimensions = {
    old_w = state.width,
    old_h = state.height,
  }
  local height = get_lines_height(lines)
  local width = 0

  local _, title_width = ui_title.get_title(provider_id)

  if height > max.h then
    height = max.h
  elseif height < 1 then
    height = config.get().min_height
  end

  for _, line in ipairs(lines) do
    if #line > width then
      width = #line
    end
  end
  if width > max.w then
    width = max.w
  elseif width < config.get().min_width then
    width = config.get().min_width
  end

  state.width = title_width > width and title_width or width
  state.height = height
  return vim.tbl_deep_extend('force', dimensions, { new_w = state.width, new_h = state.height })
end

return { get_dimensions = get_dimensions, get_max_height = get_max_height, get_max_width = get_max_width }
