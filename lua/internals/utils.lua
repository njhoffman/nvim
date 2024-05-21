local M = {}

M.async = function(func)
  return coroutine.create(function(...)
    func(...)
  end)
end

return M
