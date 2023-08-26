local M = {}
function M.check()
  vim.health.start('local health check')
  if true then
    vim.health.ok('Setup is correct')
  else
    vim.health.error('Setup is incorrect')
  end
end

return M
