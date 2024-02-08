local actions = require('tail.actionline.actions')
local config = require('tail.config')
local logger = require('tail.logger')

local get_args = function(line)
  local pattern_args = ':?([%w=]+):'
  local action_args = {}
  for args in string.gmatch(line, pattern_args) do
    args = args:find('=') and vim.fn.split(args, '=') or args
    if type(args) == 'table' then
      action_args[args[1]] = args[2]
    else
      action_args[args] = true
    end
  end
  return action_args
end

local check_line = function(line)
  local pattern_cmd = '^' .. config.actions_prefix .. ':(%w+):'
  local match = string.match(line, pattern_cmd)
  if type(actions[match]) == 'function' then
    local remaining = line:gsub(pattern_cmd, '')
    return match, remaining
  else
    logger.warn('matching action not found: ' .. match)
  end
  return false
end

return { check_line = check_line, parse_args = get_args }
