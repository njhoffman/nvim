local austats = require("stats.commands.aucommands")
local envstats = require("stats.commands.environment")
local keystats = require("stats.commands.keystats")

function reformatInt(i)
  return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local get_items = function()
  local env_counts = envstats.get_counts()
  local au_counts = austats.get_counts()
  local key_counts = keystats.get_counts()

  local items = {
    string.format("Filetype         %8s", env_counts.filetype),
    string.format("Startup Time     %8s", env_counts.startup_time),
    string.format("Memory (RSS)     %8s", reformatInt(env_counts.memory)),
    string.format("Memory (VSZ)     %8s", reformatInt(env_counts.virtual_memory)),
    string.format("Plugins          %8s", reformatInt(env_counts.plugins)),
    string.format("Plugins Size     %8s", env_counts.plugins_size),
    string.format("AuGroups         %8s", reformatInt(au_counts.groups)),
    string.format("AuCommands       %8s", reformatInt(au_counts.commands)),
    string.format("Commands         %8s", reformatInt(env_counts.commands)),
    string.format("History          %8s", reformatInt(env_counts.history_commands)),
    string.format("Functions        %8s", reformatInt(env_counts.functions)),
    string.format("Highlights       %8s", reformatInt(env_counts.highlights)),
    string.format("Scriptnames      %8s", reformatInt(env_counts.scriptnames)),
    string.format("Syntax Items     %8s", reformatInt(env_counts.syntax_items)),
    string.format("Variables        %8s", reformatInt(env_counts.variables)),
    string.format("Messages         %8s", reformatInt(env_counts.messages)),
    string.format("Changes          %8s", reformatInt(env_counts.changes)),
    string.format("NvimMapper Keys  %8s", reformatInt(key_counts.mapper.total)),
    string.format("WhichKey         %8s", reformatInt(key_counts.whichkey.total)),
    string.format("Total Mapped     %8s", reformatInt(key_counts.neovim.total)),
  }
  return items
end

local stats_select = function(items, opts, cb)
  opts.prompt = opts.prompt or "Title Test"
  local backend_opts = {
    position = "50%",
    relative = "editor",
    border = {
      style = "rounded",
    },
    min_width = 15,
    min_height = 1,
    max_width = 120,
    max_height = 40,
  }
  require("dressing.select.nui").select(backend_opts, items, opts, cb)
  -- vim.ui.select(, opts, cb)
end

local fetch_stats = function()
  local stat_items = get_items()
  stats_select(stat_items, {
    prompt = "Stats",
    format_item = function(item)
      return item
    end,
  }, function(choice)
    print(choice)
  end)
end

return {
  fetch_stats = fetch_stats,
}
