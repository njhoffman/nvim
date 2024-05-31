local set_option = vim.api.nvim_set_option_value
local get_option = vim.api.nvim_get_option_value

-- ensure winbar remains the same when changing from WinBar to WinBarNC during opening
local winbar_sync = function(ev)
  local bufid = ev.buf
  local winid = vim.fn.bufwinid(bufid)
  local winhl = 'WinBarNC:WinBar'
  local old_winhl = vim.api.nvim_get_option_value('winhl', { win = winid })

  if old_winhl and #old_winhl > 0 then
    winhl = old_winhl .. ',' .. winhl
  end

  vim.api.nvim_set_option_value('winhl', winhl, { win = winid })

  vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    group = 'TelescopeWinbar',
    buffer = bufid,
    callback = function()
      local new_winhl = get_option('winhl', { win = winid }):gsub(',?WinBarNC:WinBar', '')
      -- set_option('winhl', new_winhl, { win = winid })
      return true
    end,
  })
end

-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'TelescopePreviewerLoaded',
--   callback = function(args)
--     -- require('scrollbar.handlers').show()
--
--     vim.defer_fn(function()
--       require('scrollbar.handlers.search').handler.show({})
--       vim.cmd('ScrollbarShow')
--     end, 1000)
--     vim.dbglog('PREVIEWER', args)
--   end,
-- })
-- Enable indent-guides in telescope preview
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'TelescopePreviewerLoaded',
--   group = vim.api.nvim_create_augroup('rafi_telescope', {}),
--   callback = function(args)
--     if args.buf ~= vim.api.nvim_win_get_buf(0) then
--       return
--     end
--     vim.opt_local.listchars = vim.wo.listchars .. ',tab:▏\\ '
--     vim.opt_local.list = true
--     vim.opt_local.number = true
--   end,
-- })
--
-- Enable indent-guides in telescope preview
-- vim.api.nvim_create_autocmd('User', {
--   pattern = 'TelescopePreviewerLoaded',
--   group = vim.api.nvim_create_augroup('rafi_telescope', {}),
--   callback = function(args)
--     if args.buf ~= vim.api.nvim_win_get_buf(0) then
--       return
--     end
--     vim.opt_local.listchars = vim.wo.listchars .. ',tab:▏\\ '
--     vim.opt_local.list = true
--     vim.opt_local.number = true
--   end,
-- })
return { winbar_sync = winbar_sync }
