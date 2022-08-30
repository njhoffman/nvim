local state = {
  details = {},
  is_displayed    = false,
  buf_handle      = nil,
  view_buf_handle = nil,
  buf_win_handle  = nil,
  view_win_handle = nil,
}

local get_module = function(idx)
  return state.details[idx]
end

state._get_module = get_module
return state
