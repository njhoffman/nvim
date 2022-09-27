local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo
local opt = require("utils.core").opt
local config = require("config")

g.mapleader = [[,]]
g.maplocalleader = [[,]]

local buffer = { o, bo }
local window = { o, wo }

-- global scope
opt("termguicolors", true)
opt("backup", false)
opt("writebackup", true)
opt("backupcopy", "auto")
opt("backupdir", ".,~/.vim/backup,~/.local/share/nvim/backup")
opt("confirm", true)
opt("linebreak", true)
opt("textwidth", 1000)
opt("swapfile", false)
opt("clipboard", "unnamedplus")

opt("cmdheight", 1) -- 0
opt("cmdwinheight", 10)
opt("cedit", "<M-w>")

-- TODO: change cedit to <M-f>
vim.cmd([[:exe "set cedit=\<C-T>"]])
opt("cpoptions", "aABceFsx_") -- C causes certain vim programs to screw up
-- opt("display", "msgsep")
opt("encoding", "UTF-8")

opt("hidden", true)
opt("inccommand", "split")
opt("incsearch", true)
opt("magic", true)
opt("hlsearch", true)
opt("ignorecase", true)
opt("smartcase", true)
opt("joinspaces", false)
opt("laststatus", 3)
opt("lazyredraw", false)
opt("redrawtime", 5000)
opt("modelines", 5)
opt("mouse", "nivh")
opt("previewheight", 7)
opt("scrolloff", 7)
opt("shada", [[!,'2000,<1000,s500]])
-- Specify the behavior when switching between buffers Use the current tab for openning files from quickfix.
opt("switchbuf", "useopen,usetab")
opt("showtabline", 1)
-- opt("shortmess", o.shortmess .. "cS") F silents filename
-- opt("shortmess", "filnxtToOcSIs")
-- opt("more", false) -- dont pause when message finished
opt("shortmess", "tToOcSIsa")
opt("showmatch", true)
opt("showcmd", true)
opt("showmode", false)
opt("sidescrolloff", 5)
opt("splitbelow", true)
opt("splitright", true)
opt("jumpoptions", "stack")
opt("showbreak", "↳ ")
opt("breakindent", true)
opt("breakindentopt", "shift:2")
opt("undolevels", 1000)
opt("updatetime", 4000)
opt("timeoutlen", 500) -- 1000
opt("ttimeoutlen", 20) -- 50
opt("pumheight", 10)
opt("sessionoptions", "buffers,curdir,folds,help,resize,winpos,terminal") -- winsize messes up on load
opt("fileencoding", "utf-8")
opt("whichwrap", "b,s,<,>,[,],h,l")
opt("autoread", true)
-- opt("completeopt", "menuone,longest")

-- window scope
opt("concealcursor", "nc", window)
opt("conceallevel", 2, window)
opt("cursorline", true, window)
opt("number", true, window)
opt("relativenumber", true, window)
opt("signcolumn", "yes:2", window)
opt("wrap", config.Opts.wrap, window)

-- buffer scope
opt("expandtab", true, buffer)
opt("modeline", true, buffer)
opt("shiftwidth", 2, buffer)
opt("smartindent", false, buffer)
opt("softtabstop", 0, buffer)
opt("synmaxcol", 2000, buffer)
opt("tabstop", 2, buffer)
-- opt("textwidth", 100, buffer) -- set per buffer
opt("undofile", true, buffer)
opt("fileformat", "unix", buffer)

-- Configure backspace so it acts as it should act
opt("backspace", "eol,start,indent")
-- opt.whichwrap:append(",<,>,h,l")
-- Don't redraw while executing macros (good performance config)
opt("lazyredraw", true)
-- Show matching brackets when text indicator is over them
opt("showmatch", true)
-- How many tenths of a second to blink when matching brackets
opt("matchtime", 3)

-- wildchar/charm for wildmenu
-- 0x1a ^Z, 0x1b ^[, 0x0e C-n
opt("wildignore", "*.o,*~,*.pyc")

-- opt("wildmenu", 1)
-- opt("wildmode", "longest:full,full")
-- opt("wildmode", "") -- full, longest, list, lastused, list:longest, list:full, longest:full
-- opt("wc", 0x0e)
-- opt("wcm", 0x0e)

-- vim.cmd('set iskeyword+=-') -- treat dash separated words as a word text object"
-- TERMINAL = vim.fn.expand('$TERMINAL')
-- vim.o.titlestring="%<%F%=%l/%L - nvim"
-- vim.o.pumheight = 10 -- Makes popup menu smaller
-- vim.o.timeoutlen = O.timeoutlen -- By default timeoutlen is 1000 ms
-- vim.g.nvim_tree_disable_netrw = O.nvim_tree_disable_netrw
