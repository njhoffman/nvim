local g = vim.g
local o, wo, bo = vim.o, vim.wo, vim.bo
local opt = require("utils.core").opt
local config = require("config")

g.mapleader = [[,]]
g.maplocalleader = [[,]]

local buffer = {o, bo}
local window = {o, wo}

-- global scope
opt("background", "dark")
opt("backup", false)
opt("writebackup", true)
opt("backupcopy", "auto")
opt("backupdir", ".,~/.vim/backup,~/.local/share/nvim/backup")
opt("confirm", true)
opt("linebreak", true)
opt("textwidth", 1000)
opt("swapfile", false)
opt("clipboard", "unnamedplus")

opt("cmdheight", 1) -- 1
opt("cmdwinheight", 10)
--  menu	   Use a popup menu to show the possible completions.
--  menuone  Use the popup menu also when there is only one match.
--  longest  Only insert the longest common text of the matches.  If
--  preview  Show extra information about the currently selected
--  noinsert Do not insert any text for a match until the user selects
--  noselect Do not select a match in the menu, force the user to
opt("completeopt", "noinsert,noselect,menuone")
opt("cpoptions", "aABceFs_")
-- opt("display", "msgsep")
opt("encoding", "UTF-8")

vim.cmd [[
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

let &t_SI = "\e[5 q"
let &t_EI = "\e[0 q"
" TODO: only set cursorline for normal buffers
" autocmd InsertLeave,InsertEnter * set cul!

]]

-- vim.cmd([[set guicursor+=a:-blinkwait175-blinkoff150-blinkon175]])
-- opt("guicursor", "n-v-c:block-blinkoff150-blinkon175,i-ci-ve:ver25,r-cr:hor20,o:hor50")
-- if os.getenv("TERMINAL") == "wezterm" then
--   -- opt("guicursor",
--   --     "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursorzf,sm:block-blinkwait175-blinkoff150-blinkon175")
-- vim.cmd [[
--   set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
--   \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
--   \,sm:block-blinkwait175-blinkoff150-blinkon175
-- ]]

-- end

