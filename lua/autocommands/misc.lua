-- change background color when in insert mode
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "#030306" })
  end
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  end
})

vim.cmd(
  [=[
augroup qf-history
    autocmd!
    autocmd QuickFixCmdPost chistory echo printf('Quickfix %d of %d (%d items): %s',  getqflist({'nr': 0}).nr,  getqflist({'nr': '$'}).nr,  getqflist({'size': 0}).size,  getqflist({'title': 0}).title )
    autocmd QuickFixCmdPost lhistory echo printf('Location-list %d of %d (%d items): %s',  getloclist(0, {'nr': 0}).nr,  getloclist(0, {'nr': '$'}).nr, getloclist(0, {'size': 0}).size, getloclist(0, {'title': 0}).title )
augroup END
]=]
)
-- Automatically open the quickfix or location-list window after selecting a list in the popup menu:
vim.cmd(
  [[
augroup qf-history
  autocmd!
  autocmd QuickFixCmdPost chistory cwindow
  autocmd QuickFixCmdPost lhistory lwindow
augroup END
]]
)

vim.cmd(
  [[
  augroup IME
    autocmd InsertEnter * call chansend(v:stderr, "\e[?737769h")
    autocmd InsertLeave * call chansend(v:stderr, "\e[?737769l")
  augroup end
]]
)

-- #{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]}#W .
vim.cmd [[
  command! SqlVis silent !tmux display-popup -b rounded -S 'fg=\#2255AA' -T '' -E -h 70\% -w90\% "psql --csv postgres://spadash:spadash@localhost/spadash --file=%:p | /bin/zsh -c 'vd -f csv --color-default=\"8 on black\" '"
]]


-- { "FileType", "nofile", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>" },
--  getcmdwintype()
-- :	normal Ex command
-- >	debug mode command |debug-mode|
-- /	forward search string
-- ?	backward search string
-- =	expression for "= |expr-register|
-- @	string for |input()|
-- -	text for |:insert| or |:append|

-- exit terminal when shell exits
-- au TermClose * call feedkeys("i")

-- vim.cmd [[autocmd BufReadPost * lua goto_last_pos()]]

-- local M = {}

-- M.vimadeCheck = function()
--   if vim.bo.filetype == "dapui_scopes" then vim.cmd([[VimadeBufDisable]]) end
--   -- print(vim.bo.filetype)
-- end

-- Print a short info of the selected list in the command-line after switching lists:
