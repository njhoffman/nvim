local Manager = require('noice.message.manager')
local Config = require('noice.config')
local messages = Manager.get(Config.options.commands.history.filter, {
  history = true,
  sort = true,
  reverse = true,
})
vim.dbglog(messages)
