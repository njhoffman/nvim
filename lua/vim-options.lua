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
opt('cmdwinheight', 15)
opt('completeopt', 'menuone,noselect,preview') -- noselect, noinsert
opt('complete', '') -- no omnifunc, completefunc, tagfunc, etc
opt('confirm', true)
opt('cpoptions', 'aABceFs_r') -- C causes certain vim programs to screw up, x makes command execute even if exiting
opt('encoding', 'UTF-8')
opt('fileencoding', 'utf-8')
-- set redrawdebug to line and write delay to slow down macros/automated actions
-- :set rdb=line wd=100

-- opt('fillchars', 'eob: ') -- Don't show `~` outside of buffer
vim.opt.fillchars:append({
  eob = ' ',
  fold = ' ',
  vert = '║',
  horiz = '═',
})

opt('foldmethod', 'manual')
opt('foldlevel', 99)
-- opt('formatoptions', 'jcroqlnt') -- (qjl1) Don't autoformat comments
opt('grepformat', '%f:%l:%c:%m')
opt('grepprg', 'set grepprg=rg --vimgrep --no-heading --smart-case')
-- vim.o.grepprg =
--     "rg --smart-case --vimgrep --no-heading --follow --multiline-dotall --hidden --pcre2 --regexp" -- IMPORTANT: pipes should be escaped! e.g. `"text\.(Success\|Info)\("`
opt('helpheight', 25)
opt('hidden', true)
opt('hlsearch', true)
opt('ignorecase', true)
opt('inccommand', 'nosplit')
opt('incsearch', true)
opt('joinspaces', false)
opt('jumpoptions', 'stack') -- https://www.reddit.com/r/neovim/comments/16nead7/comment/k1e1nj5/?context=3
opt('laststatus', 3)
opt('lazyredraw', false)
opt('linebreak', true)
opt('magic', true)
opt('makeprg', 'make --silent --warn-undefined-variables')
opt('matchtime', 3) -- How many tenths of a second to blink when matching brackets
opt('modelines', 5)
opt('mouse', 'nivh')
opt('previewheight', 15)
opt('pumblend', 10)
opt('pumheight', 10)
opt('regexpengine', 0)
opt('redrawtime', 3000)

opt('selection', 'inclusive') -- old, exclusive, inclusive (default)
opt('virtualedit', 'none') -- onemore, block, insert, all, none

opt('sessionoptions', 'buffers,curdir,folds,help,resize,winpos,terminal') -- winsize messes up on load
opt('shada', "!,'1000,<100,s500")

-- F silents filename (but needed for bufread on vimenter), C? default: filnxtToOCF
opt('shortmess', 'ltToOcCFa') -- ltToOCF
opt('showbreak', '↳ ')
opt('showcmd', true)
opt('showmatch', true)
opt('showmode', false)
opt('tabline', '')
opt('showtabline', 1)
opt('scrolloff', 999)
opt('sidescroll', 0)
opt('sidescrolloff', 0)
opt('smartcase', true)
opt('splitbelow', true)
opt('splitkeep', 'topline') -- cursor, screen, topline
opt('splitright', true)
opt('swapfile', false)
opt('startofline', true) -- motions like "G" also move to the first char
opt('switchbuf', 'useopen,usetab')
opt('termguicolors', true)

opt('shiftwidth', 2)
opt('tabstop', 2)
opt('textwidth', 100)
opt('timeout', true)
opt('timeoutlen', 400) -- 1000
opt('ttimeout', true)
opt('ttimeoutlen', 30) -- 50
opt('undolevels', 1000)
opt('updatetime', 2000) -- 4000
opt('whichwrap', '<,>,[,]') -- 'b,s,<,>,[,],h,l'
opt('wildignore', '*.o,*~,*.pyc') -- wildchar	   /charm for wildmenu  0x1a ^Z, 0x1b ^[, 0x0e C-n
opt('wildmode', 'longest:full,full')
-- opt('winminwidth', 1) -- vimade errors when this is larger
opt('writebackup', true)
opt('wrap', false)
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
--
