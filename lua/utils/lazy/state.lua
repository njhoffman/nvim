local state = {
  start = {},
  lazy = {},
  configs_paths = {},
  configs_checked = {},
  configs_loaded = {},
  errors = {},
}

state.get_numbers = function()
  local plugins = { keys = 0, events = 0, dependencies = 0 }
  local configs = {
    exist = 0,
    noexist = 0,
    checked = 0,
    loaded = 0,
  }
  for _, _ in pairs(state.configs_loaded) do
    configs.loaded = configs.loaded + 1
  end
  for _, exists in pairs(state.configs_checked) do
    configs.checked = configs.checked + 1
    if exists then
      configs.exist = configs.exist + 1
    else
      configs.noexist = configs.noexist + 1
    end
  end
  return { plugins = plugins, configs = configs }
end

return state
