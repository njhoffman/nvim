local output = require('stats.output')

local get_stray_configs = function(state)
  local scan = require('plenary.scandir')
  local basepath = vim.fn.stdpath('config') .. '/lua/configs'
  local files = scan.scan_dir(basepath, {
    depth = 1,
    search_pattern = '.lua$',
  })
  local strays = {}
  for i, file in ipairs(files) do
    local name_parts = vim.split(file, '/')
    local config_name = string.gsub(name_parts[#name_parts], '.lua$', '')
    if type(state.configs_checked[config_name]) == 'nil' then
      local path = state.configs_paths[config_name] or config_name
      table.insert(strays, path)
    end
  end
  table.sort(strays)
  return strays
end

local get_exist_configs = function(state)
  local exists = {}
  for name, does_exist in pairs(state.configs_checked) do
    if does_exist == true then
      local path = state.configs_paths[name] or name
      table.insert(exists, path)
    end
  end
  table.sort(exists)
  return exists
end

local get_missing_configs = function(state)
  local missing = {}
  for name, does_exist in pairs(state.configs_checked) do
    if does_exist == false then
      local path = state.configs_paths[name] or name
      table.insert(missing, path)
    end
  end
  table.sort(missing)
  return missing
end

local get_checked_configs = function(state)
  local checked = {}
  for name in pairs(state.configs_checked) do
    local path = state.configs_paths[name] or name
    table.insert(checked, path)
  end
  table.sort(checked)
  return checked
end

local get_dependency_configs = function(state)
  local dependency = {}
  for name in pairs(state.configs_dependency) do
    local path = state.configs_paths[name] or name
    table.insert(dependency, path)
  end
  table.sort(dependency)
  return dependency
end

local configs_stray = function(view, state)
  view = view or 'logfile'
  local lines = get_stray_configs(state)
  output[view](lines, 'Lazy Configs Stray')
end

local configs_checked = function(view, state)
  view = view or 'logfile'
  local lines = get_checked_configs(state)
  output[view](lines, 'Lazy Configs Checked')
end

local configs_exist = function(view, state)
  view = view or 'logfile'
  local lines = get_exist_configs(state)
  output[view](lines, 'Lazy Configs Exists')
end

local configs_missing = function(view, state)
  view = view or 'logfile'
  local lines = get_missing_configs(state)
  output[view](lines, 'Lazy Configs Missing')
end

local configs_dependency = function(view, state)
  view = view or 'logfile'
  local lines = get_dependency_configs(state)
  output[view](lines, 'Lazy Configs Dependency')
end

local configs_all = function(view, state)
  view = view or 'logfile'
  local lines = get_exist_configs(state)
  output[view](lines, 'Lazy Configs All')
end

local configs_overview = function(view, state)
  view = view or 'notify'
  local configs = state.get_numbers().configs
  local lines = configs.loaded .. ' loaded : ' .. configs.checked .. ' checked'
  lines = lines .. '\n' .. configs.exist .. ' exist : ' .. configs.noexist .. ' not exist'
  output[view](lines, 'Lazy Configs')
end

local stats = function(args, state)
  local cmd_map = {
    all = configs_all,
    checked = configs_checked,
    stray = configs_stray,
    exist = configs_exist,
    missing = configs_missing,
    dependency = configs_dependency,
  }
  if cmd_map[args[3]] then
    cmd_map[args[3]](args[4], state)
  else
    configs_overview(args[3], state)
  end
end
return { stats = stats }
