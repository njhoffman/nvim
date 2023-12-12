local Manager = require('noice.message.manager')
local router = require('noice.message.router')
-- local messages = Manager.get({ event = 'msg_show' }, { sort = true })
local messages = Manager.get(nil, { sort = true })
-- -- remove any deleted messages
-- has = true,
-- -- remove messages that we are adding
-- ["not"] = {
--   message = messages,
-- },
-- vim.dbglog(messages[1]:content())

if #messages > 0 then
  vim.dbglog(messages[1]:content())
end
-- vim.dbglog(messages[0]:content())

-- for _, message in ipairs(messages) do
--   -- debug, mtime _lines, tick
--   for _, route in ipairs(router._routes) do
--     -- filter, view, opts
--     if message:is(route.filter) then
--       if not route.opts.skip then
--         -- route.view:push(message)
--         -- route.view._route_opts = vim.tbl_deep_extend('force', route.view._route_opts or {}, route.opts or {})
--         -- updates[route.view] = true
--       end
--       if route.opts.stop ~= false then
--         break
--       end
--     end
--   end
-- end

-- for _, msg in ipairs(messages) do
-- end

-- local message = Message(M.event, "message", result.message)
-- message.opts.title = "LSP Message (" .. client_name .. ")"
