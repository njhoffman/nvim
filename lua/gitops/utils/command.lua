local M = {}
local logger = require('gitops.utils.logger')

--- Executes a command and returns the output
--- @param command string
--- @return string returns empty string upon error
M.execute = function(command)
  local handle = io.popen(command)

  if handle == nil then
    return ''
  end

  local output = handle:read('*a')
  handle:close()

  logger.debug('exe ' .. command .. ' (' .. #output .. ')')
  return output
end

return M
