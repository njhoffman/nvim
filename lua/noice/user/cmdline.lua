-- local cmd_toggle_handler = function()
--   if info.type == ':' then
--     if not cmdline:find('^lua') then
--       if not cmdline:find('^=') then
--         cmdline = 'lua ' .. cmdline
--       elseif cmdline:find('^=') then
--         cmdline = 'lua ' .. cmdline:sub(2)
--       else
--         cmdline = '=' .. cmdline
--       end
--     end
--     vim.dbglog('setting cmdline', cmdline)
--     vim.fn.setcmdline(cmdline)
--   end
-- end

local noice_cmd = require('noice.ui.cmdline')
local orig_ohide = noice_cmd.on_hide

-- noice_cmd.on_hide = function(_, level)
--   if noice_cmd.cmdlines[level] then
--     vim.dbglog(noice_cmd.active)
--     -- noice_cmd.cmdlines[level] = nil
--     -- local active = noice_cmd.active
--     -- vim.defer_fn(function()
--     --   if noice_cmd.active == active then
--     --     noice_cmd.active = nil
--     --   end
--     -- end, 100)
--     noice_cmd.update()
--   else
--     vim.dbglog('skip')
--   end
-- end

local augroup = vim.api.nvim_create_augroup('noice_cmd', { clear = true })

-- vim.api.nvim_create_autocmd('CmdlineEnter', {
--   pattern = '*',
--   group = augroup,
--   callback = function()
--     vim.dbglog('hey', noice_cmd)
--     if noice_cmd.active then
--       local curr = noice_cmd.active
--       vim.dbglog(curr.class.content[1], curr.class.offset, curr.class.level, curr)
--     end
--     -- if info.type == ':' then
--     --   if not cmdline:find('^lua') then
--     --     if not cmdline:find('^=') then
--     --       cmdline = 'lua ' .. cmdline
--     --     elseif cmdline:find('^=') then
--     --       cmdline = 'lua ' .. cmdline:sub(2)
--     --     else
--     --       cmdline = '=' .. cmdline
--     --     end
--     --   end
--     --   vim.dbglog('setting cmdline', cmdline)
--     --   vim.fn.setcmdline(cmdline)
--     -- end
--   end,
-- })

-- noice_cmd.on_pos = function(props, winid)
--   local curr = noice_cmd.active.active
--   local offset, kind = curr.offset, curr.kind
-- end

-- noice_cmd.on_render = function(props, winid)
--   local curr = noice_cmd.active.active
--   local offset, kind = curr.offset, curr.kind
--   curr.on_show = function()
--     vim.dbglog(curr.class.content[1], curr.class.prompt, curr.class.level, curr.class.pos)
--   end
-- end

-- active.. position =
--   { buf = 2225, bufpos = { col = 4, row = 1 }, screenpos = { col = 35, row = 11 }, win = 3233 }
