local state = {
  is_cleared = false,
  stats = {
    counts = {
      references = 0,
      definitions = 0,
      codeactions = 0,
    },
    skips = {
      references = 0,
      definitions = 0,
      codeactions = 0,
    },
    times = {},
  },
  current = {
    references = 0,
    definitions = 0,
    codeactions = 0,
  },
  timers = {
    references = nil,
    definitions = nil,
    codeactions = nil,
  },
  available = {
    references = false,
    definitions = false,
    codeactions = false,
  },
}

return state
