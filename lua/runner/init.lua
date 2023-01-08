local commands = require('runner.commands')

local setup = function()
  -- local config = require('runner.config')
  vim.logger:debug('initializing runner at ' .. os.date())
  commands.setup()
end

setup()
