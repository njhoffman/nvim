local default_state = {
  initialized = false,
  busy = false,
  curr_idx = 1,
  enabled = {},
  providers = {},
  ft_bufnr = {},
  winnr = nil,
  bufnr = nil,
  width = nil,
  height = nil,
  time = nil,
  provider = '',
  timing = {
    n = 0,
    avg = 0,
    min = 0,
    max = 0,
  },
}

return default_state
