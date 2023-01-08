local config     = require('watcher.opts')
local watchutils = require('watcher.utils')
local logger     = require('watcher.logger')

local setup = function()
  logger:debug('initializing watcher at ' .. os.date())
  watchutils.clear_timers()
  local n = 1

  for name, list in pairs(config.lists) do
    list.name = name
    logger = logger.init(list.name)
    logger:debug(n .. '/' .. #config.lists .. ' init list:' .. list.name)
    watchutils.create_timer(list)
    n = n + 1
  end
end

setup()
