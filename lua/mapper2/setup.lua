local mapper = require("mapper2")
local map = mapper.map
local vmap = mapper.vmap
local prefix = mapper.prefix

prefix("n", "z", "+folds")
prefix("n", "g", "+goto")
prefix("n", "gq", "+quickfix")
prefix("n", "gP", "+preview")
prefix("n", "g?", "+debug print")
prefix("n", "<c-w>", "+window")
prefix("n", "<leader>g", "+git")
prefix("n", "<leader>f", "+file")
prefix("n", "<leader>F", "+format")
prefix("n", "<leader>p", "+paste")
prefix("n", "<leader>i", "+internal tools")
prefix("n", "<leader>cl", "+conceal")

--------------------------------------------------------------------------------------------------
-- COMMAND ---------------------------------------------------------------------------------------

map({ "n", "v" }, ";", ":", {
  category = "Command",
  label = "open cmdline",
  desc = "open the command line",
  nowait = true,
})

map({ "n", "v" }, ":", "q:", {
  category = "Command",
  label = "open cmdwin",
  desc = "open the command window",
  nowait = true,
})

map({ "n" }, "<M-f>", "q:", {
  category = "Command",
  label = "open cmdwin",
  desc = "open the command window",
})

map({ "c" }, "<M-f>", "<C-T>", {
  category = "Command",
  label = "open cmdwin",
  desc = "open the command window",
})

map("c", "<M-b>", "<C-T><Esc>", {
  category = "Command",
  label = "open cmdwin normal",
  desc = "open command window from the command line in normal mode",
})

map("c", "<c-d>", "<C-c>", {
  category = "Command",
  label = "close cmdline",
  desc = "close the commandline",
})

map("c", "<c-[>", "<C-c>", {
  category = "Command",
  label = "close cmdline",
  desc = "close the commandline",
})

map("c", "<c-s>", "<cmd>w<cr><esc>", {
  category = "Command",
  label = "save",
  desc = "save in command window",
})

map("c", "<c-y>", "<c-r>*", {
  category = "Command",
  label = "yank",
  desc = "yank from command window",
})

map("c", "^^", "", {
  category = "Command",
  label = "goto start",
  desc = "go to beginning of command line",
})

map("c", "<M-g>", "<C-r>%", {
  category = "Command",
  label = "insert filename",
  desc = "insert filename into the command line",
})

--------------------------------------------------------------------------------------------------
-- BUFFERS ---------------------------------------------------------------------------------------

map("n", "<BS>", ":e #<cr>", {
  category = "Buffers",
  label = "last buffer",
  desc = "open the last buffer",
})

map("n", "H", "<cmd>BufferPrev<cr>", {
  category = "Buffers",
  label = "left buffer",
  desc = "open the left (prev) buffer",
})

map("n", "L", "<cmd>BufferNext<cr>", { -- "<Plug>(CybuPrev)",
  category = "Buffers",
  label = "right buffer",
  desc = "open the right (next) buffer",
})

map("n", "<leader>!", "<cmd>BufferCloseAllButCurrent<cr>", {
  category = "Buffers",
  label = "close other bufs",
  desc = "close all buffers except current",
})

map({ "n", "s", "v", "i" }, "<C-s>", "<cmd>w<cr><esc>", {
  category = "Buffers",
  label = "write buffer",
  desc = "write to buffer",
})

map("n", "<leader>*", "<cmd>wall<cr>", {
  category = "Buffers",
  label = "write all",
  desc = "write all buffers",
})

map("n", "<leader>w", "<cmd>noa w<cr>", {
  category = "Buffers",
  label = "write noa",
  desc = "write without autocommands",
})

-- TODO: multiple category Buffers, Windows
map("n", "<C-d>", "<cmd>CloseMulti<cr>", {
  category = "Buffers",
  label = "close multi",
  desc = "close tabpage, window, or buffer in that order",
})

map("n", "<leader>.", [[:call AltCommand(expand('%'), ':e')<cr>]], {
  category = "Buffers",
  label = "open alt file",
  desc = "open alternative file associated with buffer",
})

