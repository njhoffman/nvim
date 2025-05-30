local utils = require("action-hints.utils")
local references = require("action-hints.providers.references")
local definitions = require("action-hints.providers.definitions")
local codeactions = require("action-hints.providers.codeactions")

local update = function(config)
  local delays = config.debounce_delays
  -- local cword = vim.fn.expand("<cword>")
  if vim.lsp.buf_is_attached(0) and not utils.is_cursor_on_whitespace() then
    if utils.supports_method("definitionProvider") then
      utils.throttle(definitions, delays.definitions, config, "definitions")
    end
    -- if utils.supports_method("referencesProvider") then
    --   utils.throttle(references, delays.references, config, "references")
    -- end
    if utils.supports_method("codeActionProvider") then
      utils.throttle(codeactions, delays.codeactions, config, "codeactions")
    end
  end
end

return { update = update }
