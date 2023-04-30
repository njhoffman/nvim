local commands = require('autocommands.commands')
require('autocommands.misc')
require('autocommands.startup')

local function define_augroups(definitions) -- {{{1
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_create_augroup(group_name, { clear = true })
    for _, def in pairs(definition) do
      local cb = def[3]
      if type(cb) == 'string' then
        cb = function()
          vim.cmd(def[3])
        end
      end
      vim.api.nvim_create_autocmd(def[1], {
        pattern = def[2],
        callback = cb,
        desc = def[4] or '',
      })
    end
  end
end

-- stylua: ignore
local autocmds = {
  wins = {
    { 'BufEnter',              'NvimTree',   'setlocal cursorline' },
    { {'BufEnter', 'WinEnter' }, '*', 'stopinsert' },
    -- Equalize window dimensions when resizing vim window
    -- Force write shada on leaving nvim
    -- { 'VimLeave', '*', [[if has('nvim') | wshada! | else | wviminfo! | endif]] },
    -- Check if file changed when its window is focus, more eager than 'autoread'
  },
  fasd = { { 'BufRead', '*', commands.fasd_update } },
  CommandWin = {
    { 'CmdwinEnter', '*', 'let b:cpt_save = &cpt | set cpt=.' },
    { 'CmdwinLeave', '*', 'let &cpt = b:cpt_save | let g:lens#disabled = 1' },
    { 'CmdwinEnter', '*', 'nnoremap <silent><buffer> <esc> <C-c><C-c>' },
    { 'CmdwinEnter', '*', 'setlocal nonumber norelativenumber signcolumn=no syn=vim | startinsert' },
  },

  FiletypeDetect = {
    { 'FileType', 'qf', 'setlocal nonumber norelativenumber' },
    { 'FileType', 'code-action-menu-menu', 'set sidescrolloff=0 nocursorline' },
    { {'BufNewFile', 'BufRead'}, '*nvim/option-window', 'nnoremap <buffer><silent> q :q<cr> | nnoremap <buffer><silent>  :q<cr>', },
    { { 'BufNewFile', 'BufRead' }, '*startuptime.tsv',   'setlocal ft=crontab syn=crontab' },
    -- { { 'BufNewFile', 'BufRead' }, '*.log',              "lua require('commands.format').create_cmd_truncate()" },
    { { 'BufNewFile', 'BufRead' }, '*.ejs',              'set ft=html' },
    { { 'BufNewFile', 'BufRead' }, '*.rasi',             'set syn=css.rasi' },
    { { 'BufNewFile', 'BufRead' }, '*.bash*',            'let b:is_bash = 1 | setfiletype bash' },
    { { 'BufNewFile', 'BufRead' }, '*.theme',            'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '.*rc',               'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '.env.*',             'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '*.env',              'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, 'conf.*',             'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '*.md',               'setlocal ft=vimwiki.pandoc.markdown conceallevel=3 synmaxcol=500' },
    { { 'BufNewFile', 'BufRead' }, '.tasks',             'setlocal ft=asynctasks' },
    { { 'BufNewFile', 'BufRead' }, '*.visidatarc',       'setlocal ft=python' },
    { { 'BufNewFile', 'BufRead' }, '.vimtasks',          'setlocal ft=asynctasks' },
    { { 'BufNewFile', 'BufRead' }, '*.cheat',            'setlocal ft=bash | let b:is_bash =1' },
    { { 'BufNewFile', 'BufRead' }, 'Dockerfile*',        'setlocal ft=Dockerfile' },
    { { 'BufNewFile', 'BufRead' }, 'Dockerfile.*',       'setlocal ft=Dockerfile' },
    { { 'BufNewFile', 'BufRead' }, '.dockerignore',      'setlocal ft=gitignore' },
    { { 'BufNewFile', 'BufRead' }, '*/nord-nick/main.lua', 'setlocal ft=lush syn=lua' },
    { { 'BufNewFile', 'BufRead' }, 'nord-nvim.lua',      'setlocal ft=lush syn=lua' },
    { { 'BufNewFile', 'BufRead' }, '*.t',                'setlocal ft=tangle' },
    { { 'BufNewFile', 'BufRead' }, 'git',                'nnoremap <buffer><silent> q :q<cr> | nnoremap <buffer>  :q<cr>' },
    { { 'BufNewFile', 'BufRead' }, '*.conf',             'setlocal ft=conf.dosini' },
    { { 'BufNewFile', 'BufRead' }, '*.pa',               'setlocal ft=conf' },
    { { 'BufNewFile', 'BufRead' }, '*.service',          'setlocal ft=systemd' },
    { { 'BufNewFile', 'BufRead' }, '*.sock',             'setlocal ft=systemd' },
    { { 'BufNewFile', 'BufRead' }, '*.sock',             'setlocal ft=systemd' },
    { { 'BufNewFile', 'BufRead' }, 'Chart.yaml',         'set ft=helm' },
    { { 'BufNewFile', 'BufRead' }, 'values.yaml',        'set ft=helm' },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.yaml', 'set ft=helm' },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.tpl',  'set ft=helm' },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.txt',  'set ft=helm' },
  --   {"FileType", "markdown.pandoc", "hi! markdownH1 guifg=#45a5f8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH2 guifg=#45a5e8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH3 guifg=#45a5d8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH4 guifg=#45a5c8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH5 guifg=#45a5b8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH6 guifg=#45a5a8"},
    -- { "BufNewFile,BufRead", "*.md", "setlocal ft=markdown.pandoc conceallevel=2 synmaxcol=500" },
    --   au BufNewFile,BufRead .pa set ft=config
    --   au BufNewFile,BufRead */ansible/*.yml  set ft=yaml.ansible
    --   au BufNewFile,BufRead *.j2,*/ansible/*/templates/* set ft=config.jinja2
    --   au BufNewFile,BufRead bundles.txt setlocal ft=sh
    --   au BufNewFile,BufRead bundles.*.txt setlocal ft=sh
    --   " au BufEnter * if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' | setf preview | endif
  },
  VimadeDap = {
    { 'FileType', 'dap-log', 'VimadeBufDisable' },
    { 'FileType', 'dap-repl', 'VimadeBufDisable' },
    { 'FileType', 'dapui_console', 'VimadeBufDisable' },
    { 'FileType', 'dapui_stacks', 'VimadeBufDisable' },
    { 'FileType', 'dapui_breakpoints', 'VimadeBufDisable' },
    { 'FileType', 'dapui_scopes', 'VimadeBufDisable' },
    { 'FileType', 'dapui_watches', 'VimadeBufDisable' },
  },
  Vimade = {
    { 'FileType', 'CompetiTest', 'VimadeBufDisable' },
    -- { "FileType", "noice", "VimadeUnfadeActive" },
    { 'FileType', 'SidebarNvim', 'VimadeBufDisable' },
    { 'FileType', 'Trouble', 'VimadeBufDisable' },
    { 'FileType', 'aerial', 'VimadeBufDisable' },
    { 'FileType', 'qf', 'VimadeBufDisable' },
    { 'FileType', 'nerdtree', 'VimadeBufDisable' },
    { 'FileType', 'neo-tree', 'VimadeBufDisable' },
    { 'FileType', 'Mundo', 'VimadeBufDisable' },
    { 'FileType', 'NvimTree', 'VimadeBufDisable' },
    { 'FileType', 'MundoDiff', 'VimadeBufDisable' },
    -- { "CompleteChanged", "*", "redraw" },
    -- { "FocusLost", "*", "VimadeFadeActive" },
    -- { "FocusGained", "*", "VimadeUnfadeActive" },
    -- { "BufLeave,FocusLost", "*", M.vimadeCheck() },
  },
  Shape = {
    -- { 'FocusLost',               '*', 'hi TermCursor cterm=NONE gui=NONE'    },
    -- { 'FocusGained',             '*', 'hi TermCursor cterm=reverse gui=reverse' },
    { {'VimLeave','VimSuspend'}, '*', 'set guicursor=a:block-blinkon90' },
  },
  terminal = {
    { 'TermOpen', '*', [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
    {"TermOpen", "*", "set nonumber norelativenumber"},
    {"TermLeave", "*", "set number relativenumber"}
  },
  WriteEvents = {
    { 'BufWritePost', '*tmux.conf', [[execute ':!tmux source-file %']] },
  },
}
autocmds.NumberToggle = {
  { { 'BufEnter', 'FocusGained', 'InsertLeave' }, '*', "if &readonly != 1 && &buftype != 'prompt' && &filetype != 'nofile' && &buftype != 'nofile' | set relativenumber | endif" },
  { { 'BufLeave', 'FocusLost', 'InsertEnter' }, '*', 'set norelativenumber' },
}

autocmds.HighlightYank = {
  { 'TextYankPost', '*', "silent! lua vim.highlight.on_yank { higroup = 'IncSearch', timeout=300 }" },
}
autocmds.PreserveCursor = { { 'BufReadPost', '*', commands.goto_last_pos } }

define_augroups(autocmds)
