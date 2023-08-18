local stats_track = function(args) end

--
-- -- [339] = {
-- --     [1] = "andrewferrier/debugprint.nvim",
-- --     _ = { installed = true, loaded = { event = "VeryLazy", time = 598385 } },
-- --     event = { [1] = "VeryLazy" }, lazy = true, name = "debugprint.nvim",
-- --     dir = "/home/nicholas/.local/share/nvim/lazy/debugprint.nvim",
-- --     url = "https://github.com/andrewferrier/debugprint.nvim.git" },
-- local print_config = function(name, plugins)
--   local plugins = require('lazy').plugins()
--   local stats = require('lazy').stats()
--   vim.notify(line)
-- end
--
-- local print_stats = function(name, plugins)
--   local stats = require('lazy').stats()
--   --   count = 340, loaded = 255, real_cputime = true, startuptime = 624.262988,
--   --   times = { LazyDone = 317.694648, LazyStart = 12.678501, UIEnter = 624.262988 }
--   vim.notify(line, { timeout = 10000 })
-- end
--
-- local get_stray_configs = function()
--   local scan = require('plenary.scandir')
--   local basepath = vim.fn.stdpath('config') .. '/lua/configs'
--   local files = scan.scan_dir(basepath, {
--     depth = 1,
--     search_pattern = '.lua$',
--   })
--   local strays = {}
--   for i, file in ipairs(files) do
--     local name_parts = vim.split(file, '/')
--     local config_name = string.gsub(name_parts[#name_parts], '.lua$', '')
--     if not state.configs[config_name] then
--       table.insert(strays, config_name)
--     end
--   end
--   vim.dbglog(strays, state.configs)
--   return strays
-- end
--
-- vim.api.nvim_create_user_command('LazyStats', print_stats, { desc = 'Output lazy plugin stats' })
-- vim.api.nvim_create_user_command('LazyConfigs', print_config, { desc = 'Output lazy plugin config stats' })

local stats_plugins = function(args)
  local state = require('utils.lazy.state')
  vim.dbglog('STATS CONFIG', state.lazy)
  -- zenburn = {
  --     [1] = "phha/zenburn.nvim",
  --     _ = { installed = true },
  --     dir = "/home/nicholas/.local/share/nvim/lazy/zenburn.nvim",
  --     event = { [1] = "User ColorSchemeLoad" },
  --     lazy = true,
  --     name = "zenburn.nvim",
  --     url = "https://github.com/phha/zenburn.nvim.git" }
  -- loaded = { plugin = "cmp_luasnip", time = 7339086 },
end

local stats_overview = function(args)
  local state = require('utils.lazy.state')
  local line = '(' .. state.loaded .. ':' .. state.count .. ')'
  line = line .. ':' .. #vim.tbl_keys(state.configs) .. ') +' .. #plugins .. ' ' .. name
  if #state.errors > 0 then
    line = line .. ', errors: ' .. #vim.tbl_keys(state.errors)
  end
  line = line
    .. '\n'
    .. tostring(state.loaded)
    .. ' :'
    .. tostring(state.count)
    .. '   '
    .. tostring(state.startuptime)
    .. '\n LazyStart   '
    .. tostring(state.times.LazyStart)
    .. '\n LazyDone   '
    .. tostring(state.times.LazyDone)
    .. '\n UIEnter    '
    .. tostring(state.times.UIEnter)
end

local stats_configs = function(args, state)
  local view = args[3]
  local configs = state.get_numbers().configs
  local line = '\n  ' .. configs.loaded .. ' loaded : ' .. configs.checked .. ' checked'
  line = line .. '\n  ' .. configs.exist .. ' exist  : ' .. configs.noexist .. ' not exist'
  vim.dbg(line)
end

local stats = function(args)
  local state = require('utils.lazy.state')
  stats_configs(_, state)
  -- local cmd_map = {
  --   configs = stats_configs,
  -- }
  -- if cmd_map[args[2]] then
  --   cmd_map[args[2]](args)
  -- else
  --   stats_overview(args)
  -- end
end

stats()
--
-- return {
--   stats = stats,
--   stats_track = stats_track,
-- }
