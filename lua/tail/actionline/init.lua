local logger = require('tail.logger')
local actions = require('tail.actionline.actions')
local parser = require('tail.actionline.parser')

local run_action = function(actionline)
  logger.log_action(actionline.match, actionline.args)
  actions[actionline.match](actionline.args)
end

local check_lines = function(lines)
  local actionlines = {}
  for _, line in ipairs(lines) do
    local match, remaining = parser.check_line(line)
    if match then
      local args = parser.get_args(remaining)
      table.insert(actionlines, { match = match, args = args })
    end
  end
  return actionlines
end

return { check_lines = check_lines, run_action = run_action }
