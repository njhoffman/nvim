local output = require('stats.output')
local stats_track = function() end

local keys_overview = function(view, stats)
  view = view or 'notify'
  local lines = {
    stats.mapper.total .. ' mapper',
    stats.neovim.total .. ' neovim',
    stats.whichkey.ok.total .. ' whichkey',
  }
  output[view](lines, 'Keys Overview')
end

local stats = function(args)
  local records = require('mapper.records')
  local stats = require('mapper.stats').get_stats()
  local cmd_map = {
    tree = require('stats.commands.keys.tree').stats,
    list = require('stats.commands.keys.list').stats,
    table = require('stats.commands.keys.table').stats,
  }

  if cmd_map[args[2]] then
    cmd_map[args[2]](args[3], stats, records)
  else
    keys_overview(args[2], stats)
  end
end

return {
  stats = stats,
  stats_track = stats_track,
}
