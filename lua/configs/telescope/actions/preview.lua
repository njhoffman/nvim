local action_state = require("telescope.actions.state")
local state = require("telescope.state")

local preview_scroll_line = function(prompt_bufnr, winid, delta)
  if winid and vim.api.nvim_win_is_valid(winid) then
    local input = delta > 0 and "gj" or "gk"
    local count = math.abs(delta)
    vim.api.nvim_win_call(winid, function()
      vim.cmd('execute "silent! normal! ' .. count .. input .. '"')
    end)
  end
end

local preview_scroll_page = function(prompt_bufnr, delta)
  local status = state.get_status(prompt_bufnr)
  local winid = vim.tbl_get(status, "layout", "preview", "winid")
  if not winid or not vim.api.nvim_win_is_valid(winid) then
    return
  end

  local ok, smoothie = pcall(require, "smoothie")
  if ok and smoothie.config and smoothie.config.enabled then
    if delta > 0 then
      smoothie.downwards(winid)
    else
      smoothie.upwards(winid)
    end
  else
    local preview_height = vim.api.nvim_win_get_height(winid)
    preview_scroll_line(prompt_bufnr, winid, delta * preview_height)
  end
end

local M = {}
M.preview_scroll_up = function(prompt_bufnr)
  preview_scroll_line(prompt_bufnr, -1)
end

M.preview_scroll_down = function(prompt_bufnr)
  preview_scroll_line(prompt_bufnr, 1)
end
M.preview_page_down = function(prompt_bufnr)
  preview_scroll_page(prompt_bufnr, 1)
end
M.preview_page_up = function(prompt_bufnr)
  preview_scroll_page(prompt_bufnr, -1)
end

M.preview_toggle_wrap = function(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)
  local previewer = action_state.get_current_picker(prompt_bufnr).previewer
  local preview_winid = status.layout.preview and status.layout.preview.winid
  -- Check if we actually have a previewer and a preview window
  if type(previewer) ~= "table" or previewer.scroll_fn == nil or preview_winid == nil then
    return
  end
  vim.api.nvim_set_option_value("wrap", not vim.api.nvim_get_option_value("wrap", { win = preview_winid }), { win = preview_winid })
end

return M
