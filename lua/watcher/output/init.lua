local config  = require('watcher.opts')
local stdout  = require('watcher.output.stdout')
local notify  = require('watcher.output.notify')
local logfile = require('watcher.output.logfile')

local handle_diff = function(difflist)
  if config.output.notify and difflist.total > 0 then
    notify.handle_diff(difflist)
  end

  if config.output.stdout and difflist.total > 0 then
    stdout.handle_diff(difflist)
  end

  if config.output.logfile and difflist.total > 0 then
    logfile.handle_diff(difflist)
  end
end

return {
  log = logfile.handle_log,
  diff = handle_diff,
}