map("n", "<leader>fn", [[:e <C-R>=expand("%:p:h") . "/" <CR>]], {
  category = "Buffers",
  label = "new in cwd",
  desc = "create new file in current directory",
})

map("n", "<leader>fn", [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], {
  category = "Buffers",
  label = "new file h-split",
  desc = "create new file in a horizontal split",
})

map("n", "<leader>fp", "<cmd>pfn :echo expand('%:p')<CR>", {
  category = "Buffers",
  label = "print path",
  desc = "print path of current buffer",
})

map("n", "gf", "0/\"\\|'<cr>hgF", {
  category = "Buffers",
  label = "goto file",
  desc = "open file under cursor",
})

map("n", "<leader>cd", "<cmd>cd %:h<cr>", {
  category = "Buffers",
  label = "cd buffer",
  desc = "change current working directory to buffer directory",
})

--------------------------------------------------------------------------------------------------
-- EXITING ---------------------------------------------------------------------------------------

map("n", "<C-X>", "<cmd>silent! tabclose | qa<cr>", {
  category = "Exiting",
  label = "exit save",
  desc = "quick exit with prompt for save",
})

map("n", "<M-d>", "<cmd>silent! tabclose | qa<cr>", {
  category = "Exiting",
  label = "exit save",
  desc = "quick exit with prompt for save",
})

map("n", "<M-C-X>", "<cmd>silent! tabclose | xa<cr>", {
  category = "Exiting",
  label = "exit nosave",
  desc = "quick exit without saving",
})

--------------------------------------------------------------------------------------------------
-- EXECUTE ---------------------------------------------------------------------------------------

map("n", "!!", "@:", {
  category = "Execute",
  label = "repeat command",
  desc = "repeat the last command",
})

map("n", "<M-r>", "<cmd>Restart<cr>", {
  category = "Execute",
  label = "restart",
  desc = "restart neovim instance",
})

map("n", "<M-T>", "<cmd>RestartTarget<cr>", {
  category = "Execute",
  label = "restart target",
  desc = "restart target of remote neovim instannce",
})

vmap("n", "gx", {
  category = "Execute",
  label = "xdg-open file",
  desc = "open file with xdg-open under cursor",
})

--------------------------------------------------------------------------------------------------
-- MOTION ----------------------------------------------------------------------------------------

vmap("n", "", {
  category = "Motion",
  label = "xdg-open file",
  desc = "open file with xdg-open under cursor",
})

map("n", "n", "<cmd>execute('normal! ' . v:count1 . 'n')<cr><cmd>lua require('hlslens').start()<cr>", {
  category = "Motion",
  plugin = "hlslens",
  label = "next match from search",
  desc = "next matching from search (hls lens)",
})

map("n", "N", "<cmd>execute('normal! ' . v:count1 . 'N')<cr><cmd>lua require('hlslens').start()<cr>", {
  category = "Motion",
  plugin = "hlslens",
  label = "prev match from search",
  desc = "previous matching from search (hls lens)",
})

map("n", "*", "*<cmd>lua require('hlslens').start()<cr>", {
  category = "Motion",
  plugin = "hlslens",
  label = "next word match",
  desc = "next matching word (hls lens)",
})

map("n", "#", "#<cmd>lua require('hlslens').start()<cr>", {
  category = "Motion",
  plugin = "hlslens",
  label = "prev word match",
  desc = "previous matching (hls lens)",
})

map("n", "g*", "g*<cmd>lua require('hlslens').start()<cr>", {
  category = "Motion",
  plugin = "hlslens",
  label = "next search match",
  desc = "next matching search (hls lens)",
})
map("n", "g#", "g#<cmd>lua require('hlslens').start()<cr>", {
  category = "Motion",
  plugin = "hlslens",
  label = "prev search match",
  desc = "prev matching search (hls lens)",
})

map("n", "gn", "g#<cmd>lua require('hlslens').start()<cr>", {
  category = "Motion",
  plugin = "hlslens",
  label = "prev search",
  desc = "next matching from previous search (hls lens)",
})

