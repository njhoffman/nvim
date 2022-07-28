local notify_cmds = {
  "lua vim.notify('TESTING')",
  "lua vim.notify('TESTING 5', 'warn')",
  "lua vim.notify('TESTING 3', 'info')",
  "lua vim.notify('TESTING')",
  "lua vim.notify('TESTING 5', 'warn')",
  "lua vim.notify('TESTING 3', 'info')",
  "lua vim.notify('TESTING')",
}

local dbg_test = function()
  vim.dbg(vim.api.nvim_get_all_options_info())
end

local notify_error = function()
  local str = "Error loading telescope plugin: telescope-find-pickers - .../start/telescope.nvim/"
  str = str .. "lua/telescope/_extensions/init.lua:10: 'telescope-find-pickers' extension doesn't "
  str = str ..
    "exist or isn't installed: module 'telescope._extensions.telescope-find-pickers' not found:"
  vim.notify(str, "error")
end


return {
  notify_cmds = notify_cmds,
  notify_error = notify_error,
  dbg_test = dbg_test
}
