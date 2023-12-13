local state = {
  initialized = {},
  timers = {},
  metrics = {},
  history = {},
  totals = {
    get = 0,
    diff = 0,
  },
  timings = {},
}
return state
