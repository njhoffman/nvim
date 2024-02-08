local config = require('tail.config')
local state = require('tail.state')
local utils = require('tail.utils')
local log = require('logger').init('tail')

local timing = function(opts, timing, num)
  -- command finishes here if async job
  if type(timing.command ~= 'string') then
    timing.command = vim.fn.reltimestr(vim.fn.reltime(timing.total))
  end

  if type(timing.total) ~= 'string' then
    timing.total = vim.fn.reltimestr(vim.fn.reltime(timing.total))
    timing.average = timing.total * 10000 / num
    log:debug(opts.prompt_title .. ':' .. timing.average .. ' /' .. timing.total .. ' (' .. num .. ') ')
    -- opts.finder_type, '\n', timing.command, timing.first_entry,
  end
end

local get_logger = function(level)
  return function(...)
    if level == 'trace' then
      log:trace(...)
    elseif level == 'debug' then
      log:debug(...)
    elseif level == 'info' then
      log:info(...)
    elseif level == 'warn' then
      log:warn(...)
    elseif level == 'error' then
      log:error(...)
    end
  end
end

local logger = {
  timing = timing,
  trace = get_logger('trace'),
  debug = get_logger('debug'),
  info = get_logger('info'),
  warn = get_logger('warn'),
  error = get_logger('error'),
}

logger.log_start = function()
  logger.debug(
    'starting tail '
      .. (config.checktime and '(checktime)' or '(filesize)')
      .. ' for '
      .. state.bufname
      .. ' --    '
      .. state.file_size
      .. '   '
      .. state.file_lines
  )
end

logger.log_action = function(match, args)
  local line = vim.fn.join({
    'running action "',
    match,
    '" ',
    args and (' with ' .. #vim.tbl_keys(args) .. ' args') or '',
  }, '')
  logger.debug(line)
end

logger.log_diff = function(file_size, lines_diff, lines_total)
  local log_line = '  ' .. utils.human_size(file_size) .. ' -> ' .. utils.human_size(state.file_size)
  if lines_diff then
    log_line = log_line .. '     ' .. lines_diff
  else
    log_line = log_line .. '    濫' .. lines_total
  end
  logger.debug(log_line)
end

return logger
