-- Shared state for the buffer history commands.

local state = {
  popup_title = false,
  popup_width = false,
  histories = {},
  ignores = {
    [""] = true,
    ["netrw"] = true,
  },
  popup_winid = nil,
}

return state
