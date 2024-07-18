-- noice_cmd.show = function(...)
--   vim.dbglog('SHOW')
--   return orig.show(...)
-- end

-- noice_cmd.get_layout = function(...)
--   vim.dbglog('GET LAYOUT', ...)
--   return orig.get_layout(...)
-- end

-- noice_cmd.on_show = function(...)
--   -- (event, content, pos, firstc, prompt, indent, level)
--   vim.dbglog('on_show', ...)
--   -- orig.on_show(...)
-- end

-- noice_cmd.on_hide = function(...)
--   -- (_, level)
--   vim.dbglog('on_hide', ...)
--   orig.on_hide(...)
-- end

-- noice_cmd.on_pos = function(...)
--   -- (_, pos, level)
--   -- local curr = noice_cmd.active.active
--   -- local offset, kind = curr.offset, curr.kind
--   vim.dbglog('on_pos', ..., noice_cmd)
--   orig.on_pos(...)
-- end

-- noice_cmd.on_render = function(...)
--   -- (_, buf, line, byte)
--   -- local args = {...}
--   -- local curr = noice_cmd.active.active
--   -- local offset, kind = curr.offset, curr.kind
--   -- curr.on_show = function()
--   --   vim.dbglog(curr.class.content[1], curr.class.prompt, curr.class.level, curr.class.pos)
--   -- end
--   vim.dbglog('on_render')
--   orig.on_render(...)
-- end

local noice_cmd = require("noice.ui.cmdline")

-- buf = 3, event = "CmdlineEnter", file = ":", group = 57, id = 176, match = ":"

local old_fadelevel = nil
-- vim.api.nvim_get_var('vimade').fadelevel
local augroup = vim.api.nvim_create_augroup("cmdline", { clear = true })
vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
  group = augroup,
  callback = function(ev)
    if ev.event == "CmdlineLeave" then
      -- vim.dbglog(
      --   'cmdline leave: ' .. vim.api.nvim_get_current_buf(),
      --   vim.api.nvim_get_current_win()
      -- )
      -- vim.cmd("VimadeBufEnable")
      return
    end
    -- vim.dbglog('cmdline enter: ' .. vim.api.nvim_get_current_buf(), vim.api.nvim_get_current_win())
    -- vim.cmd('VimadeBufDisable')

    local state = {
      cmdopen = false,
      cmdtype = ev.match,
      srcbuf = vim.api.nvim_get_current_buf(),
      srcwin = vim.api.nvim_get_current_win(),
      evbuf = ev.buf,
    }

    -- vim.api.nvim_set_current_buf(state.cmdbuf)
    -- vim.api.nvim_set_current_buf(state.srcbuf)
    -- vim.api.nvim_set_current_win(state.srcwin)
    -- local new_fadelevel = 0.4
    -- vim.cmd('VimadeFadeLevel ' .. new_fadelevel)
  end,
})
-- vim.dbglog(state.srcbuf, state.srcwin, ev)
-- active.position = { buf = 2225, bufpos = { col = 4, row = 1 }, screenpos = { col = 35, row = 11 }, win = 3233 }

-- vim.dbglog(bufnr, vim.fn.getbufinfo(bufnr), vim.fn.getwininfo(winid))
-- vim.cmd('VimadeFadeActive')
-- local offset, kind = curr.offset, curr.kind
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

-- local noice_cmd = require('noice')
-- local augroup = vim.api.nvim_create_augroup('cmdline', { clear = true })
-- local noice_cmd = require('noice.ui.cmdline')
-- local orig = {}
-- local augroup = vim.api.nvim_create_augroup('cmdline', { clear = true })
-- local noice_cmd = require('noice.ui.cmdline')

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
