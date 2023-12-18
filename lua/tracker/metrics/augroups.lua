local output_augroups = function() end

local init_augroups = function(opts)
  local state = require('tracker.state')
  local events = require('tracker.au_events')
  local events_list = events.init(opts, events.output_augroups)
  vim.api.nvim_create_autocmd(events_list, {
    pattern = '*',
    callback = events.record_event(opts.show_data),
    desc = 'tracking augroups with' .. #events_list .. 'events',
  })
end

local provider = {
  name = 'augroups',
  id_fields = 'group_name',
  icon = '祐',
  get = function()
    return vim.api.nvim_get_autocmds({})
  end,
  init = init_augroups,
  output = output_augroups,
  -- parse_data = function() end
}

return provider
