local output = require('stats.output')

local all = function(view, _, records)
  view = view or 'logfile'
  local lines = records.tree
  output[view](lines, 'All Keys Tree')
end

local wk_todo = function(view, _, records)
  view = view or 'logfile'
  local lines = records.tree
  output[view](lines, 'Whichkey Todo Keys Tree')
end

local wk_conflicts = function(view, _, records)
  view = view or 'logfile'
  local lines = records.tree
  output[view](lines, 'Whichkey Conflicts Keys Tree')
end

local wk_ok = function(view, _, records)
  view = view or 'logfile'
  local lines = records.tree
  output[view](lines, 'Whichkey Ok Keys Tree')
end

local mapper_todo = function(view, _, records)
  view = view or 'logfile'
  local lines = records.tree
  output[view](lines, 'Mapper TODO Keys Tree')
end

local mapper = function(view, _, records)
  view = view or 'logfile'
  local lines = records.tree
  output[view](lines, 'Mapper Keys Tree')
end

local neovim_todo = function(view, _, records)
  view = view or 'logfile'
  local lines = records.tree
  output[view](lines, 'Neovim TODO Keys Tree')
end

local neovim = function(view, _, records)
  view = view or 'logfile'
  local lines = records.tree
  output[view](lines, 'Neovim Keys Tree')
end

local stats = function(args, stats, records)
  local cmd_map = {
    neovim = neovim,
    neovim_todo = neovim_todo,
    mapper = mapper,
    mapper_todo = mapper_todo,
    wk_conflicts = wk_conflicts,
    wk_ok = wk_ok,
    wk_todo = wk_todo,
  }
  if cmd_map[args[3]] then
    cmd_map[args[3]](args[4], stats, records)
  else
    all(args[3], stats, records)
  end
end

return { stats = stats }
