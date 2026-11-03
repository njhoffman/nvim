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
