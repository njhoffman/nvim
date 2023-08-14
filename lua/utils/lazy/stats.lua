local state = {
  start = {},
  lazy = {},
  configs = {},
  configs_checked = {},
  configs_loaded = {},
  errors = {},
}

-- [339] = {
--     [1] = "andrewferrier/debugprint.nvim",
--     _ = { installed = true, loaded = { event = "VeryLazy", time = 598385 } },
--     event = { [1] = "VeryLazy" }, lazy = true, name = "debugprint.nvim",
--     dir = "/home/nicholas/.local/share/nvim/lazy/debugprint.nvim",
--     url = "https://github.com/andrewferrier/debugprint.nvim.git" },
local print_config = function(name, plugins)
  local plugins = require('lazy').plugins()
  local stats = require('lazy').stats()
  local line = '(' .. stats.loaded .. ':' .. stats.count .. ')'
  line = line .. ':' .. #vim.tbl_keys(state.configs) .. ') +' .. #plugins .. ' ' .. name
  if #state.errors > 0 then
    line = line .. ', errors: ' .. #vim.tbl_keys(state.errors)
  end
  vim.notify(line)
end

local print_stats = function(name, plugins)
  local stats = require('lazy').stats()
  --   count = 340, loaded = 255, real_cputime = true, startuptime = 624.262988,
  --   times = { LazyDone = 317.694648, LazyStart = 12.678501, UIEnter = 624.262988 }
  local line = ' '
    .. tostring(stats.loaded)
    .. ' :'
    .. tostring(stats.count)
    .. '   '
    .. tostring(stats.startuptime)
    .. '\n LazyStart   '
    .. tostring(stats.times.LazyStart)
    .. '\n LazyDone   '
    .. tostring(stats.times.LazyDone)
    .. '\n UIEnter    '
    .. tostring(stats.times.UIEnter)
  vim.notify(line, { timeout = 10000 })
end

local get_stray_configs = function()
  local scan = require('plenary.scandir')
  local basepath = vim.fn.stdpath('config') .. '/lua/plugs/config'
  local files = scan.scan_dir(basepath, {
    depth = 1,
    search_pattern = '.lua$',
  })
  local strays = {}
  for i, file in ipairs(files) do
    local name_parts = vim.split(file, '/')
    local config_name = string.gsub(name_parts[#name_parts], '.lua$', '')
    if not state.configs[config_name] then
      table.insert(strays, config_name)
    end
  end
  vim.dbglog(strays, state.configs)
  return strays
end

vim.api.nvim_create_user_command('LazyStats', print_stats, { desc = 'Output lazy plugin stats' })
vim.api.nvim_create_user_command('LazyConfigs', print_config, { desc = 'Output lazy plugin config stats' })

return {
  state = state,
}
