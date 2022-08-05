local config = vim.import("config")
vim.import('autocommands.misc')
vim.import('autocommands.startup')

local Formatting = config.Formatting
local Opts = config.Opts

function goto_last_pos()
  local last_pos = vim.fn.line('\'"')
  if last_pos > 0 and last_pos <= vim.fn.line("$") then
    vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
  end
end

local autocmds = {
  SecondaryWindows = {
    -- quickix, locations, help, man, undo, and other windows I want to exit easily from
    -- todo: think of an easy way to close theese windows without focus
    {
      "FileType",
      "dashboard",
      "nnoremap <buffer> q :BufferDelete<cr> | nnoremap <buffer>  :BufferDelete<cr>"
    },
    { "FileType", "fugitive", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>" },
    { "FileType", "notify", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>" },
    { "FileType", "qf", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>" },
    { "FileType", "nerdtree", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>" },
    { "FileType", "help", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>" },
    { "FileType", "Mundo", "nnoremap <buffer>  :q<cr>" },
    { "FileType", "MundoDiff", "nnoremap <buffer>  :q<cr>" }
  },
  fasd = { {
    "BufWinEnter,BufFilePost",
    "*",
    [[call Fasd_update()]],
  } },

  CommandWin = {
    { "CmdwinEnter", "*", "let b:cpt_save = &cpt | set cpt=." },
    { "CmdwinLeave", "*", "let &cpt = b:cpt_save | let g:lens#disabled = 1" },
    { "CmdwinEnter", "*", "nnoremap <buffer><esc> <C-c><C-c>" },
    { "CmdwinEnter", "*", "setlocal nonumber norelativenumber signcolumn=yes:1 | startinsert" }
  },
  FiletypeDetect = {
    { "BufNewFile,BufRead", "*", "setlocal signcolumn=yes:1" },
    { "BufNewFile,BufRead", "*startuptime.tsv", "setlocal ft=crontab syn=crontab" },
    { "BufNewFile,BufRead", "*.log", "lua require('commands').create_cmd_truncate()" },
    { "BufNewFile,BufRead", "*.ejs", "set ft=html" },
    { "BufNewFile,BufRead", "*.bash*", "let b:is_bash = 1 | setfiletype bash" },
    { "BufNewFile,BufRead", "*.theme", "setlocal ft=config syn=config" },
    { "BufNewFile,BufRead", ".*rc", "setlocal ft=config syn=config" },
    { "BufNewFile,BufRead", ".env.*", "setlocal ft=config syn=config" },
    { "BufNewFile,BufRead", "*.env", "setlocal ft=config syn=config" },
    { "BufNewFile,BufRead", "conf.*", "setlocal ft=config syn=config" },
    -- { "BufNewFile,BufRead", "*.md", "setlocal ft=markdown.pandoc conceallevel=2 synmaxcol=500" },
    { "BufRead,BufEnter", "*.md", "setlocal ft=markdown.pandoc conceallevel=2 nospell" },
    { "BufNewFile,BufRead", ".tasks", "setlocal ft=asynctasks" },
    { "BufNewFile,BufRead", "*.visidatarc", "setlocal ft=python" },
    { "BufNewFile,BufRead", ".vimtasks", "setlocal ft=asynctasks" },
    { "BufNewFile,BufRead", "*.cheat", "setlocal ft=bash | let b:is_bash =1" },
    { "BufNewFile,BufRead", "Dockerfile*", "setlocal ft=Dockerfile" },
    { "BufNewFile,BufRead", "Dockerfile.*", "setlocal ft=Dockerfile" },
    { "BufNewFile,BufRead", ".dockerignore", "setlocal ft=gitignore" },
    { "BufNewFile,BufRead", "nord-nick-lush.lua", "setlocal ft=lush syn=lua" },
    { "BufNewFile,BufRead", "nord-nvim.lua", "setlocal ft=lush syn=lua" },
    { "BufNewFile,BufRead", "*.t", "setlocal ft=tangle" },
    { "BufNewFile,BufRead", "git", "nnoremap <buffer> q :q<cr> | nnoremap <buffer>  :q<cr>" },
    { "BufNewFile,BufRead", "*.conf", "setlocal ft=dosini.conf" },
    { "BufNewFile,BufRead", "*.pa", "setlocal ft=conf" },
    { "BufNewFile,BufRead", "*.service", "setlocal ft=systemd" },
    { "BufNewFile,BufRead", "*.sock", "setlocal ft=systemd" },
    { "BufNewFile,BufRead", "*.sock", "setlocal ft=systemd" },
    { "BufNewFile,BufRead", "Chart.yaml", "set ft=helm" },
    { "BufNewFile,BufRead", "values.yaml", "set ft=helm" },
    { "BufNewFile,BufRead", "*/templates/*.yaml", "set ft=helm" },
    { "BufNewFile,BufRead", "*/templates/*.tpl", "set ft=helm" },
    { "BufNewFile,BufRead", "*/templates/*.txt", "set ft=helm" }
    --   au BufNewFile,BufRead .pa set ft=config
    --   au BufNewFile,BufRead */ansible/*.yml  set ft=yaml.ansible
    --   au BufNewFile,BufRead *.j2,*/ansible/*/templates/* set ft=config.jinja2
    --   au BufNewFile,BufRead bundles.txt setlocal ft=sh
    --   au BufNewFile,BufRead bundles.*.txt setlocal ft=sh
    --   " au BufEnter * if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' | setf preview | endif
  },
  Vimade = {
    { "FileType", "Trouble", "VimadeBufDisable" },
    { "FileType", "qf", "VimadeBufDisable" },
    { "FileType", "nerdtree", "VimadeBufDisable" },
    { "FileType", "Mundo", "VimadeBufDisable" },
    { "FileType", "MundoDiff", "VimadeBufDisable" },
    { "CmdwinEnter", "*", "VimadeBufDisable" },
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
  BufferRedraws = { { "VimEnter", "*", "BarbarColors" } },
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
    { "FocusLost", "*", "hi TermCursor cterm=NONE gui=NONE" },
    { "FocusGained", "*", "hi TermCursor cterm=reverse gui=reverse" },
    { "VimLeave,VimSuspend", "*", "set guicursor=a:block-blinkon90" }
  },
  terminal = {
    { "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] }
    -- {"TermOpen", "*", "set nonumber norelativenumber"},
    -- {"TermLeave", "*", "set number relativenumber"}
  },
  WriteEvents = {
    { "BufWritePost", "*tmux.conf", [[execute ':!tmux source-file %']] }
    --   { "BufWritePost", "load.lua", "PackerCompile" },
  },
  packer = { { "User", "PackerComplete,PackerCompileDone", "BarbarColors" } }
}

-- | if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' && &buftype =~ hidden | silent! wshada | silent! !~/bin/wshada.sh | endif",
-- local shadaEventsViml = { { "BufWrite", "*", [[call ShadaWrite()]] }, { "Signal", "SIGUSR1", [[call ShadaRead()]] } }

if Opts.shada_events == true then
  autocmds.ShadaEvents = {
    { "BufRead", "*", [[call ShadaWrite()]] },
    { "Signal", "SIGUSR1", [[call ShadaRead()]] }
  }
end

if Opts.winbar == true or Opts.winbar ~= nil then
  autocmds.Winbar = require('autocommands.winbar')
end

autocmds.NumberToggle = {
  {
    "BufEnter,FocusGained,InsertLeave",
    "*",
    "if &filetype != 'dashboard' && &buftype != 'prompt' && &filetype != 'nofile' && &buftype != 'nofile' | set relativenumber | endif"
  },
  { "BufLeave,FocusLost,InsertEnter", "*", "set norelativenumber" }
}

if Opts.highlight_yank == true or Opts.highlight_yank ~= nil then
  autocmds.HighlightYank = {
    {
      "TextYankPost",
      "*",
      "silent! lua vim.highlight.on_yank { higroup = 'IncSearch', timeout=400 }"
    }
  }
end

if Opts.preserve_cursor == true or Opts.preserve_cursor == nil then
  autocmds.PreserveCursor = { { "BufReadPost", "*", "lua goto_last_pos()" } }
end

-- " Return to last edit position when opening files (You want this!)
-- au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

if Formatting.trim_trailing_space == true or Formatting.trim_trailing_space == nil then
  autocmds.TrimSpaces = {
    -- { "BufWritePre", "*", [[%s/\s\+$//e]] },
    -- { "BufWritePre", "*", [[%s/\n\+\%$//e]] }
    -- {"BufWritePre", "*.[ch]", [[*.[ch] %s/\%$/\r/e]]}
  }
end

require("utils.core").define_augroups(autocmds)
