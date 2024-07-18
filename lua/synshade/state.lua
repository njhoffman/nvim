-- Private "namespace" for functions, etc. that might not be defined before they are used
local state = { enabled = true, current_window = nil }

local helpers = {
  --- Check if this plugin is currently enabled
  ---
  ---@return boolean # whether or not the plugin is enabled
  check_enabled = function()
    return state.enabled
  end,
}

return state, helpers
