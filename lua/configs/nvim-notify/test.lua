local notify_test = function()
  local notify = require('notify').notify
  notify('Test', 'info', { render = 'default' })
end

vim.api.nvim_create_user_command('NotifyTest', notify_test, { desc = 'Notifications renderings' })
