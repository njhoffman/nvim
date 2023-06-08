local exports = {}
local config = require('tracker.config')
local metrics = require('tracker.metrics')

local cmd = vim.api.nvim_create_user_command
cmd('Tracker', function()
  metrics.start()
end, { desc = 'Start changes tracker' })

cmd('TrackerStats', function()
  local stats = vim.deepcopy(require('tracker.state'))
  for k, _ in pairs(stats.metrics) do
    stats.metrics[k].prev_items = #vim.tbl_keys(stats.metrics[k].prev_items)
  end
  local avg = { diff = 0, get = 0, n = 0 }
  for _, timing in ipairs(stats.timings) do
    avg.diff = avg.diff + timing.diff
    avg.get = avg.get + timing.get
    avg.n = avg.n + 1
  end
  avg.diff = math.floor(avg.diff / avg.n)
  avg.get = math.floor(avg.get / avg.n)
  stats.timings = avg
  stats.history = #stats.history
  vim.dbglog(stats)
end, { desc = 'Look at tracker state stats' })

cmd('TrackerStop', function()
  metrics.stop()
end, { desc = 'Stop tracker timers' })

function exports.setup(_opts)
  local opts = config.setup(_opts)
  for name, cfg in pairs(opts.metrics) do
    metrics.init(name, cfg)
  end
  if opts.event_tracker == true then
    local ignored = opts.ignored_events or { 'FocusLost', 'FocusGained', 'WinResized', 'WinScrolled' }
    local only = opts.only_events or { 'User' }
    local show_data = opts.show_data or true

    local events = require('autocommands.events')
    local timer = vim.fn.timer_start(1000, events.output_events, { ['repeat'] = -1 })
    vim.api.nvim_create_autocmd(
      #only > 0 and only or events.get_events(ignored),
      { pattern = '*', callback = events.record_event(show_data), desc = 'EventTracker' }
    )
  end
  -- vim.keymap.set("n", lhs, commands[key], { noremap = true })
end

return exports
