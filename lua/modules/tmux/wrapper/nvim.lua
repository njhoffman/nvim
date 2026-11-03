local M = {}
function M.is_nvim_border(border)
  return M.winnr() == M.winnr("1" .. border)
end

function M.wincmd(direction, count)
  return vim.api.nvim_command((count or 1) .. "wincmd " .. direction)
end

function M.winnr(direction)
  return vim.api.nvim_call_function("winnr", { direction })
end

function M.win_move_separator(winnr, offset)
  vim.fn.win_move_separator(winnr, offset)
end

function M.win_move_statusline(winnr, offset)
  vim.fn.win_move_statusline(winnr, offset)
end

return M
