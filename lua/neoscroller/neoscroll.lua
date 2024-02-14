local config = require('neoscroll.config')
local utils = require('neoscroll.utils')
local state = require('neoscroll.state')
local scroller = require('neoscroll.scroller')

local neoscroll = {}

-- Scrolling function
-- lines: number of lines to scroll or fraction of window to scroll
-- move_cursor: scroll the window and the cursor simultaneously
-- easing_function: name of the easing function to use for the scrolling animation
function neoscroll.scroll(lines, move_cursor, time, easing_function, info)
  -- If lines is a fraction of the window transform it to lines
  if utils.is_float(lines) then
    lines = utils.get_lines_from_win_fraction(lines)
  end
  if lines == 0 then
    return
  end
  state.line_range = state.line_range or { vim.fn.line('.') }
  -- If still scrolling just modify the amount of lines to scroll
  -- If the scroll is in the opposite direction and lines_to_scroll is longer than lines stop smoothly
  if state.scrolling then
    local to_scroll = state.relative_line - state.target_line

    local opposite_direction = to_scroll * lines > 0
    local long_scroll = math.abs(to_scroll) - math.abs(lines) > 0
    if opposite_direction and long_scroll then
      state.target_line = state.relative_line - lines
    elseif state.continuous_scroll then
      state.target_line = state.relative_line + 2 * lines
    elseif math.abs(to_scroll) > math.abs(5 * lines) then
      state.continuous_scroll = true
      state.relative_line = state.target_line - 2 * lines
    else
      state.target_line = state.target_line + lines
    end
    state.lines_to_scroll = to_scroll
    return
  end

  -- Check if the window and the cursor are allowed to scroll in that direction
  local data = utils.get_data()
  local half_window = math.floor(data.window_height / 2)
  if utils.get_scrolloff() >= half_window then
    state.cursor_win_line = half_window
  elseif data.win_lines_above_cursor <= utils.get_scrolloff() then
    state.cursor_win_line = utils.get_scrolloff() + 1
  elseif data.win_lines_below_cursor <= utils.get_scrolloff() then
    state.cursor_win_line = data.window_height - utils.get_scrolloff()
  else
    state.cursor_win_line = data.cursor_win_line
  end

  local scroll_window, scroll_cursor = scroller.who_scrolls(data, move_cursor, lines)
  -- If neither the window nor the cursor are allowed to scroll finish early
  if not scroll_window and not scroll_cursor then
    return
  end

  -- Preparation before scrolling starts
  scroller.before_scrolling(lines, move_cursor, info)

  local opts = config.options

  -- If easing function is not specified default to easing_function
  local ef = easing_function and easing_function or opts.easing_function

  state.lines_to_scroll = state.relative_line - state.target_line

  scroller.scroll_one_line(scroll_window, scroll_cursor, data)
  if state.lines_to_scroll == 1 then
    scroller.stop_scrolling(move_cursor, info)
  end

  local lts = math.abs(state.lines_to_scroll)
  local time_step = scroller.compute_time_step(lts, lines, time, ef)
  local next_time_step = scroller.compute_time_step(lts - 1, lines, time, ef)
  local next_next_time_step = scroller.compute_time_step(lts - 2, lines, time, ef)
  -- Scroll the first line

  -- Callback function triggered by scroll_timer
  local function scroll_callback()
    state.lines_to_scroll = state.relative_line - state.target_line

    data = utils.get_data()

    scroll_window, scroll_cursor = scroller.who_scrolls(data, move_cursor, lts)
    if not scroll_window and not scroll_cursor then
      return scroller.stop_scrolling(move_cursor, info)
    end

    if lts > 2 and ef then
      local next_lines_to_scroll = lts - 2
      next_time_step = scroller.compute_time_step(next_lines_to_scroll, lines, time, ef)
      -- sets the repeat of the next cycle
      state.scroll_timer:set_repeat(next_time_step)
    elseif lts == 0 then
      return scroller.stop_scrolling(move_cursor, info)
    else
      scroller.scroll_one_line(scroll_window, scroll_cursor, data)
      if lts == 1 then
        return scroller.stop_scrolling(move_cursor, info)
      end
    end
  end

  -- Start timer to scroll the rest of the lines
  state.scroll_timer:start(time_step, next_time_step, vim.schedule_wrap(scroll_callback))
  state.scroll_timer:set_repeat(next_next_time_step)
end

function neoscroll.init(custom_opts)
  config.set_options(custom_opts)
  config.set_mappings()
  local opts = config.options
  vim.cmd('command! NeoscrollEnablePM let b:neoscroll_performance_mode = v:true')
  vim.cmd('command! NeoscrollDisablePM let b:neoscroll_performance_mode = v:false')
  vim.cmd('command! NeoscrollEnableBufferPM let b:neoscroll_performance_mode = v:true')
  vim.cmd('command! NeoscrollDisableBufferPM let b:neoscroll_performance_mode = v:false')
  vim.cmd('command! NeoscrollEnableGlobalPM let g:neoscroll_performance_mode = v:true')
  vim.cmd('command! NeoscrollDisablGlobalePM let g:neoscroll_performance_mode = v:false')
  if opts.performance_mode then
    vim.g.neoscroll_performance_mode = true
  end
end

return neoscroll
