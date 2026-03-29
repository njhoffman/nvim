--- Line percentage component.
--- Shows scroll position as Top/Bot/All/percentage.
---@module "bars.components.line_percentage"


local M = {}

--- Returns the scroll position for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  local current, total

  vim.api.nvim_win_call(window, function()
    current = vim.fn.line(".")
    total = vim.fn.line("$")
  end)

  if total == 1 then
    return "All"
  elseif current == 1 then
    return "Top"
  elseif current == total then
    return "Bot"
  else
    return string.format("%d%%%%", math.floor(current / total * 100))
  end
end

return M
