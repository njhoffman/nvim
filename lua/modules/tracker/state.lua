-- Shared tracker state: initialized sources, history, timers and timings.

local state = {
  initialized = {},
  history = {},
  timers = {},
  timing = {
    get = 0,
    diff = 0,
  },
}
return state
