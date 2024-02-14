local history = require('neoscroll.stats').history
vim.dbglog(history)
-- vim.dbglog('state', tbl_omit(state, { 'history' }))
local ns = require('neoscroll')

ns.scroll(200, true, 500, 'sine', [[cursorline]])
ns.scroll(-vim.wo.scroll, true, 350)
ns.scroll(vim.wo.scroll, true, 350)
ns.scroll(-vim.api.nvim_win_get_height(0), true, 550)
ns.scroll(vim.api.nvim_win_get_height(0), true, 550)
ns.scroll(-0.10, false, 100)
ns.scroll(0.10, false, 100)
ns.zt(200)
ns.zz(200)
ns.zb(200)

-- scroll(-vim.wo.scroll, true, 350)
-- scroll( vim.wo.scroll, true, 350)
-- scroll(-vim.api.nvim_win_get_height(0), true, 550)
-- scroll( vim.api.nvim_win_get_height(0), true, 550)
-- scroll(-0.10, false, 100)
-- scroll( 0.10, false, 100)
-- nnoremap n :execute "keepjumps norm! " . v:count1 . "nzz"
-- nnoremap N :execute "keepjumps norm! " . v:count1 . "Nzz"
--
-- t['<C-b>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '100' } }
-- t['<PageUp>'] = { 'scroll', { '-vim.api.nvim_win_get_height(0)', 'true', '100' } }
-- t['<C-f>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '100' } }
-- t['<PageDown>'] = { 'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '100' } }
--
-- local api = vim.api
-- -- My workaround for this: (only smooth scroll if buffer is longer than window height)
-- vim.keymap.set('n', 'G', [[<Cmd> lua maybe_smooth_scroll()<CR>]], { noremap = true })
--
-- function _G.maybe_smooth_scroll()
--   local win_height = api.nvim_win_get_height(0)
--   local buf_line_count = api.nvim_buf_line_count(0)
--
--   if buf_line_count < win_height then
--     api.nvim_command('normal! G')
--   else
--     require('neoscroll').scroll(1 * buf_line_count, true, 1, 5)
--   end
-- end
--
-- local function map_key(lhs, rhs)
--   vim.keymap.set({ 'x', 'n' }, lhs, rhs)
-- end
--
--
-- -- map_key("<C-u>", function()
-- --     neoscroll.scroll(-vim.wo.scroll, true, rel_time(vim.wo.scroll))
-- -- end)
-- --
-- -- map_key("<C-d>", function()
-- --     neoscroll.scroll(vim.wo.scroll, true, rel_time(vim.wo.scroll))
-- -- end)
--
-- t['gg'] = { 'scroll', { '-2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }
-- t['G'] = { 'scroll', { '2*vim.api.nvim_buf_line_count(0)', 'true', '1', '5', e } }
-- --
-- -- -- other mappings ...
-- --
-- -- map_key("zz", function()
-- --     neoscroll.zz(rel_time(0.33))
-- -- end)
