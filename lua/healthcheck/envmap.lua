
local M = {}
local environment = require('stats.environment')

function M.environment_stats()
  local env_counts = environment.stats()
  print(vim.inspect(env_counts))
end

return M
