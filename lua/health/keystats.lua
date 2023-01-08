local keystats = require("stats.commands.keystats")

local M = {}

local function length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function M.stats(healthCheck)
  local s = keystats.get_counts()
  local p = healthCheck and vim.health.report_info or print

  p("                 total normal visual insert operator command")
  p("--------------------------------------------------------------")
  p(("neovim            %4d   %4d   %4d   %4d    %4d    %4d "):format(s.neovim.total, s.neovim.normal, s.neovim.visual, s.neovim.insert, s.neovim.operator, s.neovim.command))
  p(("mapper            %4d   %4d   %4d   %4d    %4d    %4d "):format(s.mapper.total, s.mapper.normal, s.mapper.visual, s.mapper.insert, s.mapper.operator, s.mapper.command))
  p(("whichkey          %4d   %4d   %4d   %4d    %4d    %4d "):format(s.whichkey.total, s.whichkey.normal, s.whichkey.visual, s.whichkey.insert, s.whichkey.operator, s.whichkey.command))
  p(("whichkey todo     %4d   %4d   %4d   %4d    %4d    %4d "):format(s.whichkey_todo.total, s.whichkey_todo.normal, s.whichkey_todo.visual, s.whichkey_todo.insert, s.whichkey_todo.operator, s.whichkey_todo.command))
  p(("conflicts         %4d   %4d   %4d   %4d    %4d    %4d "):format(s.conflicts.total, s.conflicts.normal, s.conflicts.visual, s.conflicts.insert, s.conflicts.operator, s.conflicts.command))
  p(("duplicates        %4d   %4d   %4d   %4d    %4d    %4d "):format(s.duplicates.total, s.duplicates.normal, s.duplicates.visual, s.duplicates.insert, s.duplicates.operator, s.duplicates.command))
end

_G._stats_keys = M.stats

return M
