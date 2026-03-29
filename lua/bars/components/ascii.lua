--- ASCII component.
--- Shows hex character code under cursor.
---@module "bars.components.ascii"


local M = {}

--- Returns the hex character code under cursor for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  local charcode = ""

  vim.api.nvim_win_call(window, function()
    charcode = string.gsub(vim.fn.execute("normal! g8"), "\n", "")
  end)

  if #charcode < 3 then
    return "0x" .. charcode
  end

  return charcode or ""
end

return M
