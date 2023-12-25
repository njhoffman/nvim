local state = require('utils.lazy.state')
local logger = require('logger').init('lazy')

local file_exists = function(name)
  local nvim_dir = vim.fn.stdpath('config') .. '/lua/configs/'
  local path = nvim_dir .. name .. '.lua'
  local f = io.open(path, 'r')
  if f ~= nil then
    state.configs_paths[name] = path
    io.close(f)
    return true
  else
    path = nvim_dir .. name .. '/init.lua'
    f = io.open(path, 'r')
    if f ~= nil then
      state.configs_paths[name] = path
      io.close(f)
      return true
    end
    return false
  end
end

local apply_config_file = function(name, plugin, dependency)
  local fname = 'configs.' .. string.lower(name)
  logger:trace('config exists: ' .. fname)
  state.configs_checked[name] = true
  if dependency then
    state.configs_dependency[name] = true
  end
  plugin.config = function(loaded_plug)
    local event = loaded_plug._.loaded
    local dep = loaded_plug._dependency and ' [' .. loaded_plug._dependency .. ']' or ''
    logger:debug(fname .. dep, event)
    local mod, mod_ok = vim.import(fname)
    if not mod_ok then
      state.errors[fname] = mod
      logger:error('error in lazy: ' .. fname .. vim.inspect(mod))
    else
      state.configs_loaded[name] = true
      return mod
    end
  end
  return plugin
end

local check_config_file = function(plugin, dependency)
  local name = ''
  -- parse config file name from plugin name
  if type(plugin) == 'table' and type(plugin.name) == 'string' then
    name = plugin.name
  elseif type(plugin) == 'table' and (plugin.url or plugin.dir) then
    name = plugin.url or plugin.dir
    local name_parts = vim.split(name, '/')
    name = name_parts[#name_parts]
  elseif type(plugin) == 'table' and type(plugin[1]) ~= 'nil' then
    name = string.match(plugin[1], '/') and vim.split(plugin[1], '/')[2] or plugin[1]
  else
    logger:error('Error processing plugin: ' .. vim.inspect(plugin))
  end

  if type(name) == 'string' and #name > 0 then
    name = string.lower(string.gsub(name, '[\\.]+', '-'))
    name = string.gsub(name, '-nvim$', '')

    -- skip if we already checked the file and didn't find it
    if state.configs_checked[name] ~= false then
      if file_exists(name) then
        plugin = apply_config_file(name, plugin, dependency)
      else
        state.configs_checked[name] = false
      end
    end
  end

  return plugin, name
end

local apply_configs = function(plugins)
  for _, _plugin in ipairs(plugins) do
    local plugin, name = check_config_file(_plugin)
    if plugin.lazy and not state.lazy[name] then
      state.lazy[name] = plugin
    elseif not state.start[name] then
      state.start[name] = plugin
    end

    -- loop through dependencies and apply any necessary configs
    local dependencies = {}
    plugin.dependencies = type(plugin.dependencies) == 'string' and { plugin.dependencies } or plugin.dependencies
    for _, _dep_plugin in ipairs(plugin.dependencies or {}) do
      _dep_plugin = type(_dep_plugin) == 'string' and { _dep_plugin } or _dep_plugin
      local dep_plugin, dep_name = check_config_file(_dep_plugin, name)
      state.dependency[dep_name] = dep_plugin
      table.insert(dependencies, dep_plugin)
    end
    plugin.dependencies = #dependencies > 0 and dependencies
  end
  return plugins
end

return {
  apply = apply_configs,
}
