local M = {}

M.uc_first = function(str)
  return str:gsub('^%l', string.upper)
end

return M
