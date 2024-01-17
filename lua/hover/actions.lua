local vim = vim
local state = require('hover.state')
local M = {}

-- open up a select box with all available providers
local change_tab = function(direction)
  local max_idx = #vim.tbl_keys(state.enabled)
  local next_idx = nil
  local i = 1
  if direction == 'right' then
    if state.curr_idx + 1 > max_idx then
      next_idx = 1
    else
      next_idx = state.curr_idx + 1
    end
  else
    if state.curr_idx - 1 < 1 then
      next_idx = max_idx
    else
      next_idx = state.curr_idx - 1
    end
  end

  i = 1
  local next_provider = nil
  for _, provider_id in pairs(state.enabled) do
    if i == next_idx then
      for _, provider in ipairs(state.providers) do
        if provider.id == provider_id then
          next_provider = provider
        end
      end
    end
    i = i + 1
  end
  state.curr_idx = next_idx
  require('hover.providers').load_provider(next_provider)
end

M.change_tab_left = function()
  change_tab('left')
end

M.change_tab_right = function()
  change_tab('right')
end

local scroll_up = vim.api.nvim_replace_termcodes('<Up>', true, false, true)
local scroll_down = vim.api.nvim_replace_termcodes('<Down>', true, false, true)
local scroll_page_up = vim.api.nvim_replace_termcodes('<C-b>', true, false, true)
local scroll_page_down = vim.api.nvim_replace_termcodes('<C-f>', true, false, true)

local scroll_float = function(scroll_key)
  if type(state.winnr) == 'number' and vim.api.nvim_win_is_valid(state.winnr) then
    local linenr = vim.api.nvim_win_get_cursor(state.winnr)[1]
    local scrolloff = vim.api.nvim_get_option_value('scrolloff', { win = state.winnr })
    local bufheight = vim.api.nvim_buf_line_count(state.bufnr)
    if linenr < scrolloff then
      vim.fn.win_execute(state.winnr, 'normal! ' .. (scrolloff - linenr) .. scroll_down)
    end
    if scroll_key == scroll_up then
      if linenr > scrolloff then
        vim.fn.win_execute(state.winnr, 'normal! ' .. scroll_key)
      end
    else
      if linenr < bufheight - scrolloff then
        vim.fn.win_execute(state.winnr, 'normal! ' .. scroll_key)
      end
    end
  end
end

M.scroll_up = function()
  scroll_float(scroll_up)
end

M.scroll_down = function()
  scroll_float(scroll_down)
end

M.scroll_page_up = function()
  local winheight = vim.api.nvim_win_get_height(state.winnr) - 2
  for i = 1, winheight do
    vim.defer_fn(function()
      scroll_float(scroll_up)
    end, i * 30)
  end
end

M.scroll_page_down = function()
  local winheight = vim.api.nvim_win_get_height(state.winnr) - 2
  for i = 1, winheight do
    vim.defer_fn(function()
      scroll_float(scroll_down)
    end, i * 30)
  end
end

M.toggle_wrap = function()
  local wrap = vim.api.nvim_get_option_value('wrap', { win = state.winnr })
  vim.api.nvim_set_option_value('wrap', not wrap, { win = state.winnr })
end

M.toggle_full_size = function()
  local winwidth = vim.api.nvim_win_get_width(state.winnr) + 1
  local dims = {
    old_w = winwidth,
    old_h = state.height,
    new_w = winwidth == state.width_full and state.width or state.width_full,
    new_h = state.height,
  }
  require('hover.ui').resize_window(dims)
end

M.toggle_min_size = function()
  local winwidth = vim.api.nvim_win_get_width(state.winnr) + 1
  local winheight = vim.api.nvim_win_get_height(state.winnr) + 1
  local is_minimized = winwidth == state.width_minimized
  local dims = {
    old_w = winwidth,
    old_h = winheight,
    new_w = is_minimized and state.width or state.width_minimized,
    new_h = is_minimized and state.height or state.height_minimized,
  }
  require('hover.ui').resize_window(dims)
end

return M
