local buffers = require("autocommands.buffers")
local telescope = require("autocommands.telescope")
local windows = require("autocommands.windows")

require("autocommands.misc")
require("autocommands.tagstack")
require("autocommands.events")
require("autocommands.skeletons")
require("autocommands.startup")

vim.cmd([[
  au BufNewFile,BufRead *.atj setlocal ft=javascript
  au BufNewFile,BufRead *.rjs setlocal ft=javascript
  " au BufNewFile,BufRead *.xml setlocal ft=javascript
  au BufNewFile,BufRead *.html setlocal indentexpr=JavascriptIndent()
  au BufNewFile,BufRead *.tcf setlocal ft=tcf
  au BufNewFile,BufRead *.tca setlocal ft=tcf
  au BufNewFile,BufRead *.tso setlocal ft=tcf

  au FileType checkhealth :set ft=checkhealth.log

	" :au SpellFileMissing * call Download_spell_file(expand('<amatch>'))

]])

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*",
  group = augroup("FileDetect", {}),
  desc = "Detect filetype on files with no extension after saving the file",
  callback = function()
    if vim.bo.filetype == "" then
      vim.cmd("filetype detect")
    end
  end,
})
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
    -- { { 'FileType' },              "pandoc",              "setlocal syn=pandoc" },
    { { 'FileType' },              "markdown",            "setlocal syn=markdown" },
    { { 'FileType' },               "fzf",                "tunmap <Esc><Esc>" },
    { {'FileType' },                'checkhealth',        'setlocal ft=help', },
    { { 'BufNewFile', 'BufRead' }, 'health:*',            'setlocal ft=log', },
    { { 'BufNewFile', 'BufRead' }, '*nvim/option-window', 'nnoremap <buffer><silent> q :q<cr> | nnoremap <buffer><silent>  :q<cr>', },
    { { 'BufNewFile', 'BufRead' }, '*.jq',                'set ft=jq' },
    { { 'BufNewFile', 'BufRead' }, '*startuptime.tsv',    'setlocal ft=crontab syn=crontab' },
    { { 'BufNewFile', 'BufRead' }, '*.ejs',               'set ft=html' },
    { { 'BufNewFile', 'BufRead' }, '*.rasi',              'set syn=css.rasi' },
    { { 'BufNewFile', 'BufRead' }, '*.bash*',             'let b:is_bash = 1 | setfiletype bash' },
    { { 'BufNewFile', 'BufRead' }, '*.theme',             'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, '*.rc',                'setlocal ft=rc syn=rc' },
    -- { { 'BufNewFile', 'BufRead' }, '.env.*',              'setlocal ft=bash syn=bash' },
    -- { { 'BufNewFile', 'BufRead' }, '*.env',               'setlocal ft=config syn=config' },
    { { 'BufNewFile', 'BufRead' }, 'conf.*',              'setlocal ft=config syn=config' },
    -- TODO: bring back toggler between indented lines (pandoc vs markdown)
    -- { { 'BufNewFile', 'BufRead' }, '*.md',                'setlocal ft=markdown syn=pandoc' },
    { { 'BufNewFile', 'BufRead' }, '.vimtasks',           'setlocal ft=asynctasks' },
    { { 'BufNewFile', 'BufRead' }, '*.cheat',             'setlocal ft=bash | let b:is_bash =1' },
    { { 'BufNewFile', 'BufRead' }, 'Dockerfile*',         'setlocal ft=Dockerfile' },
    { { 'BufNewFile', 'BufRead' }, 'Dockerfile.*',        'setlocal ft=Dockerfile' },
    { { 'BufNewFile', 'BufRead' }, '.dockerignore',       'setlocal ft=gitignore' },
    { { 'BufNewFile', 'BufRead' }, '*/nord-nick/main.lua','setlocal syn=lua | let b:disable_lsp=1' },
    { { 'BufNewFile', 'BufRead' }, 'nord-nvim.lua',       'setlocal syn=lua | let b:disable_lsp=1' },
    { { 'BufNewFile', 'BufRead' }, '*.t',                 'setlocal ft=tangle' },
    { { 'BufNewFile', 'BufRead' }, 'git',                 'nnoremap <buffer><silent> q :q<cr> | nnoremap <buffer>  :q<cr>' },
    { { 'BufNewFile', 'BufRead' }, 'grc/conf.*',          'setlocal ft=config' },
    -- { { 'BufNewFile', 'BufRead' }, '*.*rc',               'setlocal ft=log' },
    { { 'BufNewFile', 'BufRead' }, '*.log',                    'setlocal ft=log'              },
    { { 'BufNewFile', 'BufRead' }, '*.conf',                   'setlocal ft=conf.dosini'      },
    { { 'BufNewFile', 'BufRead' }, '*.pa',                     'setlocal ft=conf'             },
    { { 'BufNewFile', 'BufRead' }, '*.scm',                    'setlocal ft=query.treesitter' },
    { { 'BufNewFile', 'BufRead' }, '*.service',                'setlocal ft=systemd'          },
    { { 'BufNewFile', 'BufRead' }, '*.openvpn',                'setlocal ft=openvpn'          },
    { { 'BufNewFile', 'BufRead' }, '*.org',                    'setlocal syn=org'          },
    { { 'BufNewFile', 'BufRead' }, '*.sock',                   'setlocal ft=systemd'          },
    { { 'BufNewFile', 'BufRead' }, 'Chart.yaml',               'setlocal ft=helm'             },
    { { 'BufNewFile', 'BufRead' }, 'values.yaml',              'setlocal ft=helm'             },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.yaml',       'setlocal ft=helm'             },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.tpl',        'setlocal ft=helm'             },
    { { 'BufNewFile', 'BufRead' }, '*/templates/*.txt',        'setlocal ft=helm'             },
    { { 'BufNewFile', 'BufRead' }, '*/ansible/*.yml',          'setlocal ft=yaml.ansible'     },
    { { 'BufNewFile', 'BufRead' }, '*/ansible/*.yaml',         'setlocal ft=yaml.ansible'     },
    { { 'BufNewFile', 'BufRead' }, '*/nvim/runtime/doc/*.txt', 'setlocal ft=help'             },
    { { 'BufNewFile', 'BufRead' }, '*/nvim/lazy/**/doc/*.txt', 'setlocal ft=help'             },
    { { 'BufNewFile', 'BufRead' }, '*/nvim-luaref/doc/*',      'setlocal ft=help'             },
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
    -- { 'TermOpen', '*', [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
    { "TermOpen", "*", "set nonumber norelativenumber" },
    { "TermLeave", "*", "set number relativenumber"}
  },
  Redraw = {
    { "CompleteChanged", "*", "redraw" },
  },
  -- LineNumbers     = { { 'BufEnter', 'BufLeave', 'FocusGained', 'FocusLost'  }, '*', windows.line_numbers },
  BuffersSpecial  = { { 'BufNew', 'BufReadPost' }, '*', windows.handle_special },
  FasdUpdate      = { { 'BufWritePost' }, '*',  buffers.fasd_update },
  -- RestoreCursor   = { { 'BufRead' },      '*',  windows.restore_cursor },
  -- HighlightYank   = { { 'TextYankPost' }, '*',  windows.highlight_yank },
  TelescopeWinbar = { { 'User' }, 'TelescopeFindPre', telescope.winbar_sync },
  ReloadOnWrite   = { { 'BufWritePost' }, 'tmux.conf', [[execute ':!tmux source-file % && notify-send "TMUX" "Reloading TMUX"']] } ,

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

create_augroups(autocmds)
