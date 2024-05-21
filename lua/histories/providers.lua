local providers = {
  changes = require('histories.changes'),
  -- jumps = require('histories.jumps'),
  -- selects = require('histories.selects'),
}

local init = function()
  for _, provider in pairs(providers) do
    if type(provider.init == 'function') and not provider.disabled then
      provider.init()
    end
  end
end

local start = function()
  for _, provider in pairs(providers) do
    if type(provider.start == 'function') and not provider.disabled then
      provider.start()
    end
  end
end

return {
  providers = providers,
  init = init,
  start = start,
}
