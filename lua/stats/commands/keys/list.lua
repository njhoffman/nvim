local output = require('stats.output')
local str_utils = require('plenary.strings')

local tolines = function(records)
  local lines = {}
  -- meta.category, label, plugin, source, time
  for _, record in pairs(records.list) do
    local line = '-- '
      .. record.mode
      .. ' '
      .. str_utils.align_str(record.lhs, 15)
      .. str_utils.align_str(record.meta.virtual and '<virtual>' or tostring(record.rhs), 15)
      .. (record.meta.desc or '')
    table.insert(lines, line)
  end
end

local all = function(view, _, records)
  view = view or 'logfile'
  local lines = tolines(records)
  output[view](lines, 'All Keys List')
end

local wk_todo = function(view, _, records)
  view = view or 'logfile'
  local lines = tolines(records)
  output[view](lines, 'Whichkey Todo Keys List')
end

local wk_conflicts = function(view, _, records)
  view = view or 'logfile'
  local lines = tolines(records)
  output[view](lines, 'Whichkey Conflicts Keys List')
end

local wk_ok = function(view, _, records)
  view = view or 'logfile'
  local lines = tolines(records)
  output[view](lines, 'Whichkey Ok Keys List')
end

local mapper_todo = function(view, _, records)
  view = view or 'logfile'
  local lines = tolines(records)
  output[view](lines, 'Mapper TODO Keys List')
end

local mapper = function(view, _, records)
  view = view or 'logfile'
  local lines = tolines(records)
  output[view](lines, 'Mapper Keys List')
end

local neovim_todo = function(view, _, records)
  view = view or 'logfile'
  local lines = tolines(records)
  output[view](lines, 'Neovim TODO Keys List')
end

local neovim = function(view, _, records)
  view = view or 'logfile'
  local lines = tolines(records)
  output[view](lines, 'Neovim Keys List')
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
