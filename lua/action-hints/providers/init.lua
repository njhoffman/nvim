local state = require('action-hints.state')
local utils = require('action-hints.utils')
local references = require('action-hints.providers.references')
local definitions = require('action-hints.providers.definitions')
local codeactions = require('action-hints.providers.codeactions')
local display = require('action-hints.display')

local update = function(config)
  local delays = config.debounce_delays
  if utils.supports_method('definitionProvider') then
    display.clear_virtual_text()
    state.is_cleared = true
    if not utils.is_cursor_on_whitespace() then
      utils.throttle(references, delays.references, config, 'references')
      utils.throttle(definitions, delays.definitions, config, 'definitions')
      utils.throttle(codeactions, delays.codeactions, config, 'codeactions')
    end
  end
end

return { update = update }
