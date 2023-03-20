local state = {
  timer = nil,
  -- augroups = { augroups_cfg }, commands = { commands_cfg }
  metrics = {},
  history = {},
  totals = { get = 0, diff = 0 },
  timings = {},
}
return state
