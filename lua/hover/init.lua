local exports = {
  register = "hover.providers",
  hover = "hover.hover",
  hover_cursor = "hover.hover",
  hover_sticky = "hover.hover",
  hover_once = "hover.hover",
  hover_select = "hover.hover",
}
local M = {}

function M.setup(user_config)
  require("hover.config").set(user_config)
  require("hover.commands").init()
  local cfg = require("hover.config").get()
end

return setmetatable(M, {
  __index = function(t, k)
    if exports[k] then
      t[k] = require(exports[k])[k]
    end
    return t[k]
  end,
})
