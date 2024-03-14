local without = require('utils.lodash')
local ns = require('neoscroll')

local tbl_omit = function(t, keys_to_remove)
  local has_value = function(tab, val)
    for _, value in ipairs(tab) do
      if value == val then
        return true
      end
    end

    return false
  end

  local res = {}

  for k, v in pairs(t) do
    if type(k) ~= 'table' then
      if not has_value(keys_to_remove, k) then
        res[k] = v
      end
    end
  end

  return res
end
local function rel_time(n)
  local win_height = vim.fn.winheight(0)
  n = n or win_height
  if n % 1 ~= 0 then
    n = n * win_height
  end
  -- n is the numof lines we want to scroll
  local lines_ratio = n / win_height
  local threshold = 46 -- windows smaller thant this scroll faster
  local win_ratio = win_height / threshold
  local factor = win_ratio * lines_ratio
  local log_factor = 1 / math.log(1 / factor + 1, 2)
  local time = 300 * log_factor
  print(time)
  return time
end
-- If the delay for scrolling one line would be too small, we want to scroll
-- multiple lines at the same time.
-- For example, if the delay is 0.25ms and the smallest delay is 0.5ms, we want
-- to scroll 2 lines instead of one.
local calculate_lines_to_scroll_at_once = function(delay_length)
  local divided = config.smallest_delay_per_frame / delay_length
  local times_to_scroll = delay_length >= config.smallest_delay_per_frame and 1 or math.ceil(divided)

  return times_to_scroll
end
local lines_to_scroll_at_once = calculate_lines_to_scroll_at_once(delay_length)
-- Make sure that we don't over-scroll
local lnum_difference = lnum - prev_lnum
local times_to_scroll = math.min(lnum_difference, lines_to_scroll_at_once)

vim.cmd('norm! ' .. times_to_scroll .. 'j')

local scroll_screen = function(delay_length, target_line)
  target_line = target_line or math.ceil(vim.api.nvim_win_get_height(0) / 2)
  if target_line == -1 then
    return
  end

  local prev_line = vim.fn.winline()

  -- Scroll the cursor up.
  while vim.fn.winline() > target_line do
    vim.cmd('norm! ' .. t('<C-e>'))
    local new_line = vim.fn.winline()
    create_delay(delay_length)
    if new_line == prev_line then
      break
    end
    prev_line = new_line
  end

  -- Scroll the cursor down.
  while vim.fn.winline() < target_line do
    vim.cmd('norm! ' .. t('<C-y>'))
    local new_line = vim.fn.winline()
    create_delay(delay_length)
    if new_line == prev_line then
      break
    end
    prev_line = new_line
  end
end

fn.scroll_wheel_vertically = function(command, distance, curpos, winline, delay_length)
  -- If line number and winline don't need to be changed, return.
  if distance == 0 and (vim.fn.winline() == winline) then
    return
  end

  local lnum = curpos[2]

  if command == t('<ScrollWheelDown>') then
    -- Scroll down.
    while vim.fn.getcurpos()[2] < lnum or vim.fn.winline() > winline do
      -- Check if movement ends in the current fold.
      if vim.fn.foldclosedend('.') ~= -1 and vim.fn.foldclosedend('.') > lnum then
        vim.fn.setpos('.', curpos)
        return
      end

      local prev_lnum = vim.fn.getcurpos()[2]
      local prev_winline = vim.fn.winline()

      -- TODO: Find alternative method.
      -- Stop scrolling past the bottom of the file due to bug with winrestview and scrolloff.
      local offset = 0
      local i = prev_lnum
      while i <= prev_lnum + vim.fn.winheight('.') - vim.fn.winline() + offset + 1 do
        -- Return if the current line doesn't exist.
        if not vim.fn.getbufline(vim.fn.bufname(), i)[1] then
          return
        end

        -- If fold found, jump over it.
        if vim.fn.foldclosedend(i) ~= -1 then
          local fold_size = vim.fn.foldclosedend(i) - i
          offset = offset + fold_size
          i = i + fold_size
        end

        i = i + 1
      end

      vim.cmd('norm! ' .. t('<C-e>'))

      -- Break if line number and winline not changing.
      if vim.fn.getcurpos()[2] == prev_lnum and vim.fn.winline() == prev_winline then
        break
      end

      create_delay(delay_length)
    end
  elseif command == t('<ScrollWheelUp>') then
    -- Scroll up.
    while vim.fn.getcurpos()[2] > lnum or vim.fn.winline() < winline do
      -- Check if movement ends in the current fold.
      if vim.fn.foldclosedend('.') ~= -1 and vim.fn.foldclosedend('.') < lnum then
        vim.fn.setpos('.', curpos)
        return
      end

      local prev_lnum = vim.fn.getcurpos()[2]
      local prev_winline = vim.fn.winline()

      vim.cmd('norm! ' .. t('<C-y>'))

      -- Break if line number and winline not changing.
      if vim.fn.getcurpos()[2] == prev_lnum and vim.fn.winline() == prev_winline then
        break
      end

      create_delay(delay_length)
    end
  end
end
-- If the delay for scrolling one line would be too small, we want to scroll
-- multiple lines at the same time.
-- For example, if the delay is 0.25ms and the smallest delay is 0.5ms, we want to scroll 2 lines instead of one.
local calculate_lines_to_scroll_at_once = function(delay_length)
  local divided = config.smallest_delay_per_frame / delay_length
  local times_to_scroll = delay_length >= config.smallest_delay_per_frame and 1 or math.ceil(divided)

  return times_to_scroll
end