map("n", "<leader>r", "*:%s//", {
  category = "Motion",
  label = "replace cursor",
  desc = "search and replace word under cursor",
})

map("i", "jk", "<esc>", {
  category = "Motion",
  label = "insert mode escape",
  desc = "quickly escape insert mode",
})

map("i", "kj", "<esc>", {
  category = "Motion",
  label = "insert mode escape",
  desc = "quickly escape insert mode",
})

map("i", "<C-u>", "<C-g>u<C-u>", {
  category = "Motion",
  label = "ctrl+u friendly",
  desc = "make ctrl+u undo friendly",
})

map("n", "<C-w>", "<C-g>u<C-w>", {
  category = "Motion",
  label = "ctrl+w friendly",
  desc = "make ctrl+w undo friendly",
})

map("n", "D", "d$", {
  category = "Motion",
  label = "delete to end",
  desc = "delete to end of line",
})
--
-- map({ "v", "o" }, "al", "<cmd>normal 0v$h<cr>", {
--   category = "Motion",
--   label = "select a line",
--   desc = "select all characters in line without new line",
--   noremap = false,
-- })
--
-- map({ "v", "o" }, "il", "<cmd>normal ^vg_<cr>", {
--   category = "Motion",
--   label = "select in line",
--   desc = "select all characters in line from first non-blank to last non-blank character",
--   noremap = false,
-- })

map("n", "<c-b>", "<Plug>(SmoothieBackwards)", {
  category = "Motion",
  plugin = "vim-smoothie",
  label = "scroll backwards",
  desc = "smooth scroll backwards",
  noremap = false,
})

map("n", "<c-f>", "<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)", {
  category = "Motion",
  plugin = "vim-smoothie",
  label = "scroll forwards",
  desc = "smooth scroll forwards",
  noremap = false,
})

map("n", "<space>", "<c-f><c-f>", {
  category = "Motion",
  plugin = "vim-smoothie",
  label = "scroll forwards x2",
  desc = "smooth scroll forwards x2",
  noremap = false,
})

map("n", "G", "<Plug>(Smoothie_G)", {
  category = "Motion",
  plugin = "vim-smoothie",
  label = "scroll bottom",
  desc = "smooth scroll to bottom",
  noremap = false,
})

map("n", "gg", "<Plug>(Smoothie_gg)", {
  category = "Motion",
  plugin = "vim-smoothie",
  label = "scroll top",
  desc = "smooth scroll to top",
  noremap = false,
})

map("n", "gp", "`[v`]", {
  category = "Motion",
  label = "select last visual",
  desc = "select last visual block afrom bracket marks",
})

vmap("n", "gi", {
  category = "Motion",
  label = "goto last insert",
  desc = "goto last mark of insertion",
})

vmap("n", "gI", {
  category = "Motion",
  label = "goto begin insert",
  desc = "goto beginning mark of insertion",
})

vmap("n", "gv", {
  category = "Motion",
  label = "select last visual",
  desc = "select last visual block afrom bracket marks",
})

-- map("x", "il", "0o$y", {
--   category = "Motion",
--   label = "yank in line",
--   desc = "yank in line without ending new line character",
-- })
--
-- map("o", "il", "<cmd>:normal vil<CR>", {
--   category = "Motion",
--   label = "yank in line",
--   desc = "yank in line without ending new line character",
-- })

map("n", "yy", "mQ0y$`Q", {
  category = "Motion",
  label = "yank line no eol",
  desc = "yank line without ending new line character",
})

map("n", "<leader>py", "<cmd>Telescope neoclip<cr>", {
  category = "Motion",
  label = "neoclip telescope",
  desc = "show neoclip registers in telescope",
})

map("n", "<leader>pp", '"*p', {
  category = "Motion",
  label = "paste primary",
  desc = "paste primary register",
})

map("n", "<leader>pc", '"+p<esc>gvgc^', {
  category = "Motion",
  label = "paste comment",
  desc = "paste as a comment",
})

