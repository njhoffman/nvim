local providers = {
  changes = require("histories.changes"),
  -- jumps = require('histories.jumps'),
  -- selects = require('histories.selects'),
}

local init = function()
  for _, provider in pairs(providers) do
    if type(provider.init == "function") and not provider.disabled then
      provider.init()
    end
  end
end

local start = function(ev)
  local args = ev.fargs
  for _, provider in pairs(providers) do
    if type(provider.start == "function") and not provider.disabled and not provider.started then
      provider.start()
      provider.started = true
    end
  end
end

local stop = function()
  for _, provider in pairs(providers) do
    if type(provider.stop == "function") and provider.started then
      provider.stop()
      provider.started = false
    end
  end
end

return {
  providers = providers,
  init = init,
  start = start,
  stop = stop,
}
