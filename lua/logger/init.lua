local sinks = require('logger.sinks')
local structlog = require('structlog')
local scope_levels = require('logger.levels').scopes
local scopes = {}

local sinks_config = {
  main = { banner = true },
  module = { banner = false },
}

local init = function(scope, sink_levels)
  scope = scope or 'root'
  if not vim.tbl_contains(scopes, scope) then
    table.insert(scopes, scope)
  end

  sink_levels = sink_levels or scope_levels[scope] or scope_levels['*']

  local has_level = function(lvl)
    return type(lvl) == 'number' and lvl >= 0
  end
  local struct_sinks = {}

  if has_level(sink_levels.main) then
    table.insert(struct_sinks, sinks.file(sink_levels.main + 1, _, sinks_config.main))
  end

  if has_level(sink_levels.module) then
    local modfile = vim.fn.stdpath('data') .. '/nvim-' .. scope .. '.log'
    table.insert(struct_sinks, sinks.file(sink_levels.module + 1, modfile, sinks_config.module))
  end

  -- if has_level(sink_levels.notify) then
  --   table.insert(struct_sinks, sinks.notify(sink_levels.notify))
  --  end

  local struct_config = { [scope] = { sinks = struct_sinks } }
  structlog.configure(struct_config)
  return structlog.get_logger(scope) or {}
end

for name, config in pairs(scope_levels) do
  init(name, config)
end

local rootlog = structlog.get_logger('root')
rootlog.init = init
rootlog.scopes = scopes

return rootlog
