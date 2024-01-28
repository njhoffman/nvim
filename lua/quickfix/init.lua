-- TODO: make todo styling optional
-- TODO: optional winbar with total errors/current errors, title
-- TODO: optional workspace scope for all, buffer scope for all, buffer scope for buffer
-- TODO: QfDiagAll, QfDiagBufAll, QfDiagBuf, QfDiagOff, QfDiagBufOff
-- TODO: Command parameter to set severity, todo items
-- TODO: option for vimade qf list, vimade original buffer, vimade disable qf/original on diag change
-- TODO: vim -q errorfile, vim -q <(yourlinter), vim -q <(!!), vimq() { vim -q <($(fc -nl -1)) }
-- TODO: test telescope live_grep :cdo %s/foo/bar/g
-- TODO: fugitive Git_diftool (all git changes), Gclog, review changes before commit (gitgutter)
-- TODO: After doing any git grep command, just convert it to git jump grep https://github.com/git/git/tree/master/contrib/git-jump
-- TODO: jumplist to quickfix https://github.com/gennaro-tedesco/dotfiles/blob/c1459c3cc97e4d6186decd1fb50b014b54bcfdbe/nvim/lua/utils.lua#L274-L289
-- TODO: helpfiles ToC g0
-- TODO: stefandtw/quickfix-reflector.vim, nvim-bqf
-- TODO: ensure no blinking
-- TODO: investigate initial workspace diagnostics vs switching to buffer
-- TODO: investigate loclist vs qflist behavior

vim.api.nvim_create_autocmd('QuickFixCmdPre', {
  callback = function(ev)
    vim.dbglog('qf pre', ev)
  end,
})
vim.api.nvim_create_autocmd('QuickFixCmdPost', {
  callback = function(ev)
    vim.dbglog('qf post', ev)
  end,
})

require('quickfix.qfview').setup()
require('quickfix.diagnostics').setup()
--
-- To expand on this: neovim 0.6 nightly fetaures a handy setqflist in addition to the already available setloclist, which adds workspace diagnostics to the quickfix list (similar to what this plugin does).
-- I am currently using something like this in my personal config:
-- function update_diagnostics(global_too)
--     if not vim.lsp.buf.server_ready() then
--         return
--     end
--     if vim.fn.getloclist(vim.fn.winnr(), { title = 0 }).title == 'Buffer diagnostics' then
--         vim.diagnostic.setloclist{ open = false, title = 'Buffer diagnostics' }
--     end
--     if global_too and vim.fn.getqflist{ title = 0 }.title == 'Workspace diagnostics' then
--         vim.diagnostic.setqflist{ open = false,  title = 'Workspace diagnostics' }
--     end
-- end
-- and in my setup.on_attach callback I have
--
-- vim.api.nvim_command('autocmd BufWinEnter * lua update_diagnostics(false)')
-- vim.api.nvim_command('autocmd User DiagnosticsChanged lua update_diagnostics(true)')
-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-k>k','<CMD>silent! lua vim.diagnostic.setloclist{ title = "Buffer diagnostics" }<CR>', {noremap=true})
-- vim.api.nvim_buf_set_keymap(0, 'n', '<C-k><C-k>','<CMD>silent! lua vim.diagnostic.setqflist{ title = "Workspace diagnostics" }<CR>', {noremap=true})

-- -- vim.api.nvim_create_autocmd('QuickFixCmdPost', { expr = true, cwindow = true })
-- 	echo getqflist({'lines' : ["F1:10:Line10", "F2:20:Line20"]})
-- 	echo getqflist({'lines' : systemlist('grep -Hn quickfix *')})
-- This returns a dictionary where the "items" key contains the list of quickfix
-- entries parsed from lines. The following shows how to use a custom
-- 'errorformat' to parse the lines without modifying the 'errorformat' option:
-- 	echo getqflist({'efm' : '%f#%l#%m', 'lines' : ['F1#10#Line']})
--

-- vim.api.nvim_exec([[
--   autocmd QuickFixCmdPost [^l]* cwindow
--   autocmd QuickFixCmdPost    l* lwindow
-- ]], false)
-- :vim[grep] — search using Vim’s native functionality.
-- :gr[ep] — search via an external program specified by the grepprg setting.
-- :helpgr[ep] — search help text files.
-- :mak[e] — call the program specified by the makeprg setting (which defaults to make).
-- :cex[pr] {expression} — use {expression} to populate to list. This can be used to clear the quickfix list via :cex [].
-- Quickfix list commands start :c — here’s some useful ones:
--
-- :cw[indow] — Open the quickfix window if it’s non-empty.
-- :cn[ext], :cp[rev] — Jump to next/previous error.
-- :cnf[ile], :cpf[ile] — Jump to first error in the next/previous file.
-- :cab[ove] :cbel[ow] — Jump to the error above/below the current line.
-- Vim remembers the last ten quickfix lists; you can navigate between them with:
--
-- :col[der], :cnew[er] — Go to the older/newer quickfix list.
-- :chi[story] — Show the list of quickfix lists.
--
-- gqr, gqd, gqt : lsp references, definitions, type definitions in quickfix

-- Tip: Operating on the error list
-- A powerful editing technique is to apply an operation or macro to each location or file in the quickfix list. This is done with :cdo or :cfdo respectively. Here are some examples where we populate the quickfix list using :grep (using ripgrep options) then perform a batch edit using :cdo or :cfdo.
--
-- Replace “foo” with “bar” in all Python files containing the string “baz”:
--
-- :grep baz -t py
-- :cfdo %s/foo/bar/g | update
-- Delete lines containing “foo” from all files called urls.py:
--
-- :grep foo -g urls.py
-- :cfdo g/foo/d | update
-- Run macro q on all lines containing “foo”:
--
-- :grep foo
-- :cdo normal @q
-- function! Grep(...)
--     let cmd = join([&grepprg] + [join(a:000, ' ')], ' ')
--     return system(cmd)
-- endfunction
--
-- command! -nargs=+ -complete=file_in_path Grep cexpr Grep(<f-args>)
-- To complement this, you can use a command-line abbreviation to automatically switch :grep to :Grep:
--
-- cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep') ? 'Grep' : 'grep'
-- and an autocommand to open the quickfix window when there are results:
--
-- augroup quickfix
--  autocmd!
--  autocmd QuickFixCmdPost cexpr cwindow
-- augroup END
-- This is life changing.
-- As ever, there are useful bindings from tpope/vim-unimpaired:
--
-- [t, ]t — :tprevious, :tnext
-- [T, ]T — :tfirst, :tlast
-- If you want to show the tag match list when there are multiple matches but jump straight to the tag if a single match, use :tj[ump] or g CTRL-].

-- :g/mypattern/caddexpr expand("%") .. ":" .. line(".") ..  ":" .. getline(".")
-- ERROR: plugs.config.registers"/home/nicholas/.config/nvim/lua/plugs/config/registers.lua:93: Expected Lua number"
