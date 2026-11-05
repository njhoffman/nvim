-- Sends stats lines to a buffer, split, log file, notification or popup.

local sinks = require("modules.stats.sinks")

local buffer = function(lines, title)
  lines = type(lines) == "string" and vim.fn.split(lines, "\n") or lines
  vim.dbglog(title .. vim.fn.join(lines, "\n  "))
  sinks.buffer(lines, title)
end

local split = function(lines, title)
  lines = type(lines) == "string" and vim.fn.split(lines, "\n") or lines
  sinks.split(lines, title)
end

local logfile = function(lines, title)
  lines = type(lines) == "string" and vim.fn.split(lines, "\n") or lines
  if #lines > 1 then
    title = title .. " (" .. #lines .. ")\n  "
  else
    title = title .. " "
  end
  sinks.logfile(lines, title)
end

local notify = function(rows, title)
  sinks.notify(rows, title)
end

local popup = function(lines, title) end

return {
  logfile = logfile,
  notify = notify,
  split = split,
  buffer = buffer,
  popup = popup,
}
