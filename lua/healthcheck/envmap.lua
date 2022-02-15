local M = {}
local environment = require("stats.environment")

function M.stats(healthCheck)
  local env_counts = environment.get_counts()
  local p = healthCheck and vim.fn["health#report_info"] or print
  p(vim.inspect(env_counts))
end

-- changes = 12,
-- commands = 773,
-- filetype = "lua",
-- functions = 2164,
-- highlights = 2994,
-- history_commands = 275,
-- memory = "255364",
-- menus = 92,
-- messages = 141,
-- options = 29,
-- packer_lines = "1649",
-- plugins_size = "930M",
-- scriptnames = 414,
-- start_time = "1225.760  000.006: --- NVIM STARTED ---",
-- syntax_items = 2015,
-- variables = 953,
-- virtual_memory = "382784"

return M
