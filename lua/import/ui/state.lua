local state = {
  failed = {},
  success = {},
  is_displayed    = false,
  buf_handle      = nil,
  view_buf_handle = nil,
  buf_win_handle  = nil,
  view_win_handle = nil,
}

local get_module = function(name)
  local line = state.failed[name]
  if not line or line == -1 then
    line = state.success[name]
    return line
  end
  return line
end

state._get_module = get_module
return state
