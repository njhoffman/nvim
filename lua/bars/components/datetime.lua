--- Date/time component.
--- Shows date and/or time with configurable format.
---@module "bars.components.datetime"


local M = {}

---@type string
local default_format = "%H:%M"

--- Returns the formatted date/time for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  return os.date(default_format) --[[@as string]]
end

--- Creates a value function with a custom format string.
---@param format string
---@return fun(buffer: integer, window: integer): string
M.with_format = function(format)
  return function(buffer, window)
    return os.date(format) --[[@as string]]
  end
end

return M