map("n", "<leader>pm", "<cmd>set invpaste<cr>", {
  category = "Motion",
  label = "toggle paste mode",
  desc = "toggle paste mode",
})

map({ "n", "v" }, "<M-'>", "<cmd>HopWord<cr>", {
  category = "Motion",
  plugin = "hop.nvim",
  label = "hop to word",
  desc = "hop to word",
})

map({ "n", "v" }, "<M-;>", "<cmd>HopLine<cr>", {
  category = "Motion",
  plugin = "hop.nvim",
  label = "hop to line",
  desc = "hop to line",
})

map("v", "<C-X>", "<Esc>`.``gvP``P", {
  category = "Motion",
  label = "swap visual block",
  desc = "swap visual selected block with register",
})

--------------------------------------------------------------------------------------------------
-- UI --------------------------------------------------------------------------------------------

vmap("n", "g<C-G>", {
  category = "UI",
  label = "ascii cursor",
  desc = "show ascii under cursor",
})

map("n", "gA", "<cmd>ascii<cr>", {
  category = "UI",
  label = "ascii cursor",
  desc = "show ascii under cursor",
})

vmap("n", "g<C-g>", {
  category = "UI",
  label = "words/lines count",
  desc = "show current and total characters, words, bytes and lines",
})

map("n", "_", "<cmd>noh<cr> | :nohlsearch<cr>", {
  category = "UI",
  desc = "remove highlights",
})

map("n", "<M-->", "<cmd>noh<cr>|:ClosePopups<cr>", {
  category = "UI",
  desc = "remove hls and close popups",
})

map("n", "<M-b>", "<cmd>noh<cr> | :RefreshLSP<cr> | :lua require'feline'.reset_highlights()<cr>", {
  category = "UI",
  desc = "remove hls, refresh colors and lsp",
})

map("n", "<M-C-_>", "<cmd>:only<cr>|:ClosePopups<cr>", {
  category = "UI",
  desc = "close popups",
})

--------------------------------------------------------------------------------------------------
-- QUICKFIX --------------------------------------------------------------------------------------

map("n", "<C-q>", "<cmd>QFix<cr>", {
  category = "Quickfix",
  label = "togggle quickfix",
  desc = "togggle quickfix window",
})

--------------------------------------------------------------------------------------------------
-- WINDOWS ---------------------------------------------------------------------------------------

vmap("n", "<c-j>", {
  category = "Window",
  label = "window down",
  desc = "move to window below",
})
vmap("n", "<c-k>", {
  category = "Window",
  label = "window up",
  desc = "move to window up",
})
vmap("n", "<c-h>", {
  category = "Window",
  label = "window left",
  desc = "move to window left",
})
vmap("n", "<c-l>", {
  category = "Window",
  label = "window right",
  desc = "move to window right",
})

vmap("n", "<c-w>o", {
  category = "Window",
  label = "close other windows",
  desc = "close other windows except current",
})

map("n", "<leader>o", "<c-w>o", {
  category = "Window",
  label = "close other windows",
  desc = "close other windows except current",
})

vmap("n", "<C-w>x", {
  category = "Window",
  label = "swap windows",
  desc = "swap windows",
})

vmap("n", "<c-w>+", {
  category = "Window",
  label = "window +height",
  desc = "increase height of focused window",
})

vmap("n", "<c-w>-", {
  category = "Window",
  label = "window -height",
  desc = "decrease height of focused window",
})

vmap("n", "<c-w><", {
  category = "Window",
  label = "window +width",
  desc = "increase width of focused window",
})

vmap("n", "<c-w>>", {
  category = "Window",
  label = "window -width",
  desc = "decrease width of focused window",
})

vmap("n", "<c-w>=", {
  category = "Window",
  label = "windows even",
  desc = "resize windows evenly",
})

map("n", "<leader>=", "<c-w>=", {
  category = "Window",
  label = "windows even",
  desc = "resize windows evenly",
})