opt("hidden", true)
opt("inccommand", "split")
opt("incsearch", true)
opt("magic", true)
opt("hlsearch", true)
opt("ignorecase", true)
opt("joinspaces", false)
opt("laststatus", 2)
opt("lazyredraw", false)
opt("redrawtime", 5000)
opt("modelines", 5)
opt("mouse", "nivh")
opt("previewheight", 7)
opt("scrolloff", 7)
opt("shada", [[!,'2000,<1000,s500,n~/.vim/.shada]])
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
opt("smartcase", true)
opt("splitbelow", true)
opt("splitright", true)

opt("undolevels", 1000)
opt("updatetime", 4000)
opt("wildignore", "*.o,*~,*.pyc")
opt("wildmode", "longest:full,full")
opt("timeoutlen", 500)
opt("ttimeoutlen", 50)
opt("pumheight", 15)
opt("sessionoptions", "buffers,curdir,folds,help,resize,winpos,terminal") -- winsize messes up on load
opt("fileencoding", "utf-8")
opt("whichwrap", "b,s,<,>,[,],h,l")
opt("autoread", true)

-- window scope
opt("foldlevel", 0, window)
opt("foldnestmax", 10, window)
opt("foldenable", false, window)
opt("concealcursor", "nc", window)
opt("conceallevel", 2, window)
opt("cursorline", true, window)
opt("number", true, window)
opt("relativenumber", true, window)
opt("signcolumn", "yes:2", window)
opt("wrap", config.Opts.wrap, window)
-- vim.wo.wrap = O.wrap_lines -- Display long lines as just one line

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

opt("termguicolors", true)
opt("background", "dark")
vim.cmd [[colorscheme nord-nick]]

vim.g.clipboard = {
  name = 'xsel',
  copy = {
    ['+'] = {'xsel', '--nodetach', '-i', '-b'},
    ['*'] = {'xsel', '--nodetach', '-i', '-p'},
  },
  paste = {
    ['+'] = {'xsel', '-o', '-b'},
    ['*'] = {'xsel', '-o', '-p'},
  },
  cache_enabled = 1,
}
-- " To force a reload:
-- 10	"   :unlet g:loaded_clipboard_provider
-- 11	"   :runtime autoload/provider/clipboard.vim
-- 12	let g:loaded_clipboard_provider = 1

vim.g.qf_disable_statusline = true -- This should be the default
vim.g.Eunuch_find_executable = "fd" -- I use my fork of vim-eunuch
vim.g.Illuminate_ftblacklist = {".*"} -- Only use lsp highlighting from the plugin
vim.g.netrw_banner = false
vim.g.netrw_silent = 1
-- vim.g.netrw_http_cmd = 'curl'
-- vim.g.netrw_http_xcmd = '-o'

vim.g.tex_flavor = "latex"
vim.g.vimtex_view_method = "skim"
vim.g.vimtex_quickfix_mode = true
vim.g.vimtex_compiler_latexmk = {
  options = {"-pdf", "-shell-escape", "-verbose", "-file-line-error", "-synctex=1", "-interaction=nonstopmode"}
}
vim.g["test#strategy"] = "neovim"
vim.g.tex_flavor = "latex"
vim.g.indent_blankline_char = "│"
vim.g.indent_blankline_filetype = {"rust", "go", "lua", "json", "ruby"}
vim.g.indent_blankline_use_treesitter = true
vim.g.loaded_ruby_provider = false

-- fixes unlisted buffer error
-- https://github.com/romgrk/barbar.nvim/issues/82#issuecomment-748498951
vim.g.netrw_bufsettings = "noma nomod nonu nowrap ro buflisted"

-- Allows users to specify the type of embedded script highlighting they want:  (perl/python/ruby/tcl support)
vim.g.vimsyn_embed = "--lmpPr"

-- bats
-- Whether or not to add dollar sign to iskeyword.
vim.g.bats_vim_consider_dollar_as_part_of_word = 1

-- pgsql default for sql files
vim.g.sql_type_default = "pgsql"

-- wildchar/charm for wildmenu
-- 0x1a ^Z, 0x1b ^[, 0x0e C-n
-- opt("wc", 0x0e)
-- opt("wcm", 0x0e)

-- vim.cmd('set iskeyword+=-') -- treat dash separated words as a word text object"
-- TERMINAL = vim.fn.expand('$TERMINAL')
-- vim.o.titlestring="%<%F%=%l/%L - nvim"
-- vim.o.pumheight = 10 -- Makes popup menu smaller
-- vim.o.timeoutlen = O.timeoutlen -- By default timeoutlen is 1000 ms
-- vim.g.nvim_tree_disable_netrw = O.nvim_tree_disable_netrw

-- *sessionoptions*
--
-- blank        empty windows
-- buffers      hidden and unloaded buffers, not just those in windows
-- curdir       the current directory
-- folds        manually created folds, opened/closed folds and local fold options
-- globals      global variables that start with an uppercase letter and contain at least one lowercase letter.  Only String and Number types are stored.
-- help         the help window
-- localoptions options and mappings local to a window or buffer (not global values for local options)
-- options      all options and mappings (also global values for local options)
-- skiprtp      exclude 'runtimepath' and 'packpath' from the options
-- resize       size of the Vim window: 'lines' and 'columns'
-- sesdir       the directory in which the session file is located will become the current directory (useful with projects accessed over a network from different systems)
-- tabpages     all tab pages; without this only the current tab page is restored, so that you can make a session for each tab page separately
-- terminal     include terminal windows where the command can be restored
-- winpos       position of the whole Vim window
-- winsize      window sizes
-- slash        |deprecated| Always enabled. Uses "/" in filenames.
-- unix         |deprecated| Always enabled. Uses "\n" line endings.
