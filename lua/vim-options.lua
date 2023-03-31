local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo
local opt = require("utils.core").opt
local config = require("config")

g.mapleader = [[,]]
g.maplocalleader = [[,]]

local buffer = { o, bo }
local window = { o, wo }

-- global scope
opt("autoread", true)
opt("backspace", "eol,start,indent") -- Configure backspace so it acts as it should act
opt("backup", false)
opt("backupcopy", "auto")
-- opt("backupdir", ".,~/.vim/backup,~/.local/share/nvim/backup")
opt("writebackup", true)
opt("breakindent", true)
opt("breakindentopt", "shift:2")
opt("cedit", "<C-t>") -- ctrl-f interferes with popup completion
opt("clipboard", "unnamedplus")
opt("cmdheight", 1) -- 0
opt("cmdwinheight", 10)
opt("completeopt", "menu,menuone,noinsert,noselect")
opt("confirm", true)
opt("cpoptions", "aABceFsx_") -- C causes certain vim programs to screw up
opt("encoding", "UTF-8")
opt("fileencoding", "utf-8")
opt("foldmethod", "manual")
opt("hidden", true)
opt("hlsearch", true)
opt("ignorecase", true)
opt("inccommand", "split")
opt("incsearch", true)
opt("joinspaces", false)
opt("jumpoptions", "stack")
opt("laststatus", 3)
opt("lazyredraw", false)
opt("linebreak", true)
opt("magic", true)
opt("matchtime", 3) -- How many tenths of a second to blink when matching brackets
opt("modelines", 5)
opt("mouse", "nivh")
opt("omnifunc", "")
opt("previewheight", 7)
opt("pumheight", 10)
opt("redrawtime", 5000)
opt("scrolloff", 7)
opt("sessionoptions", "buffers,curdir,folds,help,resize,winpos,terminal") -- winsize messes up on load
opt("shada", [[!,'2000,<1000,s500]])
opt("shortmess", "tToOcSIsa")
opt("showbreak", "↳ ")
opt("showcmd", true)
opt("showmatch", true) -- Show matching brackets when text indicator is over them
opt("showmode", false)
opt("showtabline", 1)
opt("sidescrolloff", 5)
opt("smartcase", true)
opt("splitbelow", true)
opt("splitkeep", "screen") -- scroll behavior for horizontal splits
opt("splitright", true)
opt("swapfile", false)
opt("switchbuf", "useopen,usetab") -- Use the current tab for openning files from quickfix.
opt("termguicolors", true)
opt("textwidth", 1000)
opt("timeout", true)
opt("timeoutlen", 700) -- 1000
opt("ttimeoutlen", 40) -- 50
opt("undolevels", 1000)
opt("updatetime", 4000)
opt("whichwrap", "b,s,<,>,[,],h,l")
opt("wildignore", "*.o,*~,*.pyc") -- wildchar/charm for wildmenu  0x1a ^Z, 0x1b ^[, 0x0e C-n
opt("winbar", "")
opt("wildmode", "longest:full,full")
-- opt("display", "msgsep")
-- opt("shortmess", o.shortmess .. "cS") F silents filename
-- opt("shortmess", "filnxtToOcSIs")
-- opt("more", false) -- dont pause when message finished
-- opt("wildmenu", 1)
-- opt("wildmode", "longest:full,full")
-- opt("wildmode", "") -- full, longest, list, lastused, list:longest, list:full, longest:full
-- opt("wc", 0x0e)
-- opt("wcm", 0x0e)

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
opt("fileformat", "unix", buffer)
opt("modeline", true, buffer)
opt("shiftwidth", 2, buffer)
opt("smartindent", false, buffer)
opt("softtabstop", 0, buffer)
opt("synmaxcol", 2000, buffer)
opt("tabstop", 2, buffer)
opt("undofile", true, buffer)
-- opt("textwidth", 100, buffer) -- set per buffer

-- vim.cmd('set iskeyword+=-') -- treat dash separated words as a word text object"
-- TERMINAL = vim.fn.expand('$TERMINAL')
-- vim.o.titlestring="%<%F%=%l/%L - nvim"
-- vim.o.pumheight = 10 -- Makes popup menu smaller
-- vim.o.timeoutlen = O.timeoutlen -- By default timeoutlen is 1000 ms
-- let loaded_netrw = 0

-- vim.g.nvim_tree_disable_netrw = true
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