vmap("n", "<c-w>W", {
  category = "Window",
  label = "window prev",
  desc = "focus the previous window",
})
map("n", "<leader>:", "<c-w>W", {
  category = "Window",
  label = "window prev",
  desc = "focus the previous window",
})

vmap("n", "<c-w>w", {
  category = "Window",
  label = "window next",
  desc = "focus the next window",
})
map("n", "<leader>;", "<c-w>w", {
  category = "Window",
  label = "window next",
  desc = "focus the next window",
})

map("n", "<leader>H", "<cmd>vnew<cr>", {
  category = "Window",
  label = "window split-h",
  desc = "window split horizontally",
})

map("n", "<leader>V", "<cmd>new<cr>", {
  category = "Window",
  label = "window split-v",
  desc = "window split vertically",
})

vmap("n", "<c-w>_", {
  category = "Window",
  label = "max vertical split",
  desc = "maximize height of vertical split",
})
map("n", "<leader>_", "<c-w>_", {
  category = "Window",
  label = "max vertical split",
  desc = "maximize height of vertical split",
})

vmap("n", "<c-w>|", {
  category = "Window",
  label = "max horizontal split",
  desc = "maximize width of horizontal split",
})
map("n", "<leader>|", "<c-w>|", {
  category = "Window",
  label = "max horizontal split",
  desc = "maximize width of horizontal split",
})

map("n", "<leader>q", "<cmd>silent! tabclose | Sayonara<cr>", {
  category = "Window",
  label = "close window",
  desc = "close window smartly wih sayonara",
})

map("n", "<leader>clc", "<cmd>set conceallevel=0<cr>", {
  category = "Window",
  label = "conceal clear",
  desc = "clear all concealing from window",
})

map("n", "<leader>cl0", "<cmd>set conceallevel=0<cr>", {
  category = "Window",
  label = "set conceal 0",
  desc = "set conceal level of window to 0",
})

map("n", "<leader>cl1", "<cmd>set conceallevel=1<cr>", {
  category = "Window",
  label = "set conceal 1",
  desc = "set conceal level of window to 1",
})

map("n", "<leader>cl2", "<cmd>set conceallevel=2<cr>", {
  category = "Window",
  label = "set conceal 2",
  desc = "set conceal level of window to 2",
})

map("n", "<leader>cl3", "<cmd>set conceallevel=3<cr>", {
  category = "Window",
  label = "set conceal 3",
  desc = "set conceal level of window to 3",
})

--------------------------------------------------------------------------------------------------
-- TREESITTER ------------------------------------------------------------------------------------

vmap("n", "<cr>", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "init incsel",
  desc = "initialize incremental selection",
})

vmap("x", "<tab>", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "incsel scope expand",
  desc = "scope incremental selection",
})

vmap("x", "<cr>", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "incsel expand",
  desc = "incremental selection expand",
})

vmap("x", "<s-tab>", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "incsel shrink",
  desc = "incremental selection shrink",
})

vmap("n", "gnd", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "goto ts def",
  desc = "goto treesitter definition",
})

map("n", "gH", "<cmd>TSHighlightCapturesUnderCursor<cr>", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "show ts highlights",
  desc = "show treesitter highlights under cursor",
})

vmap("n", "gtd", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "list ts defs",
  desc = "list treesitter definitions under cursor",
})

vmap("n", "g0", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "list ts toc",
  desc = "list treesitter table of contents definitions",
})

vmap("n", "<a-*>", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "ts next",
  desc = "treesitter next usage",
})

vmap("n", "<a-#>", {
  category = "Treesitter",
  plugin = "treesitter.nvim",
  label = "ts prev",
  desc = "treesitter previous usage",
})

--------------------------------------------------------------------------------------------------
-- PICKERS ---------------------------------------------------------------------------------------

map("n", "<C-p>", "<cmd>lua require('telescope.run')('builtin', 'find_files')<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "files project",
  desc = "find files in project telescope",
})

map("n", "<C-\\>", "<cmd>lua require('telescope.run')('fd_cwd')<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "files curr dir",
  desc = "find files in current directory telescope",
})

