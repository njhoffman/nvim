local records = require('mapper.records')
local commands = require('mapper.commands')
local output = require('mapper.output')

vim.api.nvim_create_user_command('KeymapsTree', function(params)
  local args = vim.fn.split(params.args, ' ')
  if args[1] == 'notify' then
    output.tree_notify()
  else
    output.tree_log()
  end
end, { nargs = '?' })

return {
  map = commands.map,
  vmap = commands.vmap,
  prefix = commands.prefix,
  list = records.list,
  tree = records.tree,
  clues = records.clues,
}

-- -- Unsets all keybindings defined in keymaps
-- -- @param keymaps The table of key mappings containing a list per mode (normal_mode, insert_mode, ..)
-- function M.clear(keymaps)
--   local default = M.get_defaults()
--   for mode, mappings in pairs(keymaps) do
--     local translated_mode = mode_adapters[mode] and mode_adapters[mode] or mode
--     for key, _ in pairs(mappings) do
--       -- some plugins may override default bindings that the user hasn't manually overriden
--       if default[mode][key] ~= nil or (default[translated_mode] ~= nil and default[translated_mode][key] ~= nil) then
--         pcall(vim.api.nvim_del_keymap, translated_mode, key)
--       end
--     end
--   end
-- end

-- ---Reset any startup cache files used by lazy.nvim
-- ---It also forces regenerating any template ftplugin files
-- ---Tip: Useful for clearing any outdated settings
-- function M.reset_cache()
--   local lvim_modules = {}
--   for module, _ in pairs(package.loaded) do
--     if module:match "lvim.core" or module:match "lvim.lsp" then
--       package.loaded[module] = nil
--       table.insert(lvim_modules, module)
--     end
--   end
--   Log:trace(string.format("Cache invalidated for core modules: { %s }", table.concat(lvim_modules, ", ")))
--   require("lvim.lsp.templates").generate_templates()
-- end
-- M.reload = function(mod)
--   if not package.loaded[mod] then
--     return M.require_safe(mod)
--   end
--
--   local old = package.loaded[mod]
--   package.loaded[mod] = nil
--   local new = M.require_safe(mod)
--
--   if type(old) == "table" and type(new) == "table" then
--     local repeat_tbl = {}
--     _replace(old, new, repeat_tbl)
--   end
--
--   package.loaded[mod] = old
--   return old
-- end
