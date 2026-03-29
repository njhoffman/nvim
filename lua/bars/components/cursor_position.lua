--- Cursor position component.
--- Shows cursor position as line:col.
---@module "bars.components.cursor_position"


local M = {}

--- Returns the cursor position for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  local line, col

  vim.api.nvim_win_call(window, function()
    line = vim.fn.line(".")
    col = vim.fn.col(".")
  end)

  return string.format("%d:%d", line or 0, col or 0)
end

return M
