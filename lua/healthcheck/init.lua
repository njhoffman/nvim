local keymap = require("healthcheck.keymap")
local envmap = require("healthcheck.envmap")
local plugins = require("healthcheck.plugins")

function M.check_health()
  vim.fn["health#report_start"]("Nick: checking keymap statistics")
  keymap.stats(true)
  vim.fn["health#report_start"]("Nick: checking environment statistics")
  envmap.stats(true)
  vim.fn["health#report_ok"]("YOU ARE SO AWESOME")
  -- vim.fn["health#report_start"]("Nick: checking plugin statistics")
  -- plugins.stats()
  -- vim.fn["health#report_start"]("Nick: checking system statistics")
  -- vim.fn["health#report_error"](msg)
  -- vim.fn["health#report_warn"](msg)
  -- vim.fn["health#report_info"](msg)
end

return M
