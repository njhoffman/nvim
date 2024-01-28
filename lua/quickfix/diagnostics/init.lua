local config = require('quickfix.diagnostics.config')
local qflist = require('quickfix.diagnostics.qflist')
local loclist = require('quickfix.diagnostics.loclist')

local open_buffer_diagnostics = function()
  loclist.open_buffer_diagnostics()
end

local open_all_diagnostics = function()
  qflist.open_all_diagnostics()
end

local diagnostics_hook = function(diag_changed)
  if config.debug then
    if diag_changed then
      vim.dbglog('diagnostics changed')
    else
      vim.dbglog('winenter hook')
    end
  end

  qflist.diagnostics_hook(diag_changed)
  -- loclist.diagnostics_hook()
end

local setup = function(opts)
  config.setup(opts)
  require('quickfix.diagnostics.commands').setup(config)
  require('quickfix.diagnostics.qflist').setup(config)
end

return {
  setup = setup,
  diagnostics_hook = diagnostics_hook,
  open_buffer_diagnostics = open_buffer_diagnostics,
  open_all_diagnostics = open_all_diagnostics,
}
