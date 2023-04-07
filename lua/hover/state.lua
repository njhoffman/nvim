local state = {
  initialized = false,
  busy = false,
  winnr = nil,
  bufnr = nil,
  ft_bufnr = {},
  width = nil,
  height = nil,
  time = nil,
  provider = "",
  enabled = {},
  timing = {
    providers = {},
    batch = {
      n = 0,
      avg = 0,
      min = 0,
      max = 0,
    },
  },
}

return state
