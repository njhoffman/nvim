local state = require('neoscroll.state')
local config = require('neoscroll.config')
local utils = require('neoscroll.utils')

-- excecute commands to scroll screen [and cursor] up/down one line
-- `execute` is necessary to allow the use of special characters like <C-y>
-- The bang (!) `normal!` in normal ignores mappings
local function scroll_up(data, scroll_window, scroll_cursor, n_repeat)
  local n = n_repeat == nil and 1 or n_repeat
  local cursor_scroll_input = scroll_cursor and string.rep('gk', n) or ''
  local window_scroll_input = scroll_window and [[\<C-y>]] or ''
  local scroll_input
  -- if scrolloff or window edge are going to move the cursor for you then only
  -- scroll the window
  if
    (
      (
        data.last_line_visible
        and data.win_lines_below_cursor == data.lines_below_cursor
        and data.lines_below_cursor <= utils.get_scrolloff()
      ) or data.win_lines_below_cursor == utils.get_scrolloff()
    ) and scroll_window
  then
    scroll_input = window_scroll_input
  else
    scroll_input = window_scroll_input .. cursor_scroll_input
  end
  return [[exec "normal! ]] .. scroll_input .. [["]]
end

local function scroll_down(data, scroll_window, scroll_cursor, n_repeat)
  local n = n_repeat == nil and 1 or n_repeat
  local cursor_scroll_input = scroll_cursor and string.rep('gj', n) or ''
  local window_scroll_input = scroll_window and [[\<C-e>]] or ''
  local scroll_input
  -- if scrolloff or window edge are going to move the cursor for you then only
  -- scroll the window
  if
    (
      (data.first_line_visible and data.win_lines_above_cursor <= utils.get_scrolloff())
      or data.win_lines_above_cursor <= utils.get_scrolloff()
    ) and scroll_window
  then
    scroll_input = window_scroll_input
  else
    scroll_input = window_scroll_input .. cursor_scroll_input
  end
  return [[exec "normal! ]] .. scroll_input .. [["]]
end

-- Window rules for when to stop scrolling
local function window_reached_limit(data, move_cursor, direction)
  local opts = config.options

  if data.last_line_visible and direction > 0 then
    if move_cursor then
      if opts.stop_eof and data.last_line_visible then
        return true
      elseif opts.respect_scrolloff and data.lines_below_cursor <= utils.get_scrolloff() then
        return true
      else
        return data.lines_below_cursor == 0
      end
    else
      return data.lines_below_cursor == 0 and data.win_lines_above_cursor == 0
    end
  elseif data.first_line_visible and direction < 0 then
    return true
  else
    return false
  end
end

-- Cursor rules for when to stop scrolling
local function cursor_reached_limit(data, direction)
  local opts = config.options
  if data.first_line_visible and direction < 0 then
    if opts.respect_scrolloff and data.win_lines_above_cursor <= utils.get_scrolloff() then
      return true
    end
    return data.win_lines_above_cursor == 0
  elseif data.last_line_visible then
    if opts.respect_scrolloff and data.lines_below_cursor <= utils.get_scrolloff() then
      return true
    end
    return data.lines_below_cursor == 0
  end
end

-- Check if the window and the cursor can be scrolled further
local function who_scrolls(data, move_cursor, direction)
  local opts = config.options
  local scroll_window, scroll_cursor
  local half_window = math.floor(data.window_height / 2)
  scroll_window = not window_reached_limit(data, move_cursor, direction)
  if not move_cursor then
    scroll_cursor = false
  elseif scroll_window then
    if utils.get_scrolloff() < half_window then
      scroll_cursor = true
    else
      scroll_cursor = false
    end
  elseif opts.cursor_scrolls_alone then
    scroll_cursor = not cursor_reached_limit(data, direction)
  else
    scroll_cursor = false
  end
  return scroll_window, scroll_cursor
end

-- Scroll one line in the given direction
local function scroll_one_line(scroll_window, scroll_cursor, data)
  local winline_before = vim.fn.winline()
  local initial_cursor_line = vim.api.nvim_win_get_cursor(0)[1]
  local scroll
  local scrolled_lines
  if state.lines_to_scroll > 0 then
    scrolled_lines = 1
    scroll = scroll_down
  else
    scrolled_lines = -1
    scroll = scroll_up
  end

  vim.cmd(scroll(data, scroll_window, scroll_cursor))
  -- Correct for wrapped lines
  local lines_behind = vim.fn.winline() - state.cursor_win_line
  if state.lines_to_scroll > 0 then
    lines_behind = -lines_behind
  end
  if scroll_cursor and scroll_window and lines_behind > 0 then
    vim.cmd(scroll(data, false, scroll_cursor, lines_behind))
  end
  if initial_cursor_line == vim.api.nvim_win_get_cursor(0)[1] then
    -- if initial_cursor_line didn't change, we can use it to get scrolled_lines
    -- This is more accurate when some lines are wrapped
    scrolled_lines = winline_before - vim.fn.winline()
  end
  state.relative_line = state.relative_line + scrolled_lines
