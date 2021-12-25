local austats = require("stats.autocommands")
local envstats = require("stats.environment")


local M = {}
M.get_items = function()
  local env_counts = envstats.get_counts()
  local au_counts = austats.get_counts()

  local items = {
    string.format('Filetype           %6s' .. env_counts.filetype,
    string.format('Startup Time         %4s', env_counts.startup_time),
    string.format('Memory (RSS)       %6s',   env_counts.memory),
    string.format('Memory (VSZ)       %6s',   env_counts.virtual_memory),
    string.format('AuGroups             %4d', au_counts.groups),
    string.format('AuCommands           %4d', au_counts.commands),
  -- string.format('Changes              %4d', env_counts.changes),
    string.format('Commands             %4d', env_counts.commands),
    string.format('Functions            %4d', env_counts.functions),
    string.format('Highlights           %4d', env_counts.highlights),
  -- string.format('History              %4d', env_counts.history_commands),
  -- string.format('Menus                %4d', env_counts.menus),
    string.format('Messages             %4d', env_counts.messages),
    string.format('Scriptnames          %4d', env_counts.scriptnames),
  -- string.format('Options              %4d', env_counts.options),
    string.format('Syntax Items         %4d', env_counts.syntax_items),
    string.format('Variables            %4d', env_counts.variables),
    string.format('Packer Lines         %4s', env_counts.packer_lines),
    string.format('Plugins Size         %4s', env_counts.plugins_size),
  -- string.format('Lazy Plugins Size %4d', env_counts.plugins_size),
  }
  return items
end


return M
