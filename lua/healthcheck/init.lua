local keymap = require("healthcheck.keymap")
local envmap = require("healthcheck.envmap")
local plugins = require("healthcheck.plugins")


function M.check_health()
  vim.fn["health#report_start"]("Nick: checking keymap statistics")
  keymap.stats()
  -- vim.fn["health#report_start"]("Nick: checking environment statistics")
  -- envmap.environment_stats()
  vim.fn["health#report_start"]("Nick: checking plugin statistics")
  plugins.stats()
  -- vim.fn["health#report_start"]("Nick: checking system statistics")
  -- vim.fn["health#report_error"](msg)
  -- vim.fn["health#report_warn"](msg)
  -- vim.fn["health#report_info"](msg)
    -- vim.fn["health#report_ok"](msg)

end

return M
