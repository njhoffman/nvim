local state = {
  initialized = false,
  next_job = nil,
  busy = false,
  winnr = nil,
  bufnr = nil,
  width = nil,
  height = nil,
  time = nil,
  provider = "",
  enabled = {},
}

return state
