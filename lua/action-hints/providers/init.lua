local state = require('action-hints.state')
local utils = require('action-hints.utils')
local ref = require('action-hints.providers.references')
local def = require('action-hints.providers.definitions')
local ca = require('action-hints.providers.codeactions')
local display = require('action-hints.display')

local update = function(config)
  if utils.supports_method('definitionProvider') then
    display.clear_virtual_text()
    state.is_cleared = true
    local delays = config.debounce_delays
    utils.throttle(ref, delays.references, config, 'references')
    utils.throttle(def, delays.definitions, config, 'definitions')
    utils.throttle(ca, delays.codeactions, config, 'codeactions')
  end
end

return { update = update }
