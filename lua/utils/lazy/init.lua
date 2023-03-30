local setup = require("utils.lazy.setup")
local configs = require("utils.lazy.configs")

local is_loaded = function(name)
  local plugins = require("lazy.core.config").spec.plugins
  return plugins[name] and plugins[name]._.loaded
end

local is_installed = function(name)
  local plugins = require("lazy.core.config").spec.plugins
  return plugins[name] and plugins[name]._.installed
end

return {
  setup = setup,
  apply_configs = configs.apply,
  is_installed = is_installed,
  is_loaded = is_loaded,
}
