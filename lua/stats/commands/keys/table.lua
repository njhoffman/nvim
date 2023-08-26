local output = require('stats.output')

local all = function(view, stats)
  view = view or 'logfile'
  local lines = {}
  local p = function(line)
    table.insert(lines, line)
  end

  p('             total normal visual insert operator command select term vis_sel')
  p('-----------------------------------------------------------------------------')

  local function gen_row(name, keymap)
    p(
      (name .. ' %4d   %4d   %4d   %4d    %4d   %4d   %4d   %4d   %4d'):format(
        keymap.total,
        keymap.normal,
        keymap.visual,
        keymap.insert,
        keymap.operator,
        keymap.command,
        keymap.select,
        keymap.terminal,
        keymap.vis_select
      )
    )
  end

  local s = stats.get_stats()
  gen_row('neovim      ', s.neovim)
  gen_row('mapper      ', s.mapper)
  gen_row('wk ok       ', s.whichkey.ok)
  gen_row('wk todo     ', s.whichkey.todo)
  gen_row('wk dupes    ', s.whichkey.duplicates)
  gen_row('wk conflicts', s.whichkey.conflicts)
  output[view](lines, 'Keys Table')
end

local neovim = function(view, stats) end
local neovim_todo = function(view, stats) end
local mapper = function(view, stats) end
local mapper_todo = function(view, stats) end
local wk_conflicts = function(view, stats) end
local wk_ok = function(view, stats) end
local wk_todo = function(view, stats) end

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
    cmd_map[args[3]](args[4], stats)
  else
    all(args[3], stats)
  end
end

return { stats = stats }
