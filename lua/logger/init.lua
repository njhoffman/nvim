local sinks = require('logger.sinks')
local structlog = require('structlog')

local scopes = {}

local get_scope_levels = function()
  local luacache = (_G.__luacache or {}).cache
  package.loaded['logger.levels'] = nil
  if type(luacache) == 'table' then
    luacache['logger.levels'] = nil
  end
  return require('logger.levels').scopes
end

local get_sink_levels = function(scope, sink_levels)
  local scope_levels = get_scope_levels()
  sink_levels = vim.tbl_deep_extend(
    'force',
    sink_levels or {},
    scope_levels['*'] or {},
    scope_levels[scope] or {}
  )
  for _, key in ipairs({ 'main', 'module' }) do
    sink_levels[key] = type(sink_levels[key]) == 'number'
        and sink_levels[key] >= 0
        and sink_levels[key] + 1
      or -1
  end

  return sink_levels
end

local init = function(scope, sink_levels)
  scope = scope or 'root'
  sink_levels = get_sink_levels(scope, sink_levels)
  scopes[scope] = sink_levels

  local modfile = vim.fn.stdpath('data') .. '/nvim-' .. scope .. '.log'
  local scope_sinks = {
    sinks.file(sink_levels.main, _, 'main'),
    sinks.file(sink_levels.module, modfile, 'module'),
  }

  local scope_config = { [scope] = { sinks = scope_sinks } }
  structlog.configure(scope_config)
  -- vim.dbglog('-----', scope, struct_sinks[1].level, struct_sinks[1].path)
  return structlog.get_logger(scope)
end

for name, config in pairs(get_scope_levels()) do
  if name ~= '*' then
    init(name, config)
  end
end

local augroup = vim.api.nvim_create_augroup('LoggerReload', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  pattern = 'lua/logger/levels.lua',
  group = augroup,
  callback = function()
    for scope, old_levels in pairs(scopes) do
      local new_levels = get_sink_levels(scope, {})
      for _, key in ipairs({ 'main', 'module' }) do
        if new_levels[key] ~= old_levels[key] then
          -- vim.dbglog('level ' .. scope .. ' from ' .. old_levels[key] .. ' to ' .. new_levels[key])
          structlog.update_sink_level(scope, key, new_levels[key])
          scopes[scope][key] = new_levels[key]
        end
      end
    end
  end,
  desc = 'reload logger levels on write',
})

vim.api.nvim_create_user_command('LogScopes', function()
  local scope_keys = vim.fn.sort(vim.tbl_keys(scopes))
  local name_width = math.max(unpack(vim.tbl_map(function(n)
    return #n
  end, scope_keys)))

  local lines = vim.tbl_map(function(name)
    return string.format(
      '%-' .. name_width .. 's %2s %2s',
      name,
      scopes[name].main == -1 and '_' or scopes[name].main - 1,
      scopes[name].module == -1 and '_' or scopes[name].module - 1
    )
  end, scope_keys)

  vim.notify(vim.fn.join(lines, '\n'), vim.lsp.log_levels.INFO)
end, { desc = ' view log scopes' })

local rootlog = structlog.get_logger('root')
rootlog.init = init
rootlog.scopes = scopes

return rootlog
