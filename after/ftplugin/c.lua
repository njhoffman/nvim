-- local notify_filter = vim.notify
-- vim.notify = function(msg, ...)
--   if msg:match('warning: multiple different client offset_encodings detected for buffer, this is not supported yet') then
--     return
--   end
--
--   notify_filter(msg, ...)
-- end

--
-- " Include macros in completion
-- setlocal complete+=d
--
-- " Set include pattern
-- setlocal include=^\\s*#\\s*include
--
-- " Include headers on UNIX
-- if has('unix')
--   setlocal path+=/usr/include
-- endif
-- vim.opt.commentstring = '//%s'
-- let b:undo_ftplugin .= '|setlocal complete< include< path<'

vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
-- vim.opt.ofu = 'v:lua.vim.lsp.omnifunc'
