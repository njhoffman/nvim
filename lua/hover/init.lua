local register = require('hover.providers').register
local setup = function(user_config)
  require('hover.config').set(user_config)
  require('hover.commands').init()
end

return { setup = setup, register = register }
