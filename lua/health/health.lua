-- local keys = require("health.keystats")
local envs = require('health.envstats')
-- local plugins = require("health.pluginstats")

local M = {}
function M.check()
  vim.health.report_start('checking keymap statistics')
  keys.stats(true)
  vim.health.report_ok('KeyMap Stats Finished')

  vim.health.report_start('checking environment statistics')
  envs.stats(true)
  vim.health.report_ok('Environment Stats Finished')
  -- vim.fn["health#report_start"]("Nick: checking plugin statistics")
  -- plugins.stats()
  -- vim.fn["health#report_start"]("Nick: checking system statistics")
  -- vim.fn["health#report_error"](msg)
  -- vim.fn["health#report_warn"](msg)
  -- vim.fn["health#report_info"](msg)
end

return M
