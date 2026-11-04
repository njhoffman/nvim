local M = {}
local logutils = require("lib.logger.debug.utils")

M.parse_message = function(message, cols)
  local msg = ""
  if type(message) == "table" then
    for i, line in ipairs(message) do
      if i > 1 then
        msg = msg .. "\n  "
      end
      if type(line) == "table" then
        line = vim.inspect(line)
      elseif type(cols) == "number" then
        line = logutils.wrap(line, cols, " ", "")
      end
      msg = msg .. line
    end
  else
    msg = message or "(nil)"
    if type(cols) == "number" then
      msg = logutils.wrap(tostring(msg), cols, " ", "")
    end
  end
  return msg
end

M.notify_parse_message = function(message, cols)
  --    
  local msg = message
  msg = M.parse_message(message)
  -- end
  return msg
end

return M
