-- local notify = require('notify')
-- local task_error = require('notifications.task-error')
-- task_error.test_render()

-- function _G.show_capabilities()
--   for _, client in pairs(vim.lsp.buf_get_clients(0)) do
--     print(
--       vim.inspect(client.name)
--       .. "\n\n"
--       .. vim.inspect(client.server_capabilities)
--       .. "\n\n"
--     )
--   end
-- end

-- local handlers = {}
-- for name in pairs(vim.lsp.handlers) do
--   local request = vim.lsp._request_name_to_capability[name]
--   if request ~= nil and not vim.tbl_isempty(request) then
--     table.insert(handlers, { name, request[1] })
--     vim.dbglog(name, request[1])
--   else
--     table.insert(handlers, { name })
--     vim.dbglog(name)
--   end
-- end

-- vim.dbg()
-- _G.show_capabilities()

local importmod = require('import')
vim.dbglog(importmod.get_imported_modules())
