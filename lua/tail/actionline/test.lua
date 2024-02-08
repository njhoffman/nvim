local actionline = require('tail.actionline')

local test_actions = function()
  -- check_line('ﬧ  :truncate:')
  -- check_line('ﬧ  :truncate:')
  -- local line = 'ﬧ   :truncate:'
  local lines = {
    'ﬧ   :truncate:var1=val1:var2=val2:var3=val3:var4:',
    'ﬧ  :truncate:',
    'ﬧ  :truncate:',
    'ﬧ   :truncate:',
  }
  local actionlines = actionline.check_lines(lines)
  for _, action in ipairs(actionlines) do
    print(action)
    actionline.run_action(action)
  end
end

test_actions()
