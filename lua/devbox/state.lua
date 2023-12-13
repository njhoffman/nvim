local state = {
  current = {
    batch_idx = 0,
    start = nil,
    last_elapsed = nil,
    enabled = {},
    queued = {},
    completed = {},
    errored = {},
  },
  timing = {
    providers = {},
    batch = {
      n = 0,
      avg = 0,
      min = 0,
      max = 0,
      total = 0,
    },
  },
  source = {
    bufnr = nil,
    size = { width = nil, height = nil },
  },
  popup = {
    bufnr = nil,
    winnr = nil,
    size = { width = 40, heigt = nil },
  },
  providers = {},
}

return state
