--- Scroll bar component.
--- Shows scroll position as block characters.
---@module "bars.components.scroll_bar"


local M = {}

---@type string[]
local chars = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }

--- Returns the scroll bar for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  local current, total

  vim.api.nvim_win_call(window, function()
    current = vim.fn.line(".")
    total = vim.fn.line("$")
  end)

  if total == 0 then
    total = 1
  end

  local index = math.ceil(current / total * #chars)
  index = math.max(1, math.min(index, #chars))

  local char = chars[index]

  return char .. char
end

return M
