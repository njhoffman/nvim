local action_state = require("telescope.actions.state")
local state = require("telescope.state")

local scroll = function(prompt_bufnr, delta)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local status = state.get_status(prompt_bufnr)

  local set_cursor = function(cursor_row)
    state.cursor.row = cursor_row
    vim.api.nvim_win_set_cursor(state.win, { cursor_row, 1 })
  end

  if
    picker
    and picker.previewer
    and status.preview_win
    and vim.api.nvim_win_is_valid(status.preview_win)
  then
    local previewer = picker.previewer
    -- Check if we actually have a previewer and a preview window
    if type(previewer) ~= "table" or status.preview_win == nil then
      local delta = 1

      local height = vim.api.nvim_win_get_height(state.win)
      local cursor = vim.api.nvim_win_get_cursor(state.win)

      vim.api.nvim_set_option_value("scrolloff", height, { win = state.win })
      local up = "gk"
      local down = "gj"
      local input = delta > 0 and down or up

      if input == up then
        cursor[1] = math.max(cursor[1] - delta, 1)
      else
        cursor[1] = math.min(
          cursor[1] + delta,
          vim.api.nvim_buf_line_count(state.buf) - math.ceil(height / 2) + 1
        )
        cursor[1] = math.max(cursor[1], math.ceil(height / 2) + 1)
      end
    end
    set_cursor(cursor[1])
  end
end

local preview_scroll_line = function(prompt_bufnr, winid, delta)
  if winid and vim.api.nvim_win_is_valid(winid) then
    local input = delta > 0 and "gj" or "gk"
    local count = math.abs(delta)
    vim.api.nvim_win_call(winid, function()
      -- vim.cmd([[ execute "normal! \<Plug>(SmoothieDownwards)" ]])
      -- vim.notify("exe:", count, input)
      vim.cmd('execute "silent! normal! ' .. count .. input .. '"')
      -- vim.cmd('silent normal ' .. count .. input)
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

local preview_scroll_page = function(prompt_bufnr, delta)
  local status = state.get_status(prompt_bufnr)
  local winid = vim.tbl_get(status, "layout", "preview", "winid")
  local preview_height = vim.api.nvim_win_get_height(winid)
  preview_scroll_line(prompt_bufnr, winid, delta * preview_height)
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
  -- local picker = action_state.get_current_picker(prompt_bufnr)
  -- local results_height = vim.api.nvim_win_get_height(picker.results_win)
  local status = state.get_status(prompt_bufnr)
  local previewer = action_state.get_current_picker(prompt_bufnr).previewer
  local preview_winid = status.layout.preview and status.layout.preview.winid
  -- Check if we actually have a previewer and a preview window
  if type(previewer) ~= "table" or previewer.scroll_fn == nil or preview_winid == nil then
    return
  end
  vim.api.nvim_win_set_option(
    preview_winid,
    "wrap",
    not vim.api.nvim_win_get_option(preview_winid, "wrap")
  )
end

return M
