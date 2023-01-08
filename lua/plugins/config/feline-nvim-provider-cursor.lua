local M = {}
M.ascii = function(_, opts)
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local char = vim.api.nvim_get_current_line():sub(col + 1, col + 1)
  local code = string.byte(char)
  if code == nil then
    return ""
  end
  return tostring(code)
  -- return "0x" .. tostring(tonumber(code, 16))
end

return M
