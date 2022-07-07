local keymap = require("health.keymap")
local envmap = require("health.envmap")
local plugins = require("health.plugins")

local M = {}
function M.check()
  vim.fn["health#report_start"]("checking keymap statistics")
  keymap.stats(true)
  vim.fn["health#report_ok"]("KeyMap Stats Finished")
  vim.fn["health#report_start"]("checking environment statistics")
  envmap.stats(true)
  vim.fn["health#report_ok"]("Environment Stats Finished")
  -- vim.fn["health#report_start"]("Nick: checking plugin statistics")
  -- plugins.stats()
  -- vim.fn["health#report_start"]("Nick: checking system statistics")
  -- vim.fn["health#report_error"](msg)
  -- vim.fn["health#report_warn"](msg)
  -- vim.fn["health#report_info"](msg)
end

return M
