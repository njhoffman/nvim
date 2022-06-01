vim.g.start_time = vim.fn.reltime()
vim.api.nvim_command [[set termguicolors]]

local home = os.getenv("HOME")
package.path = home .. "/.luarocks/share/lua/5.4/?.lua;" .. package.path
package.cpath = home .. "/.luarocks/lib/lua/5.4/?.so;" .. package.cpath

vim.lsp.log_levels["INSPECT"] = 4
vim.lsp.log_levels["TASK"] = 4
vim.lsp.log_levels["STATUS"] = 4

vim.logger = require("logger").init("root")
vim.notify = require("logger.notify").notify
vim.dbglog = require("debuglog").log
vim.dbgbuf = require("debuglog").buf
vim.dbg = require("debuglog").dbg
vim.dbg_test = function()
  vim.dbg(vim.api.nvim_get_all_options_info())
end

vim.notify_test = function()
  local str = "Error loading telescope plugin: telescope-find-pickers - .../start/telescope.nvim/"
  str = str .. "lua/telescope/_extensions/init.lua:10: 'telescope-find-pickers' extension doesn't "
  str = str ..
    "exist or isn't installed: module 'telescope._extensions.telescope-find-pickers' not found:"
  vim.notify(str, "error")
end

-- vim.logger:trace("test")
-- vim.logger:info("info test")
-- vim.logger:error("error test")
-- vim.notify = require("notify")
