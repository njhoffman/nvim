local utils = {}

-- Helper function to check if a number is a float
function utils.is_float(n)
  return math.floor(math.abs(n)) ~= math.abs(n)
end

function utils.get_lines_above(line)
  local lines_above = 0
  local first_folded_line = vim.fn.foldclosed(line)
  if first_folded_line ~= -1 then
    line = first_folded_line
  end
  while line > 1 do
    lines_above = lines_above + 1
    line = line - 1
    first_folded_line = vim.fn.foldclosed(line)
    if first_folded_line ~= -1 then
      line = first_folded_line
    end
  end
  return lines_above
end

function utils.get_lines_below(line)
  local last_line = vim.fn.line('$')
  local lines_below = 0
  local last_folded_line = vim.fn.foldclosedend(line)
  if last_folded_line ~= -1 then
    line = last_folded_line
  end
  while line < last_line do
    lines_below = lines_below + 1
    line = line + 1
    last_folded_line = vim.fn.foldclosedend(line)
    if last_folded_line ~= -1 then
      line = last_folded_line
    end
  end
  return lines_below
end

-- Collect all the necessary window, buffer and cursor data
-- vim.fn.line("w0") -> if there's a fold returns first line of fold
-- vim.fn.line("w$") -> if there's a fold returns last line of fold
function utils.get_data()
  local data = {}
  data.win_top_line = vim.fn.line('w0')
  data.win_bottom_line = vim.fn.line('w$')
  data.last_line = vim.fn.line('$')
  data.first_line_visible = data.win_top_line == 1
  data.last_line_visible = data.win_bottom_line == data.last_line
  data.window_height = vim.api.nvim_win_get_height(0)
  if vim.opt.winbar ~= '' then
    data.window_height = data.window_height - 1
  end
  data.cursor_win_line = vim.fn.winline()
  data.win_lines_below_cursor = data.window_height - data.cursor_win_line
  data.win_lines_above_cursor = data.cursor_win_line - 1
  data.win_bottom_line_eof = data.lines_below_cursor == data.win_lines_below_cursor
  if data.last_line_visible then
    data.lines_below_cursor = utils.get_lines_below(vim.fn.line('.'))
  end
  return data
end

-- Hide/unhide cursor during scrolling for a better visual effect
function utils.hide_cursor()
  if vim.o.termguicolors and vim.o.guicursor ~= '' then
    utils.guicursor = vim.o.guicursor
    vim.o.guicursor = 'a:NeoscrollHiddenCursor'
  end
end
function utils.unhide_cursor()
  if vim.o.guicursor == 'a:NeoscrollHiddenCursor' then
    vim.o.guicursor = utils.guicursor
  end
end

-- Transforms fraction of window to number of lines
function utils.get_lines_from_win_fraction(fraction)
  local height_fraction = fraction * vim.api.nvim_win_get_height(0)
  local lines
  if height_fraction < 0 then
    lines = -math.floor(math.abs(height_fraction) + 0.5)
  else
    lines = math.floor(height_fraction + 0.5)
  end
  return lines
end

function utils.get_scrolloff()
  local window_scrolloff = vim.wo.scrolloff
  if window_scrolloff == -1 then
    return vim.go.scrolloff
  else
    return window_scrolloff
  end
end
return utils

-- Calculate the delay length.
-- if config.max_length ~= -1 then
--   if math.abs(distance) * delay_length > config.max_length then
--     delay_length = math.floor((config.max_length / math.abs(distance)) + 0.5)
--   end
-- end

-- I just tried it, but I felt nothing but faster with the easing function. I didn't feel the easing.
--
-- If you want to "feel" the easing you'll need to change the default time-step range instead of the easing function. That is what I was trying to explain here:
--
-- There isn't, mainly because you need to also specify the first and last time-step of the scrolling animation as additional arguments and you probably never want to set those to the same value for all the commands as some movements are very long (c-f/c-b) and some are very short (c-e/c-y).
--
-- So for instance if you change the c-d/c-u easing mappings from the README to:
--
-- t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '7', '35', easing1}}
-- t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '7', '35', easing1}}
-- You'll now "feel" the easing more because it goes from a time-step of 7 ms to a time-step of 35 ms instead of 15 ms. The easing function only determines how the time-step goes from 7 ms to 35 ms. Of course, the higher the value of the last time-step the slower the animation will "feel" towards the end of the scrolling animation. I don't particularly like it that high because you can notice the line-by-line scrolling and it doesn't look as smooth to me but everyone has their own preferences.
--
-- So for example with function(x) return x end the time-step will decrease from 7 ms to 35 ms linearly whereas with function(x) return math.pow(x, 2) end the time-step will decrease from 7 ms to 35 ms quadratically, i.e. slow at the beginning and quickly at the end.
--
-- The function function(x) return 0.5 end returns a constant so in that case the time-step will be constant throughout the whole scrolling animation. This obviously is totally unnecessary because you don't need an easing function to obtain this scrolling animation.
--
-- BTW, IDK if the information "Scrolling with easing function" was used for debugging, but it's noisy and useless in real use.
--
-- You will need to elaborate on what do you mean by "noisy". I am using the defaults and they work just fine for me.
