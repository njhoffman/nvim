--   ["Telegraph.nvim"] = { _ = {
--   cache = { cmd_list = { "Telegraph" } },
--       frags = { 419 },
--       handlers = { cmd = { Telegraph = "Telegraph" } },
--       installed = true,
--       top = true
--     },
--     dir = "/home/nicholas/.local/share/nvim/lazy/Telegraph.nvim",
--     lazy = true,
--     name = "Telegraph.nvim",
--     url = "https://github.com/WaylonWalker/Telegraph.nvim.git",
--     [<metatable>] = {
--       __index = { "WaylonWalker/Telegraph.nvim",
--         cmd = "Telegraph",
--         config = '<function 4>',
--         dependencies = false
--       }
--     }
--   },
-- local lazy_plugins = require("lazy.core.config").plugins
--       ["action-hints.setup"] = {
--       error_logs = {}, import_end = 12339816328364, import_message = true,
--       import_start = 12339815012554, import_time = 1315810,
--       load_n = 76, print_logs = {}
--       },
-- local import_paths = require('import.commands.state').get_all_modules()
-- local import_paths = require("import.commands.state").status.info
-- local plugins = require("lazy").plugins()
-- local keys = {}
--
-- for _, plugin in ipairs(plugins) do
--   table.insert(keys, plugin.name)
-- end

local get_reload_list = function(opts)
  local get_desc = function(req)
    return type(req) == "function" and "function"
      or type(req) == "table" and tostring(#vim.tbl_keys(req)) .. " keys"
      or tostring(req)
  end

  local package_loaded = vim.tbl_keys(package.loaded)
  local reload_list = {}

  -- filter out packages we don't want and track the longest package name
  local column_len = 0
  for index, module_name in pairs(package_loaded) do
    local req = require(module_name)
    local item = {
      type = type(req),
      index = index,
      filepath = _G.Find_Required_Path(module_name),
      packagepath = package.searchpath(module_name, package.path) or "",
      desc = get_desc(req),
      name = module_name,
    }
    column_len = math.max(column_len, #module_name)
    table.insert(reload_list, item)
  end
  return vim.fn.reverse(vim.fn.sort(reload_list, function(a, b)
    return a.name < b.name
  end)),
    column_len
end

return get_reload_list
