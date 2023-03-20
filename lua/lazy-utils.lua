local stats = {}

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
    -- vim.dbglog('checking: ' .. fname)
    if exists and not stats.configs[name] then
      stats.configs[name] = true
      plugin.config = function(_, opts)
        local mod, mod_ok = vim.import(fname)
        if not mod_ok then
          vim.notify("ERROR: " .. fname .. vim.inspect(mod), 4)
          stats.errors[fname] = mod
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
    if plugin.lazy and not stats.lazy[name] then
      -- vim.dbglog("LAZY: ", plugin.name, plugin)
      stats.lazy[name] = plugin
    elseif not stats.start[name] then
      -- vim.dbglog("load: ", plugin.name, plugin)
      stats.start[name] = plugin
    end
  end
  return plugins
end

local is_loaded = function(name)
  local plugins = require("lazy.core.config").spec.plugins
  return plugins[name] and plugins[name]._.loaded
end

local is_installed = function(name)
  local plugins = require("lazy.core.config").spec.plugins
  return plugins[name] and plugins[name]._.installed
end

local print_stats = function(name, plugins)
  local line = "(" .. #vim.tbl_keys(stats.start) .. ":" .. #vim.tbl_keys(stats.lazy)
  line = line .. ":" .. #vim.tbl_keys(stats.configs) .. ") +" .. #plugins .. " " .. name
  if #stats.errors > 0 then
    line = line .. ", errors: " .. #vim.tbl_keys(stats.errors)
  end
  vim.dbglog(line)
end

local get_stray_configs = function()
  local scan = require("plenary.scandir")
  local basepath = vim.fn.stdpath("config") .. "/lua/plugs/config"
  local files = scan.scan_dir(basepath, {
    depth = 1,
    search_pattern = ".lua$",
  })
  local strays = {}
  for i, file in ipairs(files) do
    local name_parts = vim.split(file, "/")
    local config_name = string.gsub(name_parts[#name_parts], ".lua$", "")
    if not stats.configs[config_name] then
      table.insert(strays, config_name)
    end
  end
  vim.dbglog(strays, stats.configs)
  return strays
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
    install = {
      colorscheme = { "nord-nick", "habamax" },
    },
    dev = {
      path = "~/scratch",
      ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
      patterns = {},
      fallback = false,
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
        -- "netrw",
        -- "netrwPlugin",
        -- "netrwSettings",
        -- "netrwFileHandlers",
        -- "matchit",
        -- "matchparen",
        "2html_plugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "rrhelper",
        "spellfile_plugin",
        "tar",
        "tarPlugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  })
end

return {
  init = init,
  is_installed = is_installed,
  is_loaded = is_loaded,
  apply_configs = apply_configs,
  print_stats = print_stats,
  get_stray_configs = get_stray_configs,
}
