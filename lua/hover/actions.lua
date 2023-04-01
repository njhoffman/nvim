local vim = vim
local state = require("hover.state")
local M = {}

-- open up a select box with all available providers

local change_tab = function(direction)
  local max_idx = #vim.tbl_keys(state.enabled)
  local next_idx = nil
  local curr_idx = nil
  local i = 1
  for _, provider in pairs(state.enabled) do
    if provider.name == state.provider then
      curr_idx = i
    end
    i = i + 1
  end
  if direction == "right" then
    if curr_idx + 1 > max_idx then
      next_idx = 1
    else
      next_idx = curr_idx + 1
    end
  else
    if curr_idx - 1 < 1 then
      next_idx = max_idx
    else
      next_idx = curr_idx - 1
    end
  end

  i = 1
  local next_provider = nil
  for _, provider in pairs(state.enabled) do
    if i == next_idx then
      next_provider = provider
    end
    i = i + 1
  end
  require("hover").hover({ provider = next_provider.name })
end

M.change_tab_left = function()
  change_tab("left")
end

M.change_tab_right = function()
  change_tab("right")
end

local scroll_down = vim.api.nvim_replace_termcodes("<Down>", true, false, true)
local scroll_up = vim.api.nvim_replace_termcodes("<Up>", true, false, true)

local scroll_float = function(mapping, winnr)
  if winnr and winnr ~= 0 and vim.api.nvim_win_is_valid(winnr) then
    local scroll_key = vim.api.nvim_replace_termcodes(mapping, true, false, true)
    if mapping == scroll_up then
      local linenr = vim.api.nvim_win_get_cursor(winnr)[1]
      local scrolloff = vim.api.nvim_get_option("scrolloff")
      local winheight = vim.api.nvim_win_get_height(winnr)
      if linenr > (winheight - scrolloff - 2) then
        vim.fn.win_execute(winnr, "normal! " .. scroll_key)
      end
    else
      vim.fn.win_execute(winnr, "normal! " .. scroll_key)
    end
  end
end

M.scroll_up = function(winnr)
  scroll_float(scroll_up, winnr)
end

M.scroll_down = function(winnr)
  vim.dbglog("scroll_down", winnr)
  scroll_float(scroll_down, winnr)
end

return M
