local cfg = {
  close_other = true,
  pretty = false,
  l = {
    -- unfocus_close = true,
    -- focus_open = true,
    auto_close = true,
    auto_open = false,
    follow_slow = false,
    auto_follow = 'nearest',
    auto_follow_limit = false,
    wide = true,
  },
  c = {
    -- unfocus_close = true,
    -- focus_open = true,
    auto_close = true,
    auto_open = false,
    follow_slow = false, -- Only follow on CursorHold
    auto_follow = 'nearest', -- Follow current entry, possible values: prev,next,nearest, or false to disable
    auto_follow_limit = false, -- Do not follow if entry is further away than x lines
    wide = true, -- Open list at the very bottom of the screen, stretching the whole width.
  },
}

require('qf').setup(cfg)
require('configs.qf.render')

-- -- vim.api.nvim_create_autocmd('QuickFixCmdPost', { expr = true, cwindow = true })
-- vim.cmd([[
-- augroup quickfix
--     autocmd!
--     " autocmd QuickFixCmdPost cexpr cwindow
--     autocmd QuickFixCmdPost [^l]* cwindow
--     autocmd QuickFixCmdPost l* lwindow
-- augroup END
-- ]])

-- nnoremap <leader>lo <cmd>lua require'qf'.open('l')<CR> " Open location list
-- nnoremap <leader>lc <cmd>lua require'qf'.close('l')<CR> " Close location list
-- nnoremap <leader>ll <cmd>lua require'qf'.toggle('l', true)<CR> " Toggle location list and stay in current window
--
-- nnoremap <leader>co <cmd>lua require'qf'.open('c')<CR> " Open quickfix list
-- nnoremap <leader>cc <cmd>lua require'qf'.close('c')<CR> " Close quickfix list
-- nnoremap <leader>cl <cmd>lua require'qf'.toggle('c', true)<CR> "Toggle quickfix list and stay in current window
--
-- nnoremap <leader>j <cmd>lua require'qf'.below('l')<CR> " Go to next location list entry from cursor
-- nnoremap <leader>k <cmd>lua require'qf'.above('l')<CR> " Go to previous location list entry from cursor
--
-- nnoremap <leader>J <cmd>lua require'qf'.below('c')<CR> " Go to next quickfix entry from cursor
-- nnoremap <leader>K <cmd>lua require'qf'.above('c')<CR> " Go to previous quickfix entry from cursor
--
-- nnoremap ]q <cmd>lua require'qf'.below('visible')<CR> " Go to next entry from cursor in visible list
-- nnoremap [q <cmd>lua require'qf'.above('visible')<CR> " Go to previous entry from cursor in visible list
