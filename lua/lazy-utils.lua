local stats = {}

local file_exists = function(name)
  local path = vim.fn.stdpath("config") .. "/lua/plugs/config/" .. name .. ".lua"
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
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
    name = string.gsub(name, "[\\.]+", "-")
    local exists = file_exists(name)
    local fname = "plugs.config." .. string.lower(name)
    if exists then
      -- vim.dbglog("EXISTS: " .. fname)
      stats.configs[fname] = true
      plugin.config = function(_, opts)
        local mod, mod_ok = vim.import(fname)
        if not mod_ok then
          vim.dbglog("ERROR: " .. fname, mod_ok, mod)
          stats.errors[fname] = mod
        end
        return mod
      end
    end
    return plugin
  end
end

local apply_configs = function(plugins)
  for _, plugin in ipairs(plugins) do
    check_config_file(plugin)
    if plugin.lazy then
      -- vim.dbglog("LAZY: ", plugin.name, plugin)
      table.insert(stats.lazy, plugin)
    else
      -- vim.dbglog("load: ", plugin.name, plugin)
      table.insert(stats.start, plugin)
    end
  end
  return plugins
end

local print_stats = function(name, plugins)
  local line = "(" .. #vim.tbl_keys(stats.start) .. ":" .. #vim.tbl_keys(stats.lazy)
  line = line .. ":" .. #vim.tbl_keys(stats.configs) .. ") +" .. #plugins .. " " .. name
  if #stats.errors > 0 then
    line = line .. ", errors: " .. #vim.tbl_keys(stats.errors)
  end
  vim.dbglog(line)
end

local init = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  stats = require("lazy.stats")._stats
  stats.start = {}
  stats.lazy = {}
  stats.configs = {}
  stats.errors = {}

  require("lazy").setup("plugs", {
    ui = {
      border = "rounded",
    },
    performance = {
      cache = {
        enabled = false,
      },
      reset_packpath = true,
    },
    custom_keys = {
      ["<C-f"] = false,
      -- ["<localleader>f"] = profile_filter
      ["<localleader>l"] = function(plugin)
        require("lazy.util").float_term({ "lazygit", "log" }, {
          cwd = plugin.dir,
        })
      end,
    },
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  })
end

return {
  init = init,
  apply_configs = apply_configs,
  print_stats = print_stats,
}
