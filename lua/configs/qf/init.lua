local cfg = {
  close_other = true,
  pretty = false,
  c = {
    follow_slow = false, -- Only follow on CursorHold
    auto_follow = 'nearest', -- Follow current entry, possible values: prev,next,nearest, or false to disable
    auto_follow_limit = false, -- Do not follow if entry is further away than x lines
    wide = true, -- Open list at the very bottom of the screen, stretching the whole width.
  },
}

require('qf').setup(cfg)
-- vim.api.nvim_create_autocmd('QuickFixCmdPost', { expr = true, cwindow = true })
vim.cmd([[
augroup quickfix
    autocmd!
    " autocmd QuickFixCmdPost cexpr cwindow
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l* lwindow
augroup END
]])

require('configs.qf.render')
