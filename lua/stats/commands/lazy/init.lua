local output = require('stats.output')
local utils = require('stats.utils')

-- lazy stats
--   --   count = 340, loaded = 255, real_cputime = true, startuptime = 624.262988,
--   --   times = { LazyDone = 317.694648, LazyStart = 12.678501, UIEnter = 624.262988 }

local stats_overview = function(view, state)
  view = view or 'notify'
  local lines = ''
  if #state.errors > 0 then
    lines = lines .. ', errors: ' .. #vim.tbl_keys(state.errors) .. '\n'
  end
  local times = {
    start = utils.roundString(state.times.LazyStart, 2),
    done = utils.roundString(state.times.LazyDone, 2),
    enter = utils.roundString(state.times.UIEnter, 2),
  }
  times.done = #times.done == 5 and ' ' .. times.done or times.done

  lines = lines
    .. 'Loaded    '
    .. tostring(state.loaded)
    .. ' /'
    .. tostring(state.count)
    .. '\n LazyStart   '
    .. times.start
    .. '\n LazyDone   '
    .. times.done
    .. '\n UIEnter    '
    .. times.enter

  output[view](lines, 'Lazy Overview')
end

local stats = function(args)
  local state = require('utils.lazy.state')
  local stats = require('lazy').stats()
  state = vim.tbl_deep_extend('force', state, stats)
  local cmd_map = {
    configs = require('stats.commands.lazy.configs').stats,
    plugins = require('stats.commands.lazy.plugins').stats_plugins,
  }
  if cmd_map[args[2]] then
    cmd_map[args[2]](args, state)
  else
    stats_overview(args[2], state)
  end
end

return {
  stats = stats,
}
