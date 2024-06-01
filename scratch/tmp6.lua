local logger = require('logger')

-- local structlog = require('structlog')
-- if has_level(sink_levels.module) then
--   local modfile = vim.fn.stdpath('data') .. '/nvim-' .. scope .. '.log'
--   table.insert(struct_sinks, sinks.file(sink_levels.module + 1, modfile, sinks_config.module))
-- end
-- local struct_config = { [scope] = { sinks = struct_sinks } }
-- structlog.configure(struct_config)

-- local scopelog = structlog.get_logger(scope)
