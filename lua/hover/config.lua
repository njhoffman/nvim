local keymaps = require("hover.keymaps")

local M = {}

local default_config = {
  behavior = "sticky", -- once, cursor
  border = "single",
  focusable = true,
  title = true,
  max_height = "40%",
  max_width = "70%",
  min_width = 10,
  min_height = 2,
  mapping = keymaps.default_mapping,
}
--
local config

function M.set(user_config)
  config = vim.tbl_deep_extend("force", default_config, user_config)
  return config
end

function M.get()
  return config
end

return M