map("n", "<C-g>", "<cmd>lua require('telescope.run')('leaderf', { theme = 'dropdown' })<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "buffers",
  desc = "buffers in telescope",
})

map("n", "<C-u>", "<cmd>lua require('telescope.run')('frecency','frecency')<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "frecency files",
  desc = "frecency files in telescope",
})

map("n", "<C-Space>", "<cmd>lua require('telescope.run')('builtin','find_files')<cr>", {
  category = "Pickers",
  plugin = "telescope-frecency.nvim",
  label = "find files",
  desc = "find files in telescope",
})

map("n", "<C-e>", "<cmd>lua require('telescope.run')('builtin','live_grep')<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "grep buffers",
  desc = "live grep open buffers in telescope",
})

map("n", "<M-u>", "<cmd>lua require('telescope.run')('builtin', 'oldfiles')<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "mru files",
  desc = "mru files in telescope",
})

map("n", "<M-i>", "<cmd>lua require('telescope.run')('notify', 'notify')<cr>", {
  category = "Pickers",
  plugin = "notify.nvim",
  label = "notifications",
  desc = "notifications in telescope",
})

map("n", "<M-space>", "<cmd>lua require('telescope.run')('builtin','grep_string', { theme = 'ivy' })<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "grep cursor",
  desc = "grep string under cursor in telescope",
})

map("n", "<M-/>", "<cmd>lua require('telescope.run')('builtin','help_tags')<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "helptags",
  desc = "helptags in telescope",
})

map("n", "<M-g>", "<cmd>lua require('telescope.run')('projects','projects')<cr>", {
  category = "Pickers",
  plugin = "projects_nvim",
  label = "find projects",
  desc = "find projects telescope",
})

map("n", "<M-1>", "<cmd>Telescope resume<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "repeat telescope",
  desc = "repeast last telescope command",
})

map("n", "<leader><leader>", "<cmd>lua require('telescope.run')('find_pickers','find_pickers')<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "find pickers",
  desc = "find pickers in telescope",
})

map("n", "<M-e>", "<cmd>lua require('telescope.run')('builtin','live_grep')<cr>", {
  category = "Pickers",
  plugin = "telescope.nvim",
  label = "grep project",
  desc = "live grep project in telescope",
})

--------------------------------------------------------------------------------------------------
-- GIT -------------------------------------------------------------------------------------------
-- TODO: add precheck function to ensure in git dir

map("n", "<leader>gf", "<cmd>require('telescope.run')('builtin', 'git_files')<cr>", {
  category = "Git",
  plugin = "telescope.nvim",
  label = "git files",
  desc = "show git files in telescope",
})

map("n", "<leader>gb", "<cmd>require('telescope.run')('builtin', 'git_files')<cr>", {
  category = "Git",
  plugin = "telescope.nvim",
  label = "git branches",
  desc = "show git branches in telescope",
})

map("n", "<leader>gs", "<cmd>require('telescope.run')('builtin', 'git_files')<cr>", {
  category = "Git",
  plugin = "telescope.nvim",
  label = "git status",
  desc = "show git status in telescope",
})

map("n", "<leader>gc", "", {
  category = "Git",
  plugin = "telescope.nvim",
  label = "git commits",
  desc = "show git commits in telescope",
})

map("n", "<leader>gC", "", {
  category = "Git",
  plugin = "telescope.nvim",
  label = "git bcommits",
  desc = "show git bcommits in telescope",
})

map("n", "<leader>gn", "<cmd>Gitsigns next_hunk<cr>", {
  category = "Git",
  plugin = "gitsigns.nvim",
  label = "go next hunk",
  desc = "go to next git hunk (gitsigns.nvim)",
})

map("n", "<leader>gp", "<cmd>Gitsigns prev_hunk<cr>", {
  category = "Git",
  plugin = "gitsigns.nvim",
  label = "go prev hunk",
  desc = "go to previous git hunk (gitsigns.nvim)",
})

