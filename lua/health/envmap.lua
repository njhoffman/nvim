local M = {}
local environment = require("stats.environment")

function M.stats(healthCheck)
  local s = environment.get_counts()
  local p = healthCheck and vim.health.report_info or print

  p("------------------------------")
  -- p(("startup time         %8s     "):format(s.start_time))
  p(("memory             %6s     "):format(s.memory))
  p(("virtual memory     %6s     "):format(s.virtual_memory))
  p(("packer lines         %4s     "):format(s.packer_lines))
  p(("plugins size         %4s     "):format(s.plugins_size))
  p(("changes              %4d     "):format(s.changes))
  p(("messages             %4d     "):format(s.messages))
  p(("commands             %4d     "):format(s.commands))
  p(("commands history     %4d     "):format(s.history_commands))
  p(("scriptnames          %4d     "):format(s.scriptnames))
  p(("variables            %4d     "):format(s.variables))
  p(("functions            %4d     "):format(s.functions))
  p(("syntax items         %4d     "):format(s.syntax_items))
  p(("highlights           %4d     "):format(s.highlights))
end

_G._stats_env = M.stats

return M
