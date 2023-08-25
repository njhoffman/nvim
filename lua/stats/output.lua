local logfile = function(lines)
  lines = '\n' .. lines
  vim.dbglog(lines)
end

local notify = function(lines, title)
  -- local notify = require('notify')
  local notify = vim.notify
  if type(title) ~= 'nil' and #title > 0 then
    notify(lines, 2, { timeout = 10000, title = title })
  else
    notify(lines, 2, { timeout = 10000, render = 'compact' })
  end
end

return {
  logfile = logfile,
  notify = notify,
}