map("n", "<leader>gv", "<cmd>Gitsigns preview_hunk<cr>", {
  category = "Git",
  label = "git preview hunk",
  desc = "preview git hunk (gitsigns.nvim)",
})

map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", {
  category = "Git",
  label = "git reset hunk",
  desc = "reset git hunk (gitsigns.nvim)",
})

map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", {
  category = "Git",
  label = "git reset buffer",
  desc = "reset git buffer (gitsigns.nvim)",
})

--------------------------------------------------------------------------------------------------
-- FORMAT ----------------------------------------------------------------------------------------

vmap("v", "U", {
  category = "Format",
  label = "uppercase word",
  desc = "format uppercase word",
})
vmap("v", "u", {
  category = "Format",
  label = "lowercase word",
  desc = "format lowercase word",
})

vmap("n", "gu", {
  category = "Format",
  label = "format lowercase",
  desc = "format lowercase word",
})

vmap("n", "gU", {
  category = "Format",
  label = "format uppsercase",
  desc = "format uppercase word",
})

map("n", "<leader>[", "`[V`]<", {
  category = "Format",
  label = "indent all lines",
  desc = "indent all lines",
})

map("n", "<leader>]", "", {
  category = "Format",
  label = "unindent all lines",
  desc = "unindent all lines",
})

map("v", "<", "<gv", {
  category = "Format",
  label = "unindent",
  desc = "unindent repeatedly",
})

map("v", ">", ">gv", {
  category = "Format",
  label = "indent",
  desc = "indent repeatedly",
})

map("n", "<leader>Fx", "<cmd>ISwapNodeWith<cr>", {
  category = "Format",
  label = "swap node with",
  desc = "swap/exchange node objects with (iswap.nvim)",
})

map("n", "<leader>FU", "gUw", {
  category = "Format",
  label = "uppercase word",
  desc = "uppercase word",
})
map("n", "<leader>Fu", "gUw", {
  category = "Format",
  label = "lowercase word",
  desc = "format lowercase word",
})

map({ "n", "v" }, "<leader>Fs", "<cmd>Snek<cr>", {
  category = "Format",
  label = "format snake",
  desc = "format snake case",
})

map({ "n", "v" }, "<leader>Fk", "<cmd>Kebab<cr>", {
  category = "Format",
  label = "format kebab",
  desc = "format kebab case",
})

map({ "n", "v" }, "<leader>Fc", "<cmd>Camel<cr>", {
  category = "Format",
  label = "format camel",
  desc = "format camel case",
})

map({ "n", "v" }, "<leader>FC", "<cmd>CamelB<cr>", {
  category = "Format",
  label = "format camel b",
  desc = "format camel b case",
})

--------------------------------------------------------------------------------------------------
-- SYSTEM ----------------------------------------------------------------------------------------

map("n", "<leader>ii", "<cmd>ImportStatus<cr>", {
  category = "System",
  label = "import status",
  desc = "show import status interface",
})

map("n", "<leader>il", "<cmd>Lazy<cr>", {
  category = "System",
  plugin = "lazy.nvim",
  label = "show plugins",
  desc = "show lazy.nvim plugins",
})

map("n", "<leader>ic", "<cmd>Lazy check<cr>", {
  category = "System",
  plugin = "lazy.nvim",
  label = "lazy.nvim check",
  desc = "show lazy.nvim plugins check",
})

map("n", "<leader>is", "<cmd>Lazy sync<cr>", {
  category = "System",
  plugin = "lazy.nvim",
  label = "lazy.nvim sync",
  desc = "show lazy.nvim plugins sync",
})

map("n", "<leader>ip", "<cmd>Lazy profile<cr>", {
  category = "System",
  plugin = "lazy.nvim",
  label = "lazy.nvim profile",
  desc = "show lazy.nvim plugins profile",
})

map("n", "<leader>it", "<cmd>lua require('telescope.run')('lazy', 'lazy')<cr>", {
  category = "System",
  plugin = "lazy.nvim",
  label = "lazy.nvim telescope",
  desc = "show lazy.nvim plugins in telescope",
})
