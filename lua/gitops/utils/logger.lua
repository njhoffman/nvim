local logger = require('logger').init('git')

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

return {
  timing = timing,
  trace = logger.trace,
  debug = logger.debug,
  info = logger.info,
  warn = logger.warn,
  error = logger.error,
}
