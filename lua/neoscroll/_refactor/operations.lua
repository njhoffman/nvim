local utils = require('neoscroll.utils')

local operations = {}

-- Wrapper for zt
function operations.zt(half_screen_time, easing, info)
  local window_height = vim.fn.winheight(0)
  local win_lines_above_cursor = vim.fn.winline() - 1
  -- Temporary fix for garbage values in local scrolloff when not set
  local lines = win_lines_above_cursor - utils.get_scrolloff()
  if lines == 0 then
    return
  end
  local corrected_time = math.floor(half_screen_time * (math.abs(lines) / (window_height / 2)) + 0.5)
  operations.scroll(lines, false, corrected_time, easing, info)
end
-- Wrapper for zz
function operations.zz(half_screen_time, easing, info)
  local window_height = vim.fn.winheight(0)
  local lines = vim.fn.winline() - math.ceil(window_height / 2)
  if lines == 0 then
    return
  end
  local corrected_time = math.floor(half_screen_time * (math.abs(lines) / (window_height / 2)) + 0.5)
  operations.scroll(lines, false, corrected_time, easing, info)
end

-- Wrapper for zb
function operations.zb(half_screen_time, easing, info)
  local window_height = vim.fn.winheight(0)
  local lines_below_cursor = window_height - vim.fn.winline()
  -- Temporary fix for garbage values in local scrolloff when not set
  local lines = -lines_below_cursor + utils.get_scrolloff()
  if lines == 0 then
    return
  end
  local corrected_time = math.floor(half_screen_time * (math.abs(lines) / (window_height / 2)) + 0.5)
  operations.scroll(lines, false, corrected_time, easing, info)
end

function operations.G(half_screen_time, easing, info)
  local lines = utils.get_lines_below(vim.fn.line('w$'))
  local window_height = vim.fn.winheight(0)
  local cursor_win_line = vim.fn.winline()
  local win_lines_below_cursor = window_height - cursor_win_line
  local corrected_time = math.floor(half_screen_time * (math.abs(lines) / (window_height / 2)) + 0.5)
  operations.scroll(lines, true, corrected_time, easing, { G = true })
end

function operations.gg(half_screen_time, easing, info)
  local lines = utils.get_lines_above(vim.fn.line('w0'))
  local window_height = vim.fn.winheight(0)
  local cursor_win_line = vim.fn.winline()
  lines = -lines - cursor_win_line
  local corrected_time = math.floor(half_screen_time * (math.abs(lines) / (window_height / 2)) + 0.5)
  operations.scroll(lines, true, corrected_time, easing, info)
end
