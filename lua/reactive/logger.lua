local logger = require('logger').init('reactive')

local timing = function(opts, timing, num)
  -- command finishes here if async job
  if type(timing.command ~= 'string') then
    timing.command = vim.fn.reltimestr(vim.fn.reltime(timing.total))
  end

  if type(timing.total) ~= 'string' then
    timing.total = vim.fn.reltimestr(vim.fn.reltime(timing.total))
    timing.average = timing.total * 10000 / num
    logger:debug(
      opts.prompt_title .. ':' .. timing.average .. ' /' .. timing.total .. ' (' .. num .. ') '
    )
    -- opts.finder_type, '\n', timing.command, timing.first_entry,
  end
end

local log_mode = function(from, to, op, op_func, op_pfx)
  logger:debug(
    'ModeChanged  '
      .. from
      .. ':'
      .. to
      .. string.rep(' ', 5 - (#from + #to))
      .. (op and #op > 0 and (" '" .. tostring(op) .. "'") or '    ')
      .. (op_func and #op_func > 0 and (' [' .. tostring(op_func) .. ']') or '    ')
    -- .. (op_pfx and #op_pfx > 0 and (' - ' .. tostring(op_pfx) .. ']') or '    ')
  )
end

local log_virtual = function(from, to, op, op_func, op_pfx)
  logger.debug(
    'WhichKeyMode '
      .. (from or ' ')
      .. ':'
      .. (to or ' ')
      .. string.rep(' ', 5 - (#from + (to and #to or 0)))
      .. (op and #op > 0 and (" '" .. tostring(op) .. "'") or ' ')
      .. (op_func and #op_func > 0 and (' [' .. tostring(op_func) .. ']') or '    ')
  )
end

local get_logger = function(level)
  return function(...)
    if level == 'trace' then
      logger:trace(...)
    elseif level == 'debug' then
      logger:debug(...)
    elseif level == 'info' then
      logger:info(...)
    elseif level == 'warn' then
      logger:warn(...)
    elseif level == 'error' then
      logger:error(...)
    end
  end
end

local log_opfunc = function(opfunc, op_def, keys)
  local state = require('configs.reactive.state')
  -- if op_def then
  --   local op_key = op_def[1] and op_def[1][1]
  --   local op_count = state.opfuncs.matched[op_key] or 0
  --   logger:debug('OpfuncFound  ' .. op_key .. ': ' .. op_count)
  -- else
  --   local op_count = state.opfuncs.missed[op_key] or 0
  --   logger:info('OpfuncMiss   ' .. op_key .. ': ' .. op_count)
  -- end
end

return {
  timing = timing,
  trace = get_logger('trace'),
  debug = get_logger('debug'),
  info = get_logger('info'),
  warn = get_logger('warn'),
  error = get_logger('error'),
  log_mode = log_mode,
  log_virtual = log_virtual,
  log_opfunc = log_opfunc,
}
