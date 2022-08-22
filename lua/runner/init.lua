local commands = require('runner.commands')

local setup = function()
  -- local config = require('runner.config')
  commands.setup()
  vim.logger:debug('initializing runner at ' .. os.date())
end

setup()
