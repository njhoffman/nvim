local stats = require("utils.lazy.stats")

local file_exists = function(name)
  local path = vim.fn.stdpath("config") .. "/lua/plugs/config/" .. name .. ".lua"
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    path = vim.fn.stdpath("config") .. "/lua/plugs/config/" .. name .. "/init.lua"
    f = io.open(path, "r")
    if f ~= nil then
      io.close(f)
      return true
    end
    return false
  end
end

local check_config_file = function(plugin)
  local name = ""
  if type(plugin) == "table" and type(plugin.name) == "string" then
    name = plugin.name
  elseif type(plugin) == "table" and (plugin.url or plugin.dir) then
    name = plugin.url or plugin.dir
    local name_parts = vim.split(name, "/")
    name = name_parts[#name_parts]
  elseif type(plugin) == "table" and type(plugin[1]) ~= "nil" then
    name = vim.split(plugin[1], "/")[2]
  else
    vim.notify("Error processing plugin: " .. vim.inspect(plugin), 1)
  end

  if type(name) == "string" and #name > 0 then
    name = string.lower(string.gsub(name, "[\\.]+", "-"))
    name = string.gsub(name, "-nvim$", "")
    local exists = file_exists(name)
    local fname = "plugs.config." .. string.lower(name)
    stats.state.configs_checked[name] = true
    -- vim.dbglog("checking: " .. fname)
    if exists and not stats.state.configs_loaded[name] then
      stats.state.configs_loaded[name] = true
      plugin.config = function(_, _)
        local mod, mod_ok = vim.import(fname)
        if not mod_ok then
          vim.notify("ERROR: " .. fname .. vim.inspect(mod), 4)
          stats.state.errors[fname] = mod
        end
        return mod
      end
    end
    return plugin, name
  end
end

local apply_configs = function(plugins)
  for _, _plugin in ipairs(plugins) do
    local plugin, name = check_config_file(_plugin)
    if plugin.lazy and not stats.state.lazy[name] then
      -- vim.dbglog("LAZY: ", plugin.name, plugin)
      stats.state.lazy[name] = plugin
    elseif not stats.state.start[name] then
      -- vim.dbglog("load: ", plugin.name, plugin)
      stats.state.start[name] = plugin
    end
  end
  return plugins
end

return {
  apply = apply_configs,
}
