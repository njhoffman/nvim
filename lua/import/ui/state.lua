local state = {
  failed = {
    parts = {},
    widths = {}
  },
  success = {
    parts = {},
    widths = {}
  },
  is_displayed    = false,
  buf_handle      = nil,
  view_buf_handle = nil,
  buf_win_handle  = nil,
  view_win_handle = nil,
}

local get_module = function(line)
  line = state.lines[line]
  if not line or line == -1 then
    return
  end
  return line
end

state._get_module = get_module
return state
