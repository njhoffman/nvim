local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo
local opt = require('utils.core').opt
local config = require('config')

g.mapleader = [[,]]
g.maplocalleader = [[,]]

local buffer = { o, bo }
local window = { o, wo }

-- global scope
-- opt("backupdir", ".,~/.vim/backup,~/.local/share/nvim/backup")
opt('autoread', true)
opt('autowrite', false)
opt('backspace', 'eol,start,indent') -- Configure backspace so it acts as it should act
opt('backup', false)
opt('backupcopy', 'auto')
opt('breakindent', true)
opt('breakindentopt', 'shift:2')
opt('cedit', '<C-t>') -- ctrl-f interferes with popup completion
opt('clipboard', 'unnamedplus')
opt('cmdheight', 0) -- 0
opt('cmdwinheight', 10)
opt('completeopt', 'menu,menuone,noselect')
opt('confirm', true)
opt('cpoptions', 'aABceFs_r') -- C causes certain vim programs to screw up, x makes command execute even if exiting
opt('encoding', 'UTF-8')
opt('fileencoding', 'utf-8')
opt('fillchars', 'eob: ') -- Don't show `~` outside of buffer
opt('foldmethod', 'manual')
-- opt('formatoptions', 'jcroqlnt') -- (qjl1) Don't autoformat comments
opt('grepformat', '%f:%l:%c:%m')
opt('grepprg', 'rg --vimgrep')
opt('helpheight', 25)
opt('hidden', true)
opt('hlsearch', true)
opt('ignorecase', true)
opt('inccommand', 'split')
opt('incsearch', true)
opt('joinspaces', false)
opt('jumpoptions', 'stack')
opt('laststatus', 3)
opt('lazyredraw', false)
opt('linebreak', true)
opt('magic', true)
opt('matchtime', 3) -- How many tenths of a second to blink when matching brackets
opt('modelines', 5)
opt('mouse', 'nivh')
opt('omnifunc', '')
opt('previewheight', 15)
opt('pumblend', 10)
opt('pumheight', 10)
opt('regexpengine', 0)
opt('redrawtime', 10000)
opt('scrolloff', 7)
opt('sessionoptions', 'buffers,curdir,folds,help,resize,winpos,terminal') -- winsize messes up on load
opt('shada', "!,'200,<100,s500")
opt('shortmess', 'tTIscCaF') -- F silents filename, C?
opt('showbreak', '↳ ')
opt('showcmd', true)
opt('showmatch', true) -- Show matching brackets when text indicator is over them
opt('showmode', false)
opt('showtabline', 1)
opt('sidescrolloff', 5)
opt('smartcase', true)
opt('splitbelow', true)
opt('splitkeep', 'screen') -- scroll behavior for horizontal splits
opt('splitright', true)
opt('swapfile', false)
opt('switchbuf', 'useopen,usetab') -- Use the current tab for openning files from quickfix.
opt('termguicolors', true)
opt('timeout', true)
opt('timeoutlen', 500) -- 1000
opt('ttimeoutlen', 30) -- 50
opt('undolevels', 1000)
opt('updatetime', 1500) -- 4000
opt('virtualedit', 'onemore') -- 4000
opt('whichwrap', 'b,s,<,>,[,],h,l')
opt('wildignore', '*.o,*~,*.pyc') -- wildchar/charm for wildmenu  0x1a ^Z, 0x1b ^[, 0x0e C-n
opt('wildmode', 'longest:full,full')
-- opt('winminwidth', 1) -- vimade errors when this is larger
opt('writebackup', true)
-- opt("display", "msgsep")
-- opt("shortmess", o.shortmess .. "cS")
-- -- opt("shortmess", "filnxtToOcSIs")
-- opt("more", false) -- dont pause when message finished
-- opt("wildmenu", 1)
-- opt("wildmode", "longest:full,full")
-- opt("wildmode", "") -- full, longest, list, lastused, list:longest, list:full, longest:full
-- opt("wc", 0x0e)
-- opt("wcm", 0x0e)

-- opt('list', true) -- Define which helper symbols to show
-- opt('listchars', 'extends:…,precedes:…,nbsp:␣') -- Define which helper symbols to show

-- window scope
opt('concealcursor', 'nc', window)
opt('conceallevel', 2, window)
opt('cursorline', true, window)
opt('number', true, window)
opt('relativenumber', true, window)
opt('signcolumn', 'yes:1', window)
opt('spell', false, window)
opt('wrap', false, window)

-- buffer scope
opt('expandtab', true, buffer)
opt('fileformat', 'unix', buffer)
opt('modeline', true, buffer)
opt('shiftwidth', 2, buffer)
opt('smartindent', false, buffer)
opt('softtabstop', 0, buffer)
opt('synmaxcol', 2000, buffer)
opt('tabstop', 2, buffer)
opt('undofile', true, buffer)

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Enable syntax highlighing if it wasn't already (as it is time consuming)
if vim.fn.exists('syntax_on') ~= 1 then
  vim.cmd([[syntax enable]])
end

vim.cmd([[
  " curl -sS https://raw.githubusercontent.com/neovim/neovim/v0.7.2/runtime/syntax/lua.vim > $VIMRUNTIME/syntax/lua.vim
  augroup MyLuaHLBugFix
    autocmd!
    autocmd! ColorScheme,VimEnter * highlight! link luaParenError Normal | highlight! link luaError Normal | highlight! link @error Normal
  augroup END
  " autocmd BufEnter * syntax sync minlines=4000
  " syn sync fromstart
]])

-- -- Add empty lines before and after cursor line supporting dot-repeat
--  MiniBasics.put_empty_line = function(put_above)
--    -- This has a typical workflow for enabling dot-repeat:
--    -- - On first call it sets `operatorfunc`, caches data, and calls
--    --   `operatorfunc` on current cursor position.
--    -- - On second call it performs task: puts `v:count1` empty lines
--    --   above/below current line.
--    if type(put_above) == 'boolean' then
--      vim.o.operatorfunc = 'v:lua.MiniBasics.put_empty_line'
--      MiniBasics.cache_empty_line = { put_above = put_above }
--      return 'g@l'
--    end
--
--    local target_line = vim.fn.line('.') - (MiniBasics.cache_empty_line.put_above and 1 or 0)
--    vim.fn.append(target_line, vim.fn['repeat']({ '' }, vim.v.count1))
--  end
--
--  -- NOTE: if you don't want to support dot-repeat, use this snippet:
--  -- ```
--  -- map('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
--  -- map('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")
--  -- ```
--  map('n', 'gO', 'v:lua.MiniBasics.put_empty_line(v:true)',  { desc = 'Put empty line above', expr = true })
--  map('n', 'go', 'v:lua.MiniBasics.put_empty_line(v:false)', { desc = 'Put empty line below', expr = true })
--
--  -- Copy/paste with system clipboard
--  map({ 'n', 'x' }, 'gy', '"+y', { desc = 'Copy to system clipboard' })
--  map(  'n',        'gp', '"+p', { desc = 'Paste from system clipboard' })
--  -- - Paste in Visual with `P` to not copy selected text (`:h v_P`)
--  map(  'x',        'gp', '"+P', { desc = 'Paste from system clipboard' })
--
--  -- Reselect latest changed, put, or yanked text
vim.api.nvim_set_keymap(
  'n',
  'gV',
  '"`[" . strpart(getregtype(), 0, 1) . "`]"',
  { expr = true, desc = 'Visually select changed text' }
)
--
--  -- Search inside visually highlighted text. Use `silent = false` for it to
--  -- make effect immediately.
--  map('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })
--
--  -- Search visually selected text (slightly better than builtins in Neovim>=0.8)
--  map('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
--  map('x', '#', [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])
