-- local commands = require('autocommands.commands')
local buffers = require("autocommands.buffers")
local windows = require("autocommands.windows")
local telescope = require("autocommands.telescope")

require("autocommands.misc")
require("autocommands.tagstack")
require("autocommands.events")
require("autocommands.skeletons")
require("autocommands.startup")

-- stylua: ignore start

-- function handlers
local handlers = {
  -- HighlightSearchOn = buffers.hlsearch_on(),
  -- HighlightSearchOff = buffers.hlsearch_off(),
}

-- TODO: automatically build helptags in doc directory

local autocmds = {
  CursorLine = { { 'BufEnter'}, 'NvimTree', 'setlocal cursorline' },
  CommandWin = {
    { { 'CmdwinEnter' }, '*', 'setlocal nonumber norelativenumber signcolumn=no syn=vim.lua | startinsert' },
    { { 'CmdwinEnter' }, '*', 'let b:cpt_save = &cpt | set cpt=.' },
    { { 'CmdwinEnter' }, '*', 'nnoremap <silent><buffer> <esc> <C-c><C-c>' },
    { { 'CmdwinLeave' }, '*', 'let &cpt = b:cpt_save | let g:lens#disabled = 1' },
  },
  FiletypeDetect = {
    -- { 'FileType', 'query',                 'setlocal nonumber norelativenumber' },
    -- { 'FileType', 'code-action-menu-menu', 'set sidescrolloff=0 nocursorline' },
    { { 'FileType' },              "neoai-output",        "setlocal conceallevel=3 synmaxcol=1000" },
    { { 'FileType' },              "pandoc",              "setlocal syn=pandoc" },
    { { 'FileType' },              "markdown",            "setlocal syn=markdown" },
    { { 'BufNewFile', 'BufRead' }, '*nvim/option-window', 'nnoremap <buffer><silent> q :q<cr> | nnoremap <buffer><silent>  :q<cr>', },
    { { 'BufNewFile', 'BufRead' }, '*startuptime.tsv',    'setlocal ft=crontab syn=crontab' },
    { { 'BufNewFile', 'BufRead' }, '*.ejs',               'set ft=html' },
    { { 'BufNewFile', 'BufRead' }, '*.rasi',              'set syn=css.rasi' },
    { { 'BufNewFile', 'BufRead' }, '*.bash*',             'let b:is_bash = 1 | setfiletype bash' },
    { { 'BufNewFile', 'BufRead' }, '*.theme',             'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '*.rc',                'setlocal ft=rc syn=rc' },
    { { 'BufNewFile', 'BufRead' }, '.env.*',              'setlocal ft=bash syn=bash' },
    { { 'BufNewFile', 'BufRead' }, '*.env',               'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, 'conf.*',              'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '*.md',                'setlocal ft=markdown syn=pandoc' },
    { { 'BufNewFile', 'BufRead' }, '*.visidatarc',        'setlocal ft=python' },
    { { 'BufNewFile', 'BufRead' }, '.vimtasks',           'setlocal ft=asynctasks' },
    { { 'BufNewFile', 'BufRead' }, '*.cheat',             'setlocal ft=bash | let b:is_bash =1' },
    { { 'BufNewFile', 'BufRead' }, 'Dockerfile*',         'setlocal ft=Dockerfile' },
    { { 'BufNewFile', 'BufRead' }, 'Dockerfile.*',        'setlocal ft=Dockerfile' },
    { { 'BufNewFile', 'BufRead' }, '.dockerignore',       'setlocal ft=gitignore' },
    { { 'BufNewFile', 'BufRead' }, '*/nord-nick/main.lua','setlocal syn=lua | let b:disable_lsp=1' },
    { { 'BufNewFile', 'BufRead' }, 'nord-nvim.lua',       'setlocal syn=lua | let b:disable_lsp=1' },
    { { 'BufNewFile', 'BufRead' }, '*.t',                 'setlocal ft=tangle' },
    { { 'BufNewFile', 'BufRead' }, 'git',                 'nnoremap <buffer><silent> q :q<cr> | nnoremap <buffer>  :q<cr>' },
    -- { { 'BufNewFile', 'BufRead' }, '*.*rc',               'setlocal ft=log' },
    { { 'BufNewFile', 'BufRead' }, '*.log',               'setlocal ft=log' },
    { { 'BufNewFile', 'BufRead' }, '*.conf',              'setlocal ft=conf.dosini' },
    { { 'BufNewFile', 'BufRead' }, '*.pa',                'setlocal ft=conf' },
    { { 'BufNewFile', 'BufRead' }, '*.scm',               'setlocal ft=query.treesitter' },
    { { 'BufNewFile', 'BufRead' }, '*.service',           'setlocal ft=systemd' },
    { { 'BufNewFile', 'BufRead' }, '*.sock',              'setlocal ft=systemd' },
    { { 'BufNewFile', 'BufRead' }, 'Chart.yaml',          'setlocal ft=helm' },
    { { 'BufNewFile', 'BufRead' }, 'values.yaml',         'setlocal ft=helm' },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.yaml',  'setlocal ft=helm' },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.tpl',   'setlocal ft=helm' },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.txt',   'setlocal ft=helm' },
    { { 'BufNewFile', 'BufRead' }, '*/ansible/*.yml',     'setlocal ft=yaml.ansible' },
    { { 'BufNewFile', 'BufRead' }, '*/ansible/*.yaml',    'setlocal ft=yaml.ansible' },
    { { 'BufNewFile', 'BufRead' }, '*/nvim/runtime/doc/*.txt', 'set ft=help' },
    { { 'BufNewFile', 'BufRead' }, '*/nvim-luaref/doc/*',      'set ft=help' },
    { { 'BufNewFile', 'BufRead', 'BufEnter'}, 'dbee-*.*', 'setlocal ft=tablegen' },
    -- u BufRead *.yaml,*.yml if search('hosts:\|tasks:', 'nw') | set ft=yaml.ansible | endif
      -- { "BufNewFile,BufRead", "*.md", "setlocal ft=markdown.pandoc conceallevel=2 synmaxcol=500" },
      --   au BufNewFile,BufRead .pa set ft=config
      --   au BufNewFile,BufRead */ansible/*.yml  set ft=yaml.ansible
      --   au BufNewFile,BufRead *.j2,*/ansible/*/templates/* set ft=config.jinja2
      --   au BufNewFile,BufRead bundles.txt setlocal ft=sh
      --   au BufNewFile,BufRead bundles.*.txt setlocal ft=sh
      --   " au BufEnter * if &bufhidden =~ 'wipe' && &buftype =~ 'nofile' | setf preview | endif
  },
  Terminal = {
    { 'TermOpen', '*', [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
    { "TermOpen", "*", "set nonumber norelativenumber" },
    { "TermLeave", "*", "set number relativenumber"}
  },
  Redraw = {
    { "CompleteChanged", "*", "redraw" },
  },
  CursorShape = {
    { 'FocusLost',               '*', 'hi TermCursor cterm=NONE gui=NONE'    },
    { 'FocusGained',             '*', 'hi TermCursor cterm=reverse gui=reverse' },
    -- { {'InsertEnter' }, '         *', 'set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20' },
    -- { {'VimLeave','VimSuspend'}, '*', 'set guicursor=a:block-blinkon90' },
  },
  LineNumbers     = { { 'BufEnter', 'FocusGained', 'FocusLost'  }, '*', windows.line_numbers },
  BuffersSpecial  = { { 'BufNew', 'BufReadPost' }, '*', windows.handle_special },
  FasdUpdate      = { { 'BufWritePost' }, '*',  buffers.fasd_update },
  RestoreCursor   = { { 'BufRead' },      '*',  windows.restore_cursor },
  HighlightYank   = { { 'TextYankPost' }, '*',  windows.highlight_yank },
  TelescopeWinbar = { { 'User' }, 'TelescopeFindPre', telescope.winbar_sync },
  ReloadOnWrite   = { { 'BufWritePost' }, 'tmux.conf', [[execute ':!tmux source-file %']] } ,

  -- { 'BufWinLeave', '*', remove_buffer },
  -- TrailingWhitespace =  {
  --   { 'BufWritePre', '*', windows.remove_trailing_whitespace },
  --   { 'InsertEnter', '*', windows.enable_list },
  --   { 'InsertLeave', '*', windows.disable_list },
  -- }
}

-- autocommands
local create_augroups = function(definitions) -- {{{1
  local created = {}
  for group_name, definition in pairs(definitions) do

    vim.api.nvim_create_augroup(group_name, { clear = true })
    definition = type(definition) == 'table' and #definition > 2 and  type(definition[2]) ~= 'table' and { definition } or definition
    created[group_name] = 0

    for _, def in ipairs(definition) do
      local opts = { group = group_name, pattern = def[2], desc = def[4] or '' }
      if type(def[3]) == 'string' then
        opts.command = def[3]
      else
        opts.callback = def[3]
      end
      vim.api.nvim_create_autocmd(def[1],opts)
      created[group_name] = created[group_name] + 1
    end
  end
end

if false  then
  autocmds.Vimade = {
    { 'FileType', 'cmp_menu',          'VimadeBufDisable' },
    { 'FileType', 'dap-log',           'VimadeBufDisable' },
    { 'FileType', 'dap-repl',          'VimadeBufDisable' },
    { 'FileType', 'dapui_console',     'VimadeBufDisable' },
    { 'FileType', 'dapui_stacks',      'VimadeBufDisable' },
    { 'FileType', 'dapui_breakpoints', 'VimadeBufDisable' },
    { 'FileType', 'dapui_scopes',      'VimadeBufDisable' },
    { 'FileType', 'dapui_watches',     'VimadeBufDisable' },
    { 'FileType', 'CompetiTest',       'VimadeBufDisable' },
    { 'FileType', 'SidebarNvim',       'VimadeBufDisable' },
    { 'FileType', 'Trouble',           'VimadeBufDisable' },
    { 'FileType', 'aerial',            'VimadeBufDisable' },
    { 'FileType', 'tablegen',          'VimadeBufDisable' },
    { 'FileType', 'nerdtree',          'VimadeBufDisable' },
    { 'FileType', 'neo-tree',          'VimadeBufDisable' },
    { 'FileType', 'noice',             'VimadeBufDisable' },
    { 'FileType', 'Mundo',             'VimadeBufDisable' },
    { 'FileType', 'NvimTree',          'VimadeBufDisable' },
    { 'FileType', 'MundoDiff',         'VimadeBufDisable' },
    -- { 'FileType', 'qf',                'VimadeBufDisable' },
    -- { 'FileType', 'query.treesitter', 'VimadeBufDisable' },
    -- { "FileType", "noice", "VimadeUnfadeActive" },
    -- { "FocusLost", "*", "VimadeFadeActive" },
    -- { "FocusGained", "*", "VimadeUnfadeActive" },
    -- { "BufLeave,FocusLost", "*", M.vimadeCheck() },
  }
end


create_augroups(autocmds)
