local config = require("config")
local u = require("utils.core")
local Formatting = config.Formatting
local Opts = config.Opts

-- #{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]}#W .
vim.cmd [[
  command! SqlVis silent !tmux display-popup -b rounded -S 'fg=\#2255AA' -T '' -E -h 70\% -w90\% "psql --csv postgres://spadash:spadash@localhost/spadash --file=%:p | /bin/zsh -c 'vd -f csv --color-default=\"8 on black\" '"
]]

function goto_last_pos()
  local last_pos = vim.fn.line('\'"')
  if last_pos > 0 and last_pos <= vim.fn.line("$") then
    vim.api.nvim_win_set_cursor(0, {last_pos, 0})
  end
end
-- vim.cmd [[autocmd BufReadPost * lua goto_last_pos()]]

-- local M = {}

-- M.vimadeCheck = function()
--   if vim.bo.filetype == "dapui_scopes" then vim.cmd([[VimadeBufDisable]]) end
--   -- print(vim.bo.filetype)
-- end

-- Print a short info of the selected list in the command-line after switching lists:
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
  augroup ime
    autocmd InsertEnter * call chansend(v:stderr, "\e[?737769h")
    autocmd InsertLeave * call chansend(v:stderr, "\e[?737769l")
  augroup END
]]
)

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