-- If the delay for scrolling one line would be too small, we want to scroll
-- multiple lines at the same time.
-- For example, if the delay is 0.25ms and the smallest delay is 0.5ms, we want
-- to scroll 2 lines instead of one.
local calculate_lines_to_scroll_at_once = function(delay_length)
  local divided = config.smallest_delay_per_frame / delay_length
  local times_to_scroll = delay_length >= config.smallest_delay_per_frame and 1 or math.ceil(divided)

  return times_to_scroll
end

local scroll_down = function(curpos, scroll_win, delay_length, scrolloff)
  local lnum = curpos[2]
  local win_height = vim.api.nvim_win_get_height(0)

  -- Center the screen.
  local half_height = math.ceil(win_height / 2)
  if vim.fn.winline() > half_height and scroll_win and config.centered then
    scroll_screen(delay_length)
  end

  local lines_to_scroll_at_once = calculate_lines_to_scroll_at_once(delay_length)

  -- Scroll.
  while vim.fn.getcurpos()[2] < lnum do
    -- Check if movement ends in the current fold.
    if vim.fn.foldclosedend('.') ~= -1 and vim.fn.foldclosedend('.') > lnum then
      vim.fn.setpos('.', curpos)
      return
    end

    local prev_lnum = vim.fn.getcurpos()[2]

    -- Make sure that we don't over-scroll
    local lnum_difference = lnum - prev_lnum
    local times_to_scroll = math.min(lnum_difference, lines_to_scroll_at_once)

    vim.cmd('norm! ' .. times_to_scroll .. 'j')

    local current_winline = vim.fn.winline()

    if scroll_win then
      if config.centered then
        local offset_from_center = current_winline - half_height
        if offset_from_center > 0 then
          vim.cmd('norm! ' .. offset_from_center .. t('<C-e>'))
        end
      else
        -- Scroll the window if the current line is not within 'scrolloff'.
        if current_winline > scrolloff + 1 and current_winline < win_height - scrolloff then
          vim.cmd('norm! ' .. t('<C-e>'))
        end
      end
    end

    -- Break if line number not changing.
    if vim.fn.getcurpos()[2] == prev_lnum then
      break
    end

    create_delay(delay_length)
  end
end
fn.scroll_horizontally = function(column, wincol, delay_length)
  if wincol == -1 and column == -1 then
    return
  end

  -- Scroll the cursor horizontally.
  if column ~= -1 then
    local prev_column = vim.fn.getcurpos()[3]
    while vim.fn.getcurpos()[3] < column do
      vim.cmd('norm! l')
      create_delay(delay_length)
      if vim.fn.getcurpos()[3] == prev_column then
        break
      end
    end
    while vim.fn.getcurpos()[3] > column do
      vim.cmd('norm! h')
      create_delay(delay_length)
      if vim.fn.getcurpos()[3] == prev_column then
        break
      end
    end
  end

  -- Scroll the screen horizontally.
  if wincol ~= -1 then
    local prev_wincol = vim.fn.wincol()

    while vim.fn.wincol() > wincol do
      vim.cmd('norm! zl')
      local new_wincol = vim.fn.wincol()
      create_delay(delay_length)
      if new_wincol == prev_wincol then
        break
      end
      prev_wincol = new_wincol
    end

    while vim.fn.wincol() < wincol do
      vim.cmd('norm! zh')
      local new_wincol = vim.fn.wincol()
      create_delay(delay_length)
      if new_wincol == prev_wincol then
        break
      end
      prev_wincol = new_wincol
    end
  end
end

-- Center the screen.
local half_height = math.ceil(win_height / 2)
if vim.fn.winline() > half_height and scroll_win and config.centered then
  scroll_screen(delay_length)
end

-- nnoremap n :execute "keepjumps norm! " . v:count1 . "nzz"
-- nnoremap N :execute "keepjumps norm! " . v:count1 . "Nzz"
--
-- t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '100' } }
-- t['<PageUp>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '100' } }
-- t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '100' } }
-- t['<PageDown>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '100' } }
--
-- local api = vim.api
-- -- My workaround for this: (only smooth scroll if buffer is longer than window height)
-- vim.keymap.set('n', 'G', [[<Cmd> lua maybe_smooth_scroll()<CR>]], { noremap = true })
--
-- function _G.maybe_smooth_scroll()
--   local win_height = api.nvim_win_get_height(0)
--   local buf_line_count = api.nvim_buf_line_count(0)
--
--   if buf_line_count < win_height then
--     api.nvim_command('normal! G')
--   else
--     require('neoscroll').scroll(1 * buf_line_count, true, 1, 5)
--   end
-- end
--
-- local function map_key(lhs, rhs)
--   vim.keymap.set({ 'x', 'n' }, lhs, rhs)
-- end
--
-- local state = require('neoscroll.state')
-- ns.scroll(200, true, 500, 'sine', [[cursorline]])
--
-- local state = require('neoscroll.state')
-- vim.dbglog('state', tbl_omit(state, { 'history' }))
--
-- -- map_key("<C-u>", function()
-- --     neoscroll.scroll(-vim.wo.scroll, true, rel_time(vim.wo.scroll))
-- -- end)
-- --
-- -- map_key("<C-d>", function()
-- --     neoscroll.scroll(vim.wo.scroll, true, rel_time(vim.wo.scroll))
-- -- end)
--
-- t['gg'] = { 'scroll', { '-2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }
-- t['G'] = { 'scroll', { '2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }
-- --
-- -- -- other mappings ...
-- --
-- -- map_key("zz", function()
-- --     neoscroll.zz(rel_time(0.33))
-- -- end)
