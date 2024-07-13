local notify = require('notify')
local notif = notify('Test trace', 0, {})

notif = notify('Test debug ********', 1, { title = 'DEBUG' })
vim.defer_fn(function()
  notif = notify('Test info', 2, { title = 'INFO', replace = notif.id })
  vim.defer_fn(function()
    notif = notify('Test warn ***', 3, { title = 'WARN', replace = notif.id })
    vim.defer_fn(function()
      notif = notify('Test error', 4, { title = 'ERROR', replace = notif.id })
    end, 2000)
  end, 2000)
end, 2000)
-- highlights = { body = highlights, border, title, icon },
