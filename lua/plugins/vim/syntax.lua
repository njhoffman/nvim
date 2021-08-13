-- Allows users to specify the type of embedded script highlighting
-- they want:  (perl/python/ruby/tcl support)
--   g:vimsyn_embed == 0   : don't embed any scripts
--   g:vimsyn_embed =~# 'l' : embed lua      (but only if vim supports it)
--   g:vimsyn_embed =~# 'm' : embed mzscheme (but only if vim supports it)
--   g:vimsyn_embed =~# 'p' : embed perl     (but only if vim supports it)
--   g:vimsyn_embed =~# 'P' : embed python   (but only if vim supports it)
--   g:vimsyn_embed =~# 'r' : embed ruby     (but only if vim supports it)
--   g:vimsyn_embed =~# 't' : embed tcl      (but only if vim supports it)
vim.g.vimsyn_embed = "--lmpPr"

vim.g.jsx_pretty_highlight_close_tag = 1
vim.g.jsx_pretty_colorful_config = 1
vim.g.jsx_pretty_disable_tsx = 0
vim.g.jsx_pretty_disable_jsx = 0
