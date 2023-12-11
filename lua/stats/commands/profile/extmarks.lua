local stats = function(args, state)
  -- local cmd_map = {
  --   all = configs_all,
  --   checked = configs_checked,
  --   stray = configs_stray,
  --   exist = configs_exist,
  --   missing = configs_missing,
  --   dependency = configs_dependency,
  -- }
  -- if cmd_map[args[3]] then
  --   cmd_map[args[3]](args[4], state)
  -- else
  --   configs_overview(args[3], state)
  -- end
  return 'extmarks stats'
end
return { stats = stats }
