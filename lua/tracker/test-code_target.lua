local n = 0
local demo_code_target = function(type, id)
  if n == 2 then
    id = id + 1
  end
  local data = {
    tables = {
      { ['one'] = 1, ['two'] = 2, ['three'] = 3 },
      { ['one'] = 1, ['two'] = 2, ['three'] = 3, ['four'] = 4 },
      { ['two'] = 2, ['three'] = 3 },
      { ['one'] = 1, ['two'] = 2, ['perseus'] = 3 },
    },
    lists = {
      { [1] = 'one', [2] = 'two', [3] = 'three' },
      { [1] = 'one', [2] = 'two', [3] = 'three', [4] = 'four' },
      { [2] = 'two', [3] = 'three' },
      { [1] = 'one', [2] = 'two', [3] = 'perseus' },
    },
  }
  n = n + 1
  return data[type][id]
end

-- local source = require('tracker.sources.code_target')('notify_state', 'noice.view.backend', 'state'),
-- local source = provider_init('notify_state', 'noice.view.backend.state')
-- defaults.init(source, {})

return {
  state_table = demo_code_target('tables', 1),
  state_list = demo_code_target('lists', 1),
}
