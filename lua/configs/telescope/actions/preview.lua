local action_state = require('telescope.actions.state')
local state = require('telescope.state')

local preview_scroll_line = function(prompt_bufnr, delta)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)
  if picker and picker.previewer and status.preview_win and vim.api.nvim_win_is_valid(status.preview_win) then
    local previewer = picker.previewer
    -- Check if we actually have a previewer and a preview window
    if type(previewer) ~= 'table' or status.preview_win == nil then
      return
    end

    local input = delta  > 0 and 'j' or 'k'
    local count = math.abs(delta)

    vim.api.nvim_win_call(status.preview_win, function()
      -- vim.cmd([[ execute "normal! \<Plug>(SmoothieDownwards)" ]])
      vim.cmd('normal ' .. count .. input)
    end)
  end
end

-- docs_view.scroll = function(self, delta)
--   if self:visible() then
--     local info = vim.fn.getwininfo(self.window.win)[1] or {}
--     local top = info.topline or 1
--     top = top + delta
--     top = math.max(top, 1)
--     top = math.min(top, self.window:get_content_height() - info.height + 1)
--
--     vim.defer_fn(function()
--       vim.api.nvim_buf_call(self.window:get_buffer(), function()
--         vim.api.nvim_command('normal! ' .. top .. 'zt')
--         self.window:update()
--       end)
--     end, 0)
--   end
-- end
--

local M = {}
M.preview_scroll_up = function(prompt_bufnr)
  preview_scroll_line(prompt_bufnr, -1)
end

M.preview_scroll_down = function(prompt_bufnr)
  preview_scroll_line(prompt_bufnr, 1)
end

M.preview_page_up = function(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)
  local preview_height = vim.api.nvim_win_get_height(status.layout.preview.winid)
  preview_scroll_line(prompt_bufnr, -preview_height)
end

M.preview_page_down = function(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)
  local preview_height = vim.api.nvim_win_get_height(status.layout.preview.winid)
  preview_scroll_line(prompt_bufnr, preview_height)
end

M.preview_toggle_wrap = function(prompt_bufnr)
  -- local picker = action_state.get_current_picker(prompt_bufnr)
  -- local results_height = vim.api.nvim_win_get_height(picker.results_win)
  local status = state.get_status(prompt_bufnr)
  local previewer = action_state.get_current_picker(prompt_bufnr).previewer
  local preview_winid = status.layout.preview and status.layout.preview.winid
  -- Check if we actually have a previewer and a preview window
  if type(previewer) ~= 'table' or previewer.scroll_fn == nil or preview_winid == nil then
    return
  end
  vim.api.nvim_win_set_option(preview_winid, 'wrap', not vim.api.nvim_win_get_option(preview_winid, 'wrap'))
end

return M
