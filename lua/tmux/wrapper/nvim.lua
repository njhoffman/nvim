local M = {}
function M.is_nvim_border(border)
  return M.winnr() == M.winnr("1" .. border)
end

function M.resize(axis, direction, step_size)
  vim.g.minianimate_disable = true
  local command = "resize "
  if axis == "x" then
    command = "vertical resize "
  end
  local resize_result = vim.api.nvim_command(command .. direction .. step_size)
  vim.g.minianimate_disable = false
  return resize_result
end

function M.wincmd(direction, count)
  return vim.api.nvim_command((count or 1) .. "wincmd " .. direction)
end

function M.winnr(direction)
  return vim.api.nvim_call_function("winnr", { direction })
end

return M
