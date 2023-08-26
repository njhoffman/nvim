local sinks = require('logger.sinks')
local structlog = require('structlog')

local sinks_config = { main = { banner = true }, module = { banner = false } }

local logdefs = {
  root = { main = 3 },
  lazy = { main = 2 },
  project = { main = 3 },
  lsp = { main = 2 },
  mapper = { main = 3, module = 1 },
  notify = { main = 1 },
}

local init = function(name, sink_levels)
  name = name or 'root'
  sink_levels = sink_levels or logdefs[name] or { main = 3, module = 2, notify = 2 }

  local has_level = function(lvl)
    return type(lvl) == 'number' and lvl > 0
  end
  local struct_sinks = {}

  if has_level(sink_levels.main) then
    table.insert(struct_sinks, sinks.file(sink_levels.main, _, sinks_config.main))
  end

  if has_level(sink_levels.module) then
    local modfile = vim.fn.stdpath('data') .. '/nvim-' .. name .. '.log'
    table.insert(struct_sinks, sinks.file(sink_levels.module, modfile, sinks_config.module))
  end

  if has_level(sink_levels.notify) then
    table.insert(struct_sinks, sinks.notify(sink_levels.notify))
  end
  local struct_config = { [name] = { sinks = struct_sinks } }
  structlog.configure(struct_config)
  return structlog.get_logger(name)
end

for name, config in pairs(logdefs) do
  init(name, config)
end

local rootlog = structlog.get_logger('root')
rootlog.init = init

return rootlog
