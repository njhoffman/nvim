local logger = require('logger').init('reactive')

local timing = function(opts, timing, num)
  -- command finishes here if async job
  if type(timing.command ~= 'string') then
    timing.command = vim.fn.reltimestr(vim.fn.reltime(timing.total))
  end

  if type(timing.total) ~= 'string' then
    timing.total = vim.fn.reltimestr(vim.fn.reltime(timing.total))
    timing.average = timing.total * 10000 / num
    logger:debug(opts.prompt_title .. ':' .. timing.average .. ' /' .. timing.total .. ' (' .. num .. ') ')
    -- opts.finder_type, '\n', timing.command, timing.first_entry,
  end
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

return {
  timing = timing,
  trace = get_logger('trace'),
  debug = get_logger('debug'),
  info = get_logger('info'),
  warn = get_logger('warn'),
  error = get_logger('error'),
}
