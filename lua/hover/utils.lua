local log_msg = function(msg)
  vim.dbglog(msg)
end
local logger = function()
  return {
    trace = log_msg,
    debug = log_msg,
    info = log_msg,
    warn = log_msg,
    error = log_msg,
  }
end

return {
  logger = logger,
}
