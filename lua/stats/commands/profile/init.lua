local output = require('stats.output')

local stats_overview = function(view)
  view = view or 'notify'
  local lines = { 'Modules', 'Extmarks' }
  output[view](lines, 'Profile Overview')
end

local stats = function(args)
  local cmd_map = {
    modules = require('stats.commands.profile.modules').stats,
    extmarks = require('stats.commands.profile.extmarks').stats,
  }
  if cmd_map[args[2]] then
    cmd_map[args[2]](args)
  else
    stats_overview(args[2])
  end
end

return { stats = stats }
