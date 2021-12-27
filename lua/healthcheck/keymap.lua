local keystats = require("stats.keymaps")

local M = {}

local function length(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function M.stats()
  local stats = keystats.stats()

  print("                    total  normal  visual  insert  operator  command ")
  print("---------------------------------------------------------------------")
  print(("neovim               %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.neovim.total, stats.neovim.normal, stats.neovim.visual, stats.neovim.insert, stats.neovim.operator, stats.neovim.command))
  print(("mapper               %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.mapper.total, stats.mapper.normal, stats.mapper.visual, stats.mapper.insert, stats.mapper.operator, stats.mapper.command))
  print(("whichkey             %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.whichkey.total, stats.whichkey.normal, stats.whichkey.visual, stats.whichkey.insert, stats.whichkey.operator, stats.whichkey.command))
  print(("whichkey todo        %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.whichkey_todo.total, stats.whichkey_todo.normal, stats.whichkey_todo.visual, stats.whichkey_todo.insert, stats.whichkey_todo.operator, stats.whichkey_todo.command))
  print(("conflicts            %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.conflicts.total, stats.conflicts.normal, stats.conflicts.visual, stats.conflicts.insert, stats.conflicts.operator, stats.conflicts.command))
  print(("duplicates           %4d    %4d     %4d     %4d     %4d     %4d     "):format(stats.duplicates.total, stats.duplicates.normal, stats.duplicates.visual, stats.duplicates.insert, stats.duplicates.operator, stats.duplicates.command))
end

M.stats()
return M
