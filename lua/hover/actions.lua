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
  local winok, _ = pcall(vim.api.nvim_win_is_valid, state.winnr)
  -- TODO: stop cursor scroll when reaches scroll offset
  if winok then
    local linenr = vim.api.nvim_win_get_cursor(state.winnr)[1]
    local scrolloff = vim.api.nvim_get_option('scrolloff')
    local winheight = vim.api.nvim_win_get_height(state.winnr)
    if scroll_key == scroll_up then
      if linenr > scrolloff then
        vim.fn.win_execute(state.winnr, 'normal! ' .. scroll_key)
      end
    else
      if linenr < winheight - scrolloff then
        vim.fn.win_execute(state.winnr, 'normal! ' .. scroll_key)
      end
    end
    vim.fn.win_execute(state.winnr, 'normal! ' .. scroll_key)
  end
end

M.scroll_up = function()
  scroll_float(scroll_up)
end

M.scroll_down = function()
  scroll_float(scroll_down)
end

M.scroll_page_up = function()
  scroll_float(scroll_page_up)
end

M.scroll_page_down = function()
  scroll_float(scroll_page_down)
end
return M
