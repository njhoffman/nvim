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

local check_config_file = function(plugin)
  local name = ''
  -- parse config file name from plugin name
  if type(plugin) == 'table' and type(plugin.name) == 'string' then
    name = plugin.name
  elseif type(plugin) == 'table' and (plugin.url or plugin.dir) then
    name = plugin.url or plugin.dir
    local name_parts = vim.split(name, '/')
    name = name_parts[#name_parts]
  elseif type(plugin) == 'table' and type(plugin[1]) ~= 'nil' then
    name = vim.split(plugin[1], '/')[2]
  else
    logger:error('Error processing plugin: ' .. vim.inspect(plugin))
  end

  if type(name) == 'string' and #name > 0 then
    name = string.lower(string.gsub(name, '[\\.]+', '-'))
    name = string.gsub(name, '-nvim$', '')
    local exists = file_exists(name)
    local fname = 'configs.' .. string.lower(name)
    if exists and not state.configs_loaded[name] then
      logger:trace('config exists: ' .. fname)
      state.configs_checked[name] = true
      plugin.config = function(loaded_plug)
        local event = loaded_plug._.loaded
        logger:debug(fname .. ' loading', event)
        local mod, mod_ok = vim.import(fname)
        if not mod_ok then
          state.errors[fname] = mod
          logger:error('ERROR: ' .. fname .. vim.inspect(mod))
        else
          state.configs_loaded[name] = true
          return mod
        end
      end
    else
      state.configs_checked[name] = false
    end
    return plugin, name
  end
end

local apply_configs = function(plugins)
  for _, _plugin in ipairs(plugins) do
    local plugin, name = check_config_file(_plugin)
    if plugin.lazy and not state.lazy[name] then
      state.lazy[name] = plugin
    elseif not state.start[name] then
      state.start[name] = plugin
    end
  end
  return plugins
end

return {
  apply = apply_configs,
}