local autocmds = {
  Marks = {
    {"BufRead,BufEnter", "*", "lua require('marks').refresh()"},
    {"BufRead,BufDelete", "*", "lua require('marks')._on_delete()"},
    -- { "BufEnter", "*", "if &buftype == 'prompt' | MarksToggleSigns | endif" },
    -- { "BufEnter", "*", "if &filetype == 'nofile' | MarksToggleSigns | endif" },
    {"BufRead", "*.md", "lua require('neuron').update_virtual_titles()"}
  },
  SecondaryBuffers = {},
  SecondaryWindows = {
    -- quickix, locations, help, man, undo, and other windows I want to exit easily from
    -- todo: think of an easy way to close theese windows without focus
    {"FileType", "dashboard", "nnoremap <buffer> q :BufferDelete<cr> | nnoremap <buffer>  :BufferDelete<cr>"},
    {"FileType", "fugitive", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>"},
    {"FileType", "notify", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>"},
    {"FileType", "qf", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>"},
    {"FileType", "nerdtree", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>"},
    {"FileType", "help", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>"},
    {"FileType", "Mundo", "nnoremap <buffer>  :q<cr>"},
    {"FileType", "MundoDiff", "nnoremap <buffer>  :q<cr>"}
  },
  fasd = {{"BufWinEnter,BufFilePost", "*", [[call Fasd_update()]]}},
  CommandWin = {
    {"CmdwinEnter", "*", "let b:cpt_save = &cpt | set cpt=."},
    {"CmdwinLeave", "*", "let &cpt = b:cpt_save | let g:lens#disabled = 1"},
    {"CmdwinEnter", "*", "nnoremap <buffer><esc> <C-c><C-c>"},
    {"CmdwinEnter", "*", "setlocal nonumber norelativenumber signcolumn=yes:1 | startinsert"}
  },
  FiletypeDetect = {
    {"BufNewFile,BufRead", "*", "setlocal signcolumn=yes:1"},
    {"BufNewFile,BufRead", "*.ejs", "set ft=html"},
    {"BufNewFile,BufRead", "*.bash*", "let b:is_bash = 1 | setfiletype bash"},
    {"BufNewFile,BufRead", ".env.*", "setlocal ft=config syn=config"},
    {"BufNewFile,BufRead", "*.env", "setlocal ft=config syn=config"},
    -- { "BufNewFile,BufRead", "*.md", "setlocal ft=markdown.pandoc conceallevel=2 synmaxcol=500" },
    {"BufRead,BufEnter", "*.md", "setlocal ft=markdown.pandoc conceallevel=2 nospell"},
    {"BufNewFile,BufRead", ".tasks", "setlocal ft=dosini"},
    {"BufNewFile,BufRead", "*.visidatarc", "setlocal ft=python"},
    {"BufNewFile,BufRead", ".vimtasks", "setlocal ft=dosini"},
    {"BufNewFile,BufRead", "*.cheat", "setlocal ft=bash | let b:is_bash =1"},
    {"BufNewFile,BufRead", "Dockerfile*", "setlocal ft=Dockerfile"},
    {"BufNewFile,BufRead", "Dockerfile.*", "setlocal ft=Dockerfile"},
    {"BufNewFile,BufRead", ".dockerignore", "setlocal ft=gitignore"},
    {"BufNewFile,BufRead", "nord-nick-lush.lua", "setlocal ft=lush syn=lua"},
    {"BufNewFile,BufRead", "nord-nvim.lua", "setlocal ft=lush syn=lua"},
    {"BufNewFile,BufRead", "*.t", "setlocal ft=tangle"},
    {"BufNewFile,BufRead", "git", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>"}

    --   au BufNewFile,BufRead *.module setlocal ft=php syn=php
    --   " force bash syntax for shell scripts by default custom syntax extension assignments
    --   au BufNewFile,BufRead .pa set ft=config
    --   au BufNewFile,BufRead Chart.yaml  set ft=helm
    --   au BufNewFile,BufRead values.yaml set ft=helm
    --   au BufNewFile,BufRead */templates/*.yaml set ft=helm
    --   au BufNewFile,BufRead */templates/*.tpl set ft=helm
    --   au BufNewFile,BufRead */templates/*.txt set ft=helm
    --   au BufNewFile,BufRead */ansible/*.yml  set ft=yaml.ansible
    --   au BufNewFile,BufRead *.j2,*/ansible/*/templates/* set ft=config.jinja2
    --   au BufNewFile,BufRead bundles.txt setlocal ft=sh
    --   au BufNewFile,BufRead bundles.*.txt setlocal ft=sh
    --   au BufNewFile,BufRead *.sock setlocal ft=systemd
    --   au BufNewFile,BufRead *.service setlocal ft=systemd
    --   " au BufEnter * if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' | setf preview | endif
  },
  vimade = {
    {"FileType", "Trouble", "VimadeBufDisable"},
    {"FileType", "qf", "VimadeBufDisable"},
    {"FileType", "nerdtree", "VimadeBufDisable"},
    {"FileType", "Mundo", "VimadeBufDisable"},
    {"FileType", "MundoDiff", "VimadeBufDisable"}
    -- { "CompleteChanged", "*", "redraw" },
    -- { "FocusLost", "*", "VimadeFadeActive" },
    -- { "FocusGained", "*", "VimadeUnfadeActive" },
    -- { "BufLeave,FocusLost", "*", M.vimadeCheck() },
    -- { "BufEnter", "dapui_scopes", "VimadeBufDisable" },
    -- { "BufEnter", "dapui_breakpoints", "VimadeBufDisable" },
    -- { "BufEnter", "dapui_watches", "VimadeBufDisable" },
    -- { "BufEnter", "dapui_stacks", "VimadeBufDisable" },
    -- { "BufEnter", "dap-repl", "VimadeBufDisable" },
  },
  BufferRedraws = {{"VimEnter", "*", "BarbarColors"}},
  -- FileTypes = {
  --   -- { "FileType", "lua.lush", "" },
  --   {"FileType", "markdown.pandoc", "set conceallevel=2 nospell"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH1 guifg=#45a5f8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH2 guifg=#45a5e8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH3 guifg=#45a5d8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH4 guifg=#45a5c8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH5 guifg=#45a5b8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH6 guifg=#45a5a8"},
  --   -- { "FileType", "*", "setlocal formatoptions-=c formatoptions-=r formatoptions-=o" },
  --   {"FileType", "toggleterm", "setlocal nonumber norelativenumber"}
  -- },
  -- shutdown = {
  --   -- save session on exit (:h v:this_session)
  --   { "VimLeavePre", "*", "execute 'mksession! " .. vim.fn.stdpath("data") .. "/sessions/previous.vim'" },
  -- },
  Shape = {
    {"FocusLost", "*", "hi TermCursor cterm=NONE gui=NONE"},
    {"FocusGained", "*", "hi TermCursor cterm=reverse gui=reverse"},
    {"VimLeave,VimSuspend", "*", "set guicursor=a:block-blinkon90"}
  },
  terminal = {
    {"TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]]}
    -- {"TermOpen", "*", "set nonumber norelativenumber"},
    -- {"TermLeave", "*", "set number relativenumber"}
  },
  writeEventts = {
    {"BufWritePost", ".tmux.conf", [[execute ':!tmux source-file %']]}
    --   { "BufWritePost", "load.lua", "PackerCompile" },
  },
  packer = {{"User", "PackerComplete,PackerCompileDone", "BarbarColors"}}
}

-- lsp = {
--   {"CursorHold,CursorHoldI", "*", "lua require'nvim-lightbulb'.update_lightbulb()"}
-- }

local shadaEvents = require("main.shada")

table.insert(autocmds, shadaEvents)

local number_toggle = {
  {
    "BufEnter,FocusGained,InsertLeave",
    "*",
    "if &filetype != 'dashboard' && &buftype != 'prompt' && &filetype != 'nofile' && &buftype != 'nofile' | set relativenumber | endif"
  },
  {"BufLeave,FocusLost,InsertEnter", "*", "set norelativenumber"}
}
table.insert(autocmds, number_toggle)

-- define tables to insert
local hl_yank = {
  {
    "TextYankPost",
    "*",
    "silent! lua vim.highlight.on_yank { higroup = 'IncSearch', timeout=400 }"
  }
}

if Opts.highlight_yank == true or Opts.highlight_yank == nil then
  table.insert(autocmds, hl_yank)
end

local preserve_cursor = {{"BufReadPost", "*", "lua goto_last_pos()"}}

local trim_whitespaces = {
  {"BufWritePre", "*", [[%s/\s\+$//e]]},
  {"BufWritePre", "*", [[%s/\n\+\%$//e]]}
  -- {"BufWritePre", "*.[ch]", [[*.[ch] %s/\%$/\r/e]]}
}

-- insert tables if true or nil
if Opts.preserve_cursor == true or Opts.preserve_cursor == nil then
  table.insert(autocmds, preserve_cursor)
end

--[[ if Formatting.format_on_save == true or Formatting.format_on_save == nil then
  -- table.insert(autocmds, format)
end ]]
-- " Return to last edit position when opening files (You want this!)
-- au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

if Formatting.trim_trailing_space == true or Formatting.trim_trailing_space == nil then
  table.insert(autocmds, trim_whitespaces)
end

u.define_augroups(autocmds)