end

-- Scrolling constructor
local function before_scrolling(lines, move_cursor, info)
  local opts = config.options

  -- Start scrolling
  state.scrolling = true
  -- state.line_start = state.line_start or vim.fn.line('.')
  state.scroll_start = state.scroll_start or vim.fn.reltime()

  -- Hide cursor line
  if opts.hide_cursor and move_cursor then
    utils.hide_cursor()
  end
  -- Performance mode
  state.performance_mode = vim.b.neoscroll_performance_mode or vim.g.neoscroll_performance_mode
  if state.performance_mode and move_cursor then
    if vim.g.loaded_nvim_treesitter then
      vim.cmd('TSBufDisable highlight')
    end
    vim.bo.syntax = 'OFF'
  end
  -- Assign number of lines to scroll
  state.target_line = lines
  state.scroll_start = state.scroll_start or vim.fn.reltime()

  if opts.pre_hook ~= nil then
    opts.pre_hook(info, state)
  end
end

-- Scrolling destructor
local function stop_scrolling(move_cursor, info)
  local opts = config.options
  if opts.hide_cursor == true and move_cursor then
    utils.unhide_cursor()
  end
  --Performance mode
  local performance_mode = vim.b.neoscroll_performance_mode or vim.g.neoscroll_performance_mode
  if performance_mode and move_cursor then
    vim.bo.syntax = 'ON'
    if vim.g.loaded_nvim_treesitter then
      vim.cmd('TSBufEnable highlight')
    end
  end
  if opts.post_hook ~= nil then
    opts.post_hook(info, state)
  end

  local time_end = vim.fn.reltimestr(vim.fn.reltime(state.scroll_start))
  -- check if time_end is nil
  if type(time_end) == 'nil' or time_end == '' then
  else
    local diff_time = string.format('%.2f%s', tonumber(time_end) * 1000, 'ms')
    -- state.line_range = table.insert(state.line_range, vim.fn.line('.'))
    local save_state = {
      n = #state.history + 1,
      line_range = state.line_range,
      diff_time = diff_time,
      steps = utils.get_distribution(state.steps),
      -- info = info,
    }
    -- save_state.speed = string.format('%.3f ', (tonumber(lines) / time_end))
    table.insert(state.history, save_state)
  end

  state.relative_line = 0
  state.target_line = 0
  state.scroll_timer:stop()
  state.scrolling = false
  state.continuous_scroll = false
  state.steps = {}

  -- state._reset()
end

local function compute_time_step(line_idx, lines, time, easing_function)
  -- lines_to_scroll should always be positive
  -- If there's less than one line to scroll time_step doesn't matter
  if line_idx < 1 then
    return 1000
  end
  local lines_range = math.abs(lines)
  local ef = config.easing_functions[easing_function]
  -- If not yet in range return average time-step
  if not ef then
    state.time_step = math.floor(time / (lines_range - 1) + 0.5)
  elseif line_idx >= lines_range then
    state.time_step = math.floor(time * ef(1 / lines_range) + 0.5)
  else
    local x1 = (lines_range - line_idx) / lines_range
    local x2 = (lines_range - line_idx + 1) / lines_range
    state.time_step = math.floor(time * (ef(x2) - ef(x1)) + 0.5)
  end

  if state.time_step == 0 then
    state.time_step = 1
  end
  -- check if time_end is nil
  -- if type(time_end) == 'nil' then
  --   vim.dbglog('NIL empty', state)
  -- else
  -- local diff_time = string.format('%.2f%s', tonumber(time_end) * 1000, 'ms')
  -- state.line_range = table.insert(state.line_range, vim.fn.line('.'))
  local save_state = {
    n = #state.history + 1,
    -- line_range = state.line_range,
    -- diff_time = diff_time,
    steps = utils.get_distribution(state.steps),
    lines = lines,
    -- info = info,
    -- save_state.speed = string.format('%.3f ', (tonumber(lines) / time_end))
  }
  table.insert(state.history, save_state)
  -- end
  return state.time_step
end

return {
  scroll_up = scroll_up,
  scroll_down = scroll_down,
  who_scrolls = who_scrolls,
  before_scrolling = before_scrolling,
  stop_scrolling = stop_scrolling,
  compute_time_step = compute_time_step,
  window_reached_limit = window_reached_limit,
  cursor_reached_limit = cursor_reached_limit,
  scroll_one_line = scroll_one_line,
}
