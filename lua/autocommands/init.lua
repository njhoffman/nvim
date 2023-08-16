local commands = require('autocommands.commands')
require('autocommands.misc')
require('autocommands.startup')
require('autocommands.lsp')

-- TODO: automatically build helptags in doc directory

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
    -- { {'WinEnter' }, '*', 'stopinsert' },
    { 'BufEnter', 'NvimTree', 'setlocal cursorline' },
    -- { "InsertLeave", '*',

    -- function(event)
    --   if vim.bo.ft == 'TelescopePrompt' and vim.fn.mode() == 'n' then
    --     vim.cmd('startinsert!')
    --     vim.dbglog("STARTNSERT")
    --     -- vim.schedule_wrap(function()
    --     --   vim.cmd('startinsert')
    --     -- end)
    --   -- elseif vim.bo.ft == "lua" and vim.fn.mode() == 'i' then
    --   --   vim.dbglog("STOPINSERT")
    --   --   vim.cmd('stopinsert')
    --   --   -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    --   --   -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    --   end
    --   vim.dbglog(vim.bo.ft, vim.fn.mode(), vim.fn.getftype(vim.fn.bufname(0)))
    -- end
  --   },
  },
  fasd = { { 'BufRead', '*', commands.fasd_update } },
  CommandWin = {
    { 'CmdwinEnter', '*', 'setlocal nonumber norelativenumber signcolumn=no syn=vim.lua | startinsert ' },
    { 'CmdwinEnter', '*', 'let b:cpt_save = &cpt | set cpt=.' },
    { 'CmdwinEnter', '*', 'nnoremap <silent><buffer> <esc> <C-c><C-c>' },
    { 'CmdwinLeave', '*', 'let &cpt = b:cpt_save | let g:lens#disabled = 1' },
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
    { { 'BufNewFile', 'BufRead' }, '.*rc',               'setlocal ft=rc syn=rc' },
    { { 'BufNewFile', 'BufRead' }, '.env.*',             'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '*.env',              'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, 'conf.*',             'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '*.md',               'setlocal syntax=pandoc | setlocal conceallevel=3 synmaxcol=500' },
    { { 'BufNewFile', 'BufRead' }, '.tasks',             'setlocal ft=asynctasks' },
    { { 'BufNewFile', 'BufRead' }, '*.visidatarc',       'setlocal ft=python' },
    { { 'BufNewFile', 'BufRead' }, '.vimtasks',          'setlocal ft=asynctasks' },
    { { 'BufNewFile', 'BufRead' }, '*.cheat',            'setlocal ft=bash | let b:is_bash =1' },
    { { 'BufNewFile', 'BufRead' }, 'Dockerfile*',        'setlocal ft=Dockerfile' },
    { { 'BufNewFile', 'BufRead' }, 'Dockerfile.*',       'setlocal ft=Dockerfile' },
    { { 'BufNewFile', 'BufRead' }, '.dockerignore',      'setlocal ft=gitignore' },
    { { 'BufNewFile', 'BufRead' }, '*/nord-nick/main.lua', 'setlocal syn=lua | let b:disable_lsp=1' },
    { { 'BufNewFile', 'BufRead' }, 'nord-nvim.lua',      'setlocal syn=lua | let b:disable_lsp=1' },
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
    { { 'BufNewFile', 'BufRead' }, '*/ansible/*.yml',    'set ft=yaml.ansible' },
    { { 'BufNewFile', 'BufRead' }, '*/ansible/*.yaml',   'set ft=yaml.ansible' },
  --   {"FileType", "markdown.pandoc", "hi! markdownH1 guifg=#45a5f8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH2 guifg=#45a5e8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH3 guifg=#45a5d8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH4 guifg=#45a5c8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH5 guifg=#45a5b8"},
  --   {"FileType", "markdown.pandoc", "hi! markdownH6 guifg=#45a5a8"},
-- u BufRead *.yaml,*.yml if search('hosts:\|tasks:', 'nw') | set ft=yaml.ansible | endif
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
    { 'FocusLost',               '*', 'hi TermCursor cterm=NONE gui=NONE'    },
    { 'FocusGained',             '*', 'hi TermCursor cterm=reverse gui=reverse' },
    { {'InsertEnter' }, '         *', 'set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20' },
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
  {
    { 'BufEnter', 'FocusGained', 'InsertLeave' },
    '*',
    "if &readonly != 1 && &buftype != 'prompt' && &filetype != 'nofile' && &buftype != 'nofile' | set relativenumber | endif",
  },
  { { 'BufLeave', 'FocusLost', 'InsertEnter' }, '*', 'set norelativenumber' },
}

autocmds.HighlightYank = {
  { 'TextYankPost', '*', "silent! lua vim.highlight.on_yank { higroup = 'IncSearch', timeout=300 }" },
}
autocmds.PreserveCursor = { { 'BufReadPost', '*', commands.goto_last_pos } }

define_augroups(autocmds)
