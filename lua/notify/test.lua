local examples = require('notify.examples.errors')
local notify = require('notify').notify
-- error2 gives eol problem
local notify_errors = function()
  notify(examples.error2, 4, { timeout = 4000 })
  -- local delay = 1000
  -- for i, example in pairs(examples) do
  --   vim.defer_fn(function()
  --     notify(example, 4, { timeout = 4000, title = i })
  --   end, delay)
  --   delay = delay + 5000
  -- end
end

notify_errors()
-- vim.api.nvim_create_user_command('NotifyTest', notify_test, { desc = 'Notifications renderings' })
