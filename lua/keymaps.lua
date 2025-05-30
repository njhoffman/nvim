local mapper = require("mapper")
local map = mapper.map
local vmap = mapper.vmap
local prefix = mapper.prefix

--       况  ﱔ  ﯕ            ﮝ    ﬠ ﬡ ײַ יִ  不 ﬆ       בּ 易    ﮒ   ﴞ  ﯓ ﭹ 難 ﱒ 
--  朗浪  狼ﰅ         諾蠟廊 降    者     ﱒ ﯕ ﬡ 玲 癩ﰈ ﰺ  裸憎降   ײַ ﰲ ﰲ    隷濾 礪 閭 驪 麗 ﱵ  料
-- 繁 署 者 臭ﳺ 禎 穀祐 ﱒ ﮒ ﮭ 󰘖 ﲖ 祖 ﮮ 祝 ﴻ ﯴ ﰌ 省 異  什  輪   ﭕ  ﱿ  蝹 ﬡ 李  惡   祉
-- 隷שּׂ  שּׂ  שּׂ  שּׂ ﱕ      侮  滑 פּ 串     
-- 󱋿 Jump back"
--         

prefix({ "n", "x", "o" }, ",", "leader")
prefix({ "n", "x", "o" }, "]", "next ")
prefix({ "n", "x", "o" }, "[", "previous 丹")
prefix({ "n", "x", "o" }, "<leader>\\", "flash ⚡")

prefix("n", "m", "marks ⚑")
prefix("n", "g", "go 隷")
prefix("n", "z", "folds ﱒ")
prefix("n", "gh", "hover ")
prefix("n", "gl", "lsp 󰃤")
prefix("n", "gq", "quickfix  ")
prefix("n", "gp", "preview  ")
prefix("n", "go", "debug out  ")
prefix("n", "gt", "text ops  ")
prefix("n", "g\\", "flash ⚡")

prefix("n", "<c-w>", "window ")
prefix("n", "<leader>s", "snacks ")
prefix("n", "<leader>g", "git 󰊢")
prefix("n", "<leader>f", "file ")
prefix("n", "<leader>p", "paste ") --  
prefix("n", "<leader>i", "internal ")
prefix("n", "<leader>m", "multi-cursor ")
prefix("n", "<leader>u", "undo 漏")
prefix("n", "<leader>cl", "conceal 󰈉 ")

-- 	u = { name = "" },
-- -- leader prefixes normal mode
-- require("which-key").register({
-- 	o = { name = "  Options" },
-- 	p = { name = " 󰏗 Package" },
-- }, { prefix = "<leader>" })
--
-- -- leader prefixes normal+visual mode
-- require("which-key").register({
-- 	f = { name = " 󱗘 Refactor" },
-- 	l = { name = "  Log / Cmdline" },
-- 	g = { name = " 󰊢 Git" },
-- }, { prefix = "<leader>", mode = { "x", "n" } })
--
-- -- needed so localleader prefixes work with whichkey
-- require("which-key").register {
-- 	["<localleader>"] = { name = "filetype-specific", mode = { "n", "x" } },
-- }

-- vim.cmd([[nnoremap <C-l> :syntax sync fromstart<CR>:redraw<CR>]])

-- ["<leader><tab>"] = { name = "+tabs" },
-- ["<leader>b"] = { name = "+buffer" },
-- ["<leader>c"] = { name = "+code" },
-- ["<leader>f"] = { name = "+file/find" },
-- ["<leader>g"] = { name = "+git" },
-- ["<leader>gh"] = { name = "+hunks" },
-- ["<leader>q"] = { name = "+quit/session" },
-- ["<leader>s"] = { name = "+search" },
-- ["<leader>u"] = { name = "+ui" },
-- ["<leader>w"] = { name = "+windows" },
-- ["<leader>x"] = { name = "+diagnostics/quickfix" },

-- vim.keymap.set("n", "<leader>hh", ":h <CR>")
-- vim.keymap.set("x", "<leader>hh", 'y:h "<CR>')
--
-- vim.keymap.set("x", "C", function()
--     vim.api.nvim_input('y/"<CR>Ncgn')
-- end, { silent = true })

--------------------------------------------------------------------------------------------------

-- -- better up/down
-- TODO: test for foldlines and disable variable
map({ "n", "x" }, "j", "gj", { desc = "Down wrapped", silent = true, noremap = true })
-- map({ "n", "x" }, "k", function()
--   return vim.v.count > 0 and "m'" .. vim.v.count .. "k" or "gk"
-- end, { expr = true })

-- vim.keymap.set("n", "j", function()
--   return vim.v.count > 0 and "m'" .. vim.v.count .. "j" or "gj"
-- end, { expr = true })
-- "v:count == 0 && &wrap ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true }
-- "v:count == 0 && &wrap ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true }
map({ "n", "x" }, "k", "gk", { desc = "Up wrapped", silent = true, noremap = true })

vim.cmd([[
    " nnoremap <expr> j (foldclosed(line('.')) != -1 || &wrap) ? 'gj' : 'j'
    " nnoremap <expr> k (foldclosed(line('.')) != -1 || &wrap) ? 'gk' : 'k'
    " vnoremap <expr> j (foldclosed(line('.')) != -1 || &wrap) ? 'gj' : 'j'
    " vnoremap <expr> k (foldclosed(line('.')) != -1 || &wrap) ? 'gk' : 'k'
    " nnoremap j gj
    " nnoremap k gk
    " vnoremap j gj
    " vnoremap k gk

    tnoremap <Esc> <C-\><C-n>
    tnoremap <M-[> <Esc>
    tnoremap <C-v><Esc> <Esc>
]])

-- TODO: differentiate between vim/lua, auto remove comments

map({ "x" }, "<C-Space>", '"xy:@x<cr>', {
  category = "Command",
  label = " execute selected",
  desc = " execute selected lines",
})

map({ "n", "x" }, ";", ":", {
  category = "Command",
  label = " open cmdline",
  desc = " open the command line",
  silent = false,
})

map({ "n", "x" }, "<M-:>", "q:", {
  category = "Command",
  label = " open cmdwin",
  desc = " open the command window",
})

-- map('c', '<C-Y>', '<C-\\>ey', {
--   category = 'Command',
--   label = ' yank cmdline',
--   desc = ' yank from command line',
--   remap = true,
-- })

-- TODO: vmap C-u C-w
-- TODO: make whichkey screen for cmdline
-- map('c', '<C-t>', '<Right><Del><Left>', {
--   category = 'Command',
--   label = ' delete char',
--   desc = ' delete character to the right of cmdline',
-- })

-- CTRL-\ e {expr}       :cmap <F7> <C-\>eAppendSome()<CR>
-- CTRL-R
--   CTRL-F	the Filename under the cursor
--   CTRL-P	the Filename under the cursor, expanded with 'path' as in |gf|
--   CTRL-W	the Word under the cursor
--   CTRL-A	the WORD under the cursor; see |WORD|
--   CTRL-L	the line under the cursor
--
-- emacs keys
-- C-a              	Go to start of the line
-- C-e              	Go to end of the line.
-- C-k              	Cut/Delete from cursor current position to the end of the line.
-- M-<              	Move to top of buffer
-- M->              	Move to Bottom of buffer
-- M-f              	Move forward one word
-- M-b              	Move backward one word
-- M-[left key]     	Move backward one word
-- M-[right key]    	Move forward one word
-- Mg-g <line-num>  	Go to line number
-- Mg-c <cursor-pos>	Go to character position

-- Readline keys
-- Ctrl+l     Clear the screen
-- Ctrl+b     Move cursor one character to the left
-- Ctrl+f     Move cursor one character to the right
-- Alt+b      Move cursor one word to the left
-- Alt+f      Move cursor one word to the right
-- Ctrl+a     Move cursor to start of the line
-- Ctrl+e     Move cursor to end of the line
-- Ctrl+u     Cut everything from line start to cursor
-- Ctrl+k     Cut everything from the cursor to end of the line
-- Alt+d      Cut the current word after the cursor
-- Ctrl+w     Cut the current word before the cursor
-- Ctrl+y     Paste the previous cut text
-- Alt+y      Paste the second latest cut text
-- Alt+Ctrl+y Paste the first argument of the previous command
-- Alt+./_    Paste the last argument of the previous command
-- Ctrl+p     Move to the previous line
-- Alt+n      Move to the next line
-- Ctrl+s     Search
-- Ctrl+r     Reverse search
-- Ctrl+j     End search
-- Ctrl+g     Abort search (restores original line)
-- Alt+r      Restores all changes made to line
-- Tab        Auto-complete a name
-- Alt+?      List all possible completions
-- Alt+*      Insert all possible completions

map("c", "<M-b>", "<C-]><Esc>", {
  category = "Command",
  label = " open cmdwin normal",
  desc = " open command window from the command line in normal mode",
})

map("c", "<M-f>", "<C-]>", {
  category = "Command",
  label = " open cmdwin insert",
  desc = " open command window from the command line in insert mode",
})

map("c", "<M-S>", "<cmd>w<cr><esc>", {
  category = "Command",
  label = " save cmdline",
  desc = " save in command line",
})

map("c", "<C-Del>", "<S-Right><C-w>", {
  silent = false,
  category = "Command",
  label = " delete word right",
  desc = " delete one word to the right",
})

map("c", "<C-D>", '<cmd>lua require("commands.cmdline").delete_eol()<cr>', {
  silent = false,
  category = "Command",
  label = " delete eol",
  desc = " delete to end of cmdline",
})

map("c", "<C-^>", "<C-Home>", {
  silent = false,
  category = "Command",
  label = " goto start",
  desc = " go to beginning of command line",
})

vmap("c", "<C-g>", {
  category = "Command",
  label = " next search match",
})

map("c", "<M-g>", '<cmd>lua require("commands.cmdline").jump_search_prev()<cr>', {
  silent = false,
  category = "Command",
  label = " toggle cmdline",
  desc = " toggle cmdline depending on command mode",
})

map("c", "<M-^>", '<cmd>lua require("commands.cmdline").toggle()<cr>', {
  silent = false,
  category = "Command",
  label = " toggle cmdline",
  desc = " toggle cmdline depending on command mode",
})

map("c", "<M-$>", "<C-End>", {
  silent = false,
  category = "Command",
  label = " goto end",
  desc = " go to end of command line",
})

map("c", "<C-h>", "<Left>", {
  silent = false,
  category = "Command",
  label = " move left",
  desc = " move to the left by 1 character",
})

map("c", "<M-C-H>", "<S-Left>", {
  silent = false,
  category = "Command",
  label = " move left word",
  desc = " move to the left by 1 word",
})

map("c", "<C-l>", "<Right>", {
  silent = false,
  category = "Command",
  label = " move right",
  desc = " move to the right by 1 character",
})

map("c", "<M-C-L>", "<S-Right>", {
  silent = false,
  category = "Command",
  label = " move right word",
  desc = " move to the right by 1 word",
})

-- todo: ctrl-shift- %
map("c", "<M-%>", "<C-r>%", {
  silent = false,
  category = "Command",
  label = " insert filename cmdline",
  desc = " insert filename into the command line",
})

map("c", "<M-C-e>", [[<c-\>expandcmd(getcmdline())<CR>]], {
  silent = false,
  category = "Command",
  label = " expand special characters",
  desc = " expand special cmdline characters in place",
})

-- "<C-r>=expand('%:p:h')<CR>/", { noremap = true, silent = false }) -- expand path
-- "<C-r>=expand('%:p:r')<CR>", { noremap = true, silent = false })  -- expand file (not ext)

--------------------------------------------------------------------------------------------------
-- COMMENTS ---------------------------------------------------------------------------------------
map("n", "gch", function()
  require("funcs.quality-of-life").commentHr()
end, { category = "Comments", desc = "  horizontal divider" })

map({ "n", "x" }, "gC", function()
  require("funcs.quality-of-life").duplicateAsComment()
end, { category = "Comments", desc = "  duplicate line as comment" })

map({ "n", "x" }, "gcC", function()
  require("funcs.quality-of-life").duplicateAsComment()
end, { category = "Comments", desc = "  duplicate line as comment" })

map({ "n", "x" }, "gc<space>", function()
  require("funcs.quality-of-life").duplicateAsComment()
end, { category = "Comments", desc = "  duplicate line as comment" })

map({ "n", "x" }, "`p", function()
  require("funcs.quality-of-life").pasteAsComment(true)
end, { category = "Comments", desc = "  paste as comment after" })

map({ "n", "x" }, "`P", function()
  require("funcs.quality-of-life").pasteAsComment(false)
end, { category = "Comments", desc = "  paste as comment before" })

map({ "n", "x" }, "gcp", function()
  require("funcs.quality-of-life").pasteAsComment(true)
end, { category = "Comments", desc = "  paste as comment after" })

map({ "n", "x" }, "gcP", function()
  require("funcs.quality-of-life").pasteAsComment(false)
end, { category = "Comments", desc = "  paste as comment before" })

-- map('n', '<leader>pc', '<cmd>normal p`[v`]gc<cr>',       { category = 'Motion',  desc = '  paste as a comment' })

map({ "n", "x" }, "gc<cr>", function()
  -- switch to visual line mode
  vim.cmd("normal! V")
  require("funcs.quality-of-life").duplicateAsComment()
end, { category = "Comments", desc = "  duplicate line as comment, force line mode" })
-- TODO: make operator mapping, map shift/ctrl enter in visual mode

--------------------------------------------------------------------------------------------------
-- BUFFERS ---------------------------------------------------------------------------------------

map(
  { "n", "x" },
  "<C-d>",
  -- "<cmd>lua require('funcs.alt-alt').betterClose()<cr>",
  "<cmd>CloseMulti<cr>",
  { category = "Buffers", desc = "󰽙 close buffer/window" }
)

--  'o<Esc>j'  'm`O<Esc>``'
map("n", "<S-CR>", "O<Esc>", {
  category = "Buffers",
  label = "󰽙 insert new line",
  desc = "󰽙 insert new line without leaving insert mode",
})

map("n", "<BS>", "<cmd>AltLoad<cr>", {
  category = "Buffers",
  label = "󰽙 goto alt-buffer",
  desc = "󰽙 goto alternative/last buffer",
})

map("n", "<C-^>", "<cmd>AltLoad<cr>", {
  category = "Buffers",
  label = "󰽙 goto alt-buffer",
  desc = "󰽙 goto alternative/last buffer",
})

-- keymap({ "n", "x", "i" }, "<C-CR>", "<C-w>w", { desc = " Next Window" })
-- map('n', '<BS>', '<cmd>e #<cr>', {
--   category = 'Buffers',
--   label = '󰽙 last buffer',
--   desc = '󰽙 open the last buffer',
--   silent = true,
-- })

map("n", "H", "<Cmd>BufferPrev<cr>", {
  category = "Buffers",
  label = "󰽙 left buffer",
  desc = "󰽙 open the buffer to the left",
})

map("n", "<leader>bp", "<Cmd>BufferPrev<cr>", {
  category = "Buffers",
  label = "󰽙 left buffer",
  desc = "󰽙 open the buffer to the left",
})

map("n", "L", "<Cmd>BufferNext<cr>", {
  category = "Buffers",
  label = "󰽙 right buffer",
  desc = "󰽙 open the buffer to the right",
})

map("n", "<leader>bn", "<Cmd>BufferNext<cr>", {
  category = "Buffers",
  label = "󰽙 right buffer",
  desc = "󰽙 open the buffer to the right",
})

map("n", "<M-C-L>", "<Cmd>BufferForward<cr>", {
  category = "Buffers",
  label = "󰽙 forward buffer",
  desc = "󰽙 open the next buffer in history",
})

map("n", "<leader>bN", "<Cmd>BufferForward<cr>", {
  category = "Buffers",
  label = "󰽙 forward buffer",
  desc = "󰽙 open the next buffer in history",
})

map("n", "<leader>bf", "<Cmd>BufferForward<cr>", {
  category = "Buffers",
  label = "󰽙 forward buffer",
  desc = "󰽙 open the next buffer in history",
})

map("n", "<M-C-H>", "<Cmd>BufferBack<cr>", {
  category = "Buffers",
  label = "󰽙 back buffer",
  desc = "󰽙 open the previous buffer in history",
})

map("n", "<leader>bP", "<Cmd>BufferBack<cr>", {
  category = "Buffers",
  label = "󰽙 back buffer",
  desc = "󰽙 open the previous buffer in history",
})
map("n", "<leader>bb", "<Cmd>BufferBack<cr>", {
  category = "Buffers",
  label = "󰽙 back buffer",
  desc = "󰽙 open the previous buffer in history",
})

map("n", "<leader>bv", "<cmd>BufferHistory<cr>", { desc = "󰽙 view history" })

map("n", "<C-1>", "<Cmd>BufferFirst<cr>", {
  category = "Buffers",
  label = "󰽙 first buffer",
  desc = "󰽙 open the first buffer",
})

map("n", "<C-9>", "<Cmd>BufferLast<cr>", {
  category = "Buffers",
  label = "󰽙 last buffer",
  desc = "󰽙 open the last buffer",
})

map("n", "<M-(>", "<cmd>BufferMovePrevious<cr>", {
  category = "Buffers",
  label = "󰽙 move buffer left",
  desc = "󰽙 move the buffer to the left",
})
map("n", "<M-)>", "<cmd>BufferMoveNext<cr>", {
  category = "Buffers",
  label = "󰽙 move buffer right",
  desc = "󰽙 move the buffer to the right",
})

map({ "n" }, "<leader>fH", "<cmd>lua vim.treesitter.get_parser(0):parse()<cr>", {
  category = "Buffers",
  label = "󰽙 reset treesitter highlighting",
})

map({ "n", "s", "v", "i" }, "<C-s>", "<cmd>silent! w<cr><esc>", {
  category = "Buffers",
  label = "󰽙 write buffer",
  desc = "󰽙 write to buffer",
  silent = true,
})

map("n", "<leader>f*w", "<cmd>wall<cr>", {
  category = "Buffers",
  label = "󰽙 write all",
  silent = true,
  desc = "󰽙 write all buffers",
})

map("n", "<leader>w", "<cmd>noa w<cr>", {
  category = "Buffers",
  label = "󰽙 write noa",
  desc = "󰽙 write without autocommands",
  silent = true,
})

map("n", "<leader>fw", "<cmd>noa w<cr>", {
  category = "Buffers",
  label = "󰽙 write noa",
  desc = "󰽙 write without autocommands",
  silent = true,
})

map("n", "<leader>fd", "<cmd>BufferDelete<cr>", {
  category = "Buffers",
  label = "󰽙 delete buffer",
  desc = "󰽙 delete buffer without closing window",
})

map("n", "<leader>f*d", "<cmd>BufferCloseAllButCurrent<cr>", {
  category = "Buffers",
  label = "󰽙 close other bufs",
  desc = "󰽙 close all buffers except current",
})

-- map('n', '<S-Space>', '"_caw', { desc = '󱡔 change word' })
-- map('n', '<S-Space>', '"_daw', { desc = '󱡔 delete word' })
map("i", "<M-BS>", "<Esc>cvb", {
  category = "Buffers",
  desc = "󰽙 delete previous word",
  silent = true,
})

map("n", "<leader>fn", [[:e <C-R>=expand("%:p:h") . "/" <CR>]], {
  category = "Buffers",
  label = "󰽙 new file in cwd",
  desc = "󰽙 create new file in current directory",
})

map("n", "<leader>fn", [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], {
  category = "Buffers",
  label = "󰽙 new file h-split",
  desc = "󰽙 create new file in a horizontal split",
})

map("n", "<leader>fp", "<cmd>echo expand('%:p')<CR>", {
  category = "Buffers",
  label = "󰽙 print path",
  desc = "󰽙 print path of current buffer",
})

map("n", "gf", "/\"\\|'<cr>hgF", {
  silent = true,
  category = "Buffers",
  label = "󰽙 goto file",
  desc = "󰽙 open file under cursor",
})

vmap("n", "gF", {
  silent = true,
  category = "Buffers",
  label = "󰽙 goto file:num",
  desc = "󰽙 open file:num under cursor ",
})

map("n", "<leader>cd", "<cmd>cd %:h<cr>", {
  category = "Buffers",
  label = "󰽙 cd buffer",
  desc = "󰽙 change current working directory to buffer directory",
})

--------------------------------------------------------------------------------
-- REFACTORING
-- keymap("n", "<leader>ff", ":% s/<C-r><C-w>//g<Left><Left>", { desc = " :s (cursor word)" })
-- keymap("x", "<leader>ff", [["zy:% s/<C-r>z//g<Left><Left>]], { desc = " :s (selection)" })
-- keymap("x", "<leader>fv", ": s///g<Left><Left><Left>", { desc = " :s (inside visual)" })
-- keymap("n", "<leader>fd", ":g//d<Left><Left>", { desc = " delete matching" })
--
-- ---@param useSpaces boolean
-- local function retabber(useSpaces)
-- 	local char = useSpaces and "󱁐" or "󰌒"
-- 	bo.expandtab = useSpaces
-- 	bo.tabstop = 2
-- 	cmd.retab { bang = true }
-- 	if not useSpaces then bo.tabstop = 3 end
-- 	u.notify("Indent", ("Now using %s"):format(char))
-- end
-- keymap("n", "<leader>f<Tab>", function() retabber(false) end, { desc = "󰌒 Use Tabs" })
-- keymap("n", "<leader>f<Space>", function() retabber(true) end, { desc = "󱁐 Use Spaces" })
-- keymap(
-- 	"n",
-- 	"<leader>f<CR>",
-- 	function() vim.opt_local.fileformat = "unix" end,
-- 	{ desc = "󰌑 Use Unix File Endings" }
-- )
-- --------------------------------------------------------------------------------
--
-- -- MAKE
-- keymap("n", "<leader>r", function()
--   vim.cmd("silent! update")
--   vim.cmd.lmake()
-- end, { desc = " Make" })
-- keymap(
--   "n",
--   "<leader>R",
--   function() require("funcs.quality-of-life").selectMake() end,
--   { desc = " Select Make" }
-- )
--
-- -- TERMINAL
-- keymap(
--   { "n", "x" },
--   "<leader>t",
--   function() require("funcs.quality-of-life").sendToWezTerm() end,
--   { desc = " Send to WezTerm" }
-- )
--
-- --------------------------------------------------------------------------------
-- -- OPTION TOGGLING
--
-- keymap("n", "<leader>on", "<cmd>set number!<CR>", { desc = " Line Numbers" })
-- keymap("n", "<leader>ow", "<cmd>set wrap!<CR>", { desc = "󰖶 Wrap" })
-- keymap("n", "<leader>ol", vim.cmd.LspRestart, { desc = "󰒕 LspRestart" })
--
-- keymap("n", "<leader>od", function() -- codespell-ignore
--   local change = vim.diagnostic.is_disabled(0) and "enable" or "disable"
--   vim.diagnostic[change](0)
-- end, { desc = " Diagnostics" })
-- keymap("n", "<leader>oh", function()
--   local enabled = vim.lsp.inlay_hint.is_enabled(0)
--   vim.lsp.inlay_hint.enabled(0, not enabled)
-- end, { desc = "󰒕 LSP Inlay Hints" })
--
-- keymap(
--   "n",
--   "<leader>oc",
--   function() vim.opt_local.conceallevel = vim.opt_local.conceallevel:get() == 0 and 1 or 0 end,
--   { desc = "󰈉 Conceal" }
-- )
--

--------------------------------------------------------------------------------
-- UNDO

-- save open time for each buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.b.timeOpened = os.time()
  end,
})

map("n", "<leader>ur", function()
  vim.cmd("silent later " .. tostring(vim.opt.undolevels:get()))
end, { desc = "漏redo all" })

map("n", "<leader>uo", function()
  local now = os.time()
  local secsPassed = now - vim.b.timeOpened
  vim.cmd.earlier(tostring(secsPassed) .. "s")
end, { desc = "漏undo since last open" })

map({ "n", "x" }, "<leader>ub", "<cmd>AltReopen<cr>", { desc = "漏 undo buffer closing" })

map({ "n", "x" }, "<leader>ul", "<cmd>undolist<cr>", { desc = "漏 undo show list" })

map(
  { "i" },
  "<C-r>",
  '<cmd>silent! execute "normal <C-g>u<C-r><cr>"',
  { desc = "漏 insert register without undo sequence", silent = true }
)


-- specify scope of undo change (break undo sequence on insert)
--
-- -- undo 0, earlier 5m, earlier 1h, later 5h, later 1f (file writes later)
-- map('i', ',', ',<c-g>u', { category = 'Buffers', desc = 'add undo at ,' })
-- map('i', '.', '.<c-g>u', { category = 'Buffers', desc = 'add undo at .' })

-- stylua: ignore start
--------------------------------------------------------------------------------------------------
-- MACROS ---------------------------------------------------------------------------------------

-- use Q to record macro, qq to run macro (NeoComposer)
-- map('n', 'q', '<nop>')

-- Taking from here: https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
-- function! ExecuteMacroOverVisualRange()
--   echo "@".getcmdline()
--   execute ":'<,'>normal @".nr2char(getchar())
-- endfunction
map('x', '@', '<cmd><C-u>echo "@".getcmdline() | execute ":\'<,\'>normal @" . nr2char(getchar())<CR>', {
  category = 'Macros',
  desc = 'allows running macros only on selected files',
})

map('x', '.', '<cmd>normal .<CR>', {
  category = 'Macros',
  desc = 'dot repeat macro',
})
--------------------------------------------------------------------------------------------------
-- EXITING ---------------------------------------------------------------------------------------
map('n', '<M-X>', '<cmd>silent! tabclose | qa<cr>', {
  category = 'Exiting',
  label = 'exit save',
  desc = 'quick exit with prompt for save',
})

-- map('n', '<M-C-X>', '<cmd>silent! tabclose | xa<cr>', {
--   category = 'Exiting',
--   label = 'exit nosave',
--   desc = 'quick exit without saving',
-- })

--------------------------------------------------------------------------------------------------
-- EXECUTE ---------------------------------------------------------------------------------------
-- map('n', '<C-1>', '<cmd>RunFile<cr>', {
-- map('n', '<C-1>', '<cmd>luafile %<cr>', {
--   category = 'Execute',
--   label = 'ﲵ luafile bufer',
--   desc = 'ﲵ luafile buffer',
--   silent = true
-- })
-- vim.api.nvim_set_keymap('n', '<localleader>1', '<cmd>luafile %<cr>', { silent = true })

-- map('n', '!~', '<cmd>RunSelect<cr>', {
--   category = 'Execute',
--   label = 'ﲵ select runner task',
--   desc = 'ﲵ assign task to runner',
-- })

map('n', '!@', '<cmd>@:<cr>', {
  category = 'Execute',
  label = 'ﲵ repeat last command',
})

map('n', '!!', '<cmd>@:<cr>', {
  category = 'Execute',
  label = 'ﲵ repeat runner command',
  desc = 'ﲵ execute configured runner task',
})

map('n', '<M-r>', '<cmd>Restart<cr>', {
  category = 'Execute',
  label = 'ﲵ restart',
  desc = 'ﲵ restart neovim instance',
})

map('n', '<M-!>', '<cmd>RestartTarget<cr>', {
  category = 'Execute',
  label = 'ﲵ restart target',
  desc = 'ﲵ restart target of remote neovim instannce',
})

vmap('n', 'gx', {
  category = 'Execute',
  label = 'ﲵ xdg-open file',
  desc = 'ﲵ open file with xdg-open under cursor',
})
--------------------------------------------------------------------------------------------------
-- SEARCH ----------------------------------------------------------------------------------------

local opts = { noremap = true, silent = true, desc = ' search' }

-- --   ﰍ  
-- local icon = ' '
-- map("n", "g*", "*Ncgn", { desc = "Change word with . repeat" })

-- map('n', '<C-n>', [[<Cmd>execute('normal! ' . v:count1 . 'n') <bar> lua require('hlslens').start()<CR>]], opts)
-- map('n', '<M-n>', [[<Cmd>execute('normal! ' . v:count1 . 'N') <bar> lua require('hlslens').start()<CR>]], opts)
-- map('n', 'n', [[<Cmd>execute('normal! ' . v:count1 . 'n') <bar> lua require('hlslens').start()<CR>]], opts)
-- map('n', 'N', [[<Cmd>execute('normal! ' . v:count1 . 'N') <bar> lua require('hlslens').start()<CR>]], opts)
map('n', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], opts)
-- map('n', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], opts)
-- map('n', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], opts)
-- map('n', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], opts)
--
-- map('x', '*', [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]], opts)
-- map('x', '#', [[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]], opts)
-- map('x', 'g*', [[<Plug>(asterisk-gz*)<Cmd>lua require('hlslens').start()<CR>]], opts)
-- map('x', 'g#', [[<Plug>(asterisk-gz#)<Cmd>lua require('hlslens').start()<CR>]], opts)

map('n', 'cg*', '*Ncgn', {
  silent = true,
  category = 'Search',
  label = '  replace word (dot)',
  desc = '  replace word under cursor (dot repeat)'
})
-- nnoremap c# #``cgN
-- nnoremap c* *``cgn
-- nnoremap d* /\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgn
--   nnoremap d# ?\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgN
--   which replaces the word under cursor for whatever you want; after that, you can keep pressing . and it will keep substituting all the instances of the original word (ala multiple cursors). You can skip them with n (as you would in a normal search). The second mapping goes the other way around: substitutes upwards.
--
map('n', 'g.', [[/\V\C<C-r>"<CR>cgn<C-a><Esc>]], {
  silent = true,
  category = 'Search',
  label = '  jump replace (dot)',
  desc = '  jump to next match and replace (dot)',
})

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map({"n", "x", "o"}, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map({"n", "x", "o"}, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- nmap [[ ?^.section <CR>
-- nmap ]] /?section /<CR>

local function open_last_search(reverse)
  return function()
    local last_search = vim.fn.getreg('/')
    local prefix = reverse and "?" or '/'
    vim.cmd('normal ' .. prefix .. last_search)
  end
end

map('n', '<M-f>', open_last_search(), {noremap = true, silent = true})

-- map('n', '<esc>', "<cmd>getcmdtype() =~ '^[/?]$'<cr>", {
--   silent = true,
--   category = 'Search',
--   label = '  jump replace (dot)',
--   desc = '  jump to next match and replace (dot)',
-- })
-- switch escape and enter in search mode to 'accept' it for smoother operation

-- vim.cmd[[
--   cnoremap <expr> <Esc> getcmdtype() =~ '^[/?]$' ? '<Enter>' : '<C-C>'
-- ]]
--------------------------------------------------------------------------------------------------
-- map('c', '<esc>', function()
--   local regtype = vim.fn.getregtype('/')
--   local regval  = vim.fn.getreg('/')
--   local cmdtype = vim.fn.getcmdtype()
--   local reginfo = vim.fn.getreginfo('/')
--   if cmdtype == '/' or cmdtype == '?'  then
--     local cmdline = vim.fn.getcmdline()
--     cmdline = vim.fn.trim(cmdline and #tostring(cmdline) > 0 and cmdline:sub(2))
--     if not cmdline or cmdline == '' or cmdline == 'v:false' then
--       -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Enter>', true, false, true), 'c')
--       -- vim.fn.setcmdline(regval)
--       vim.dbglog('1', cmdline, cmdtype, regval)
--       local searchcount = vim.fn.searchcount({ maxcount = 0 })

--       -- schedule a <cr> input to trigger the search
--       vim.schedule(function()
--         vim.api.nvim_input('<cr>')
--         -- vim.api.nvim_input(M.op and '<cr>' or '<esc>')
--         vim.fn.setreg('/', '')
--         vim.fn.histdel('search', -1)
--       end)
--     else
--       vim.dbglog(vim.fn.histnr('search'), vim.fn.histget('search', vim.fn.histnr('search')))
--       -- clear search registers
--       -- if vim.fn.histget('search', -1) == cmdline then
--       -- end
--       -- vim.dbglog('2.5', vim.fn.getcmdline(), vim.fn.getreg('/'), vim.fn.histnr('search'), vim.fn.histget('search', vim.fn.histnr('search')))
--       -- vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'c')
--       -- vim.fn.histdel('search', -1)
--     end
--   else
--     vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-c>', true, false, true), 'c')
--   end
-- end, {
--   silent = true,
--   category = 'Search',
--   label = '  search escape handler',
--   desc = '  switch escape and enter in search mode to "accept" it for smoother operation',
-- })
-- MOTION ----------------------------------------------------------------------------------------

map('n', '<leader>R', '*:%s//', {
  category = 'Motion',
  label = 'replace cursor word',
  desc = 'search and replace word under cursor',
})

map('i', 'kj', '<esc>', {
  category = 'Motion',
  label = 'insert mode escape',
  desc = 'quickly escape insert mode',
  silent = true
})

map('i', '<M-lt>', '<C-d>', { category = 'Motion', desc = 'deindent line', silent = true })
map('i', '<M->>', '<C-t>', { category = 'Motion', desc = 'indent line', silent = true })

map('i', '<C-t>', '<cmd>norm! x<cr>', { -- <C-o> + dl, norm lxh
  category = 'Motion',
  desc = 'delete next char',
  silent = true
})

map('i', '<C-d>', '<cmd>norm! de<cr>', {
  category = 'Motion',
  desc = 'delete to end of line',
  silent = true
})

map('n', 'D', 'd$', {
  category = 'Motion',
  label = 'delete to end',
  desc = 'delete to end of line',
  silent = true
})


-- TODO: disable <C-V> in alacritty
-- TODO: go back to original position after select all

map('n', '<leader>%', 'ggv$G$', {
    category = 'Motion',
    label = ' visual select entire buffer',
  })

--
vmap('n', 'gi', {
  category = 'Motion',
  label = ' goto last insert',
  desc = ' goto last mark of insertion',
})

vmap('n', 'gI', {
  category = 'Motion',
  label = ' goto begin insert',
  desc = ' goto beginning mark of insertion',
})

map('n', 'gy', "'[,']", {
  category = 'Motion',
  label = ' select last visual',
  desc = ' select last visual block afrom bracket marks',
})

vmap('n', 'gv', {
  category = 'Motion',
  label = ' select last visual',
  desc = ' select last visual block afrom bracket marks',
})

map('i', '<esc>', '<Esc>`^', {
  category = 'Motion',
  desc = ' convenience cursor placement after insert',
  silent = true,
})
-- Map({ "n", "x", "o" }, "gV", "`[v`]")

-- map("n", "gV", "`[v`]", { desc = "visually select the block of text", silent = true })

-- Map({ "n", "x", "o" }, "gV", "`[v`]")
-- map("n", "gV", "`[v`]", { desc = "visually select the block of text", silent = true })
-- map('n', 'gV', "'`['.strpart(getregtype(), 0, 1).'`]'", { expr = true, desc = ' re-select latest changed, put, or yanked text' })

-- map({ "n", "x", "o" }, "gV", "`[v`]")
-- nnoremap <expr> gV '`[' . strpart(getregtype(), 0, 1) . '`]'
map('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', {
  category = 'Motion',
  label = ' select changed text',
  desc = ' re-select latest changed, put, or yanked text',
  expr = true,
})

--  -- Search inside visually highlighted text. Use `silent = false` for it to make effect immediately.
--  map('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })
--  -- Search visually selected text (slightly better than builtins in Neovim>=0.8)
--  map('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
--  map('x', '#', [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])
-- vnoremap * y/\V<C-R>=substitute(escape(@@,"/\\"),"\n","\\\\n","ge")<CR><CR>
-- vnoremap # y?\V<C-R>=substitute(escape(@@,"?\\"),"\n","\\\\n","ge")<CR><CR>
-- vnoremap / <Esc>/\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
-- vnoremap ? <Esc>?\%><C-R>=line("'<")-1<CR>l\%<<C-R>=line("'>")+1<CR>l
-- -Make dot work over visual line selections- vnoremap * y/\V<C-R>=escape(@“,’/\’)<CR><CR>
-- xnoremap . :norm.<CR>
-- nnoremap <silent> gt :set operatorfunc=DotRepeat<cr>g@
-- au ModeChanged [vV\x16]:* :redraw!

map('i', '<C-f>', '<Esc>ea', {
  category = 'Motion',
  label = ' jump over word',
  desc = '  jump over word while staying in insert mode',
  noremap = true,
})

map('i', '<M-f>', '<Esc>bi', {
  category = 'Motion',
  label = ' jump prev word',
  desc = '  jump prev word while staying in insert mode',
  noremap = true,
})

map('n', 'U', '<c-r>', {
  category = 'Motion',
  label = '漏asssign line undo',
  desc = '漏assign line undo',
})

map('n', 'U', '', {
  category = 'Motion',
  label = '漏disable line undo',
  desc = '漏disable line undo so it can prefix other commands',
})

map({ 'n' }, "<M-BS>", '<cmd>pop<cr>', {
  category = 'Motion',
  desc = ' jump to previous tag',
})

vmap({ 'n' }, "<C-]>",  {
  category = 'Motion',
  desc = ' jump to next tag',
})


-- map({'n'}, '<M-{>', '<cmd>norm v{<cr>', {
--   category = 'Motion',
--   desc = ' visual select previous block ',
-- })

-- map({'n'}, '<M-}>', '<cmd>norm v}<cr>', {
--   category = 'Motion',
--   desc = ' visual select next block',
-- })


map({'x'}, '<M-{>', '<cmd>norm {<cr>', {
  category = 'Motion',
  desc = ' select previous block',
})

map({'x'}, '<M-}>', '<cmd>norm }<cr>', {
  category = 'Motion',
  desc = ' select next block',
})

map({'n', 'o', 'x'}, '[[', '?{<CR>w99[{', {
  category = 'Motion',
  desc = ' traverse backward to section {',
})

map({'n', 'o', 'x'}, ']]', 'j0[[%/{<CR>', {
  category = 'Motion',
  desc = ' traverse forward to section {',
})

map({'n', 'o', 'x'}, '][', '/}<CR>b99]}', {
  category = 'Motion',
  desc = ' traverse forward to section }',
})

map({'n', 'o', 'x'}, '[]', 'k$][%?}<CR>', {
  category = 'Motion',
  desc = ' traverse backward to section {',
})
map('x', 'I', function() return vim.fn.mode() == 'V' and '^<C-v>I' or 'I' end, { expr = true, desc = "Block insert in line visual mode" })
map('x', 'A', function() return vim.fn.mode() == 'V' and '$<C-v>A' or 'A' end, { expr = true, desc = "Block insert in line visual mode" })

local searching_google_in_normal = [[:lua fn.system({'open', 'https://google.com/search?q=' .. vim.fn.expand("<cword>")})<CR>]]
local searching_google_in_visual = [[<ESC>gv"gy<ESC>:lua fn.system({'open', 'https://google.com/search?q=' .. vim.fn.getreg('g')})<CR>]]
vim.api.nvim_set_keymap("n", "g!!", searching_google_in_normal, { silent = true, noremap = true })
vim.api.nvim_set_keymap("x", "g!!", searching_google_in_visual, { silent = true, noremap = true })

-- TODO: create function to save last visual selection before undoing
-- map('n', 'Uv', 'u"`[" . strpart(getregtype(), 0, 1) . "`]"gA', {
--   category = 'Motion',
--   label = 'undo align, re-select interactive',
--   desc = 'undo align, re-select visual range and align interactive',
-- })

-- map('n', 'Ua', 'u"`[" . strpart(getregtype(), 0, 1) . "`]"gA', {
--   category = 'Motion',
--   label = 'undo align, re-select interactive',
--   desc = 'undo align, re-select visual range and align interactive',
-- })

-- Shift-CR, Ctrl-CR in alacritty
-- - { key: Return,   mods: Shift,   chars: "\x1b[13;2u" }
-- - { key: Return,   mods: Control, chars: "\x1b[13;5u" }
-- # using: https://stackoverflow.com/questions/16359878/how-to-map-shift-enter
-- map shift+enter              send_text all \x1b[13;2u      # <s-cr>
-- map ctrl+enter               send_text all \x1b[13;5u      # <c-cr>
-- map ctrl+shift+enter         send_text all \x1b[13;6u      # <c-s-cr>
-- map shift+tab                send_text all \x1b[9;2u       # <s-tab>
-- map ctrl+tab                 send_text all \x1b[9;5u       # <c-tab>
-- map ctrl+shift+tab           send_text all \x1b[9;6u       # <c-s-tab>

--
-- " These mappings extend the spirit of * and # for visual searching.
-- " Use visual select to select an area, then search for matches by
-- " typing * or #. This is very useful for searching for other instances of
-- " long, complex strings that may contain regex methacharacters and multiple
-- " lines. You don't have to worry about quoting.
-- vmap <silent> * y:let @/=substitute(escape(@",'.$*[^\/~'),'\n','\\n','g')<CR>n
-- vmap <silent> # y:let @/=substitute(escape(@",'.$*[^\/~'),'\n','\\n','g')<CR>N
-- vnoremap <silent> * :<C-U>
--               \let old_reg=getreg('"')<bar>
--               \let old_regmode=getregtype('"')<cr>
--               \gvy/<C-R><C-R>=substitute(substitute(
--               \escape(@", '\\/.*$^~[]' ), "\n$", "", ""),
--               \"\n", '\\_[[:return:]]', "g")<cr><cr>
--               \:call setreg('"', old_reg, old_regmode)<cr>
-- vnoremap <silent> # :<C-U>
--               \let old_reg=getreg('"')<bar>
--               \let old_regmode=getregtype('"')<cr>
--               \gvy?<C-R><C-R>=substitute(substitute(
--               \escape(@", '\\/.*$^~[]' ), "\n$", "", ""),
--               \"\n", '\\_[[:return:]]', "g")<cr><cr>
--               \:call setreg('"', old_reg, old_regmode)<cr>
-- " This maps \y so that it will yank the visual selection and quote the regex
-- " metacharacters. For example, use v to select some text; type \y; then type
-- " CTRL-R" to insert the yanked selection with metacharacters escaped.
-- vmap <silent> <leader>y y:let @"=substitute(escape(@",'.$*[^\/~'),'\n','\\n','g')<CR>
-- LINE & CHARACTER MOVEMENT
-- keymap("n", "<Down>", [[<cmd>. move +1<CR>==]], { desc = "󰜮 Move Line Down" })
-- keymap("n", "<Up>", [[<cmd>. move -2<CR>==]], { desc = "󰜷 Move Line Up" })
-- keymap("n", "<Right>", [["zx"zp]], { desc = "➡️ Move Char Right" })
-- keymap("n", "<Left>", [["zdh"zph]], { desc = "⬅ Move Char Left" })
-- keymap("x", "<Down>", [[:move '>+1<CR>gv=gv]], { desc = "󰜮 Move Selection down", silent = true })
-- keymap("x", "<Up>", [[:move '<-2<CR>gv=gv]], { desc = "󰜷 Move Selection up", silent = true })
-- keymap("x", "<Right>", [["zx"zpgvlolo]], { desc = "➡️ Move Selection right" })
-- keymap("x", "<Left>", [["zdh"zPgvhoho]],):format()):format()):format()):format()):format() { desc = "⬅ Move Selection left" })


--------------------------------------------------------------------------------------------------
-- Movement --------------------------------------------------------------------------------------------

-- todo: why do i ahve to rebind this
map('i', '<M-d>', '<cmd>norm d$<cr>', {
  category = 'Motion',
  label = 'delete to eol',
  desc = 'delete until the end of line',
})


--------------------------------------------------------------------------------------------------
-- UI --------------------------------------------------------------------------------------------

map('n', '<esc>', '<cmd>noh<cr> | <cmd>call smoothie#stop()<cr>', {
  category = 'UI',
  nowait = true,
  desc = 'remove highlights and stop scrolling',
})

map(
  'n',
  '<M-c>',
  '<cmd>noh<cr> | <cmd>ClosePopups<cr> |  <cmd>lua require("flash.util").exit()<cr>',
  { category = 'UI', desc = 'remove hls, close popups and refresh' }
)

map('n', '<F1>', "<cmd>lua require('telescope.run')('builtin', 'help_tags')<cr>", {
  plugin = 'telescope.nvim',
  category = 'UI',
  desc = '  toggle help',
})

map('n', '<F12>', "<cmd>Stats<cr>", {
  plugin = 'telescope.nvim',
  category = 'UI',
  desc = '  toggle help',
})


map('n', '<F2>', '<cmd>WhatKey<cr>', {
  plugin = 'what-key.nvim',
  category = 'UI',
  desc = '  toggle whatkey nor'
})

map('i', '<F2>', '<cmd>WhatKey "" i<cr>', {
  plugin = 'what-key.nvim',
  category = 'UI',
  desc = '  toggle whatkey ins'
})

map('x', '<F2>', '<cmd>WhatKey "" v<cr>', {
  plugin = 'what-key.nvim',
  category = 'UI',
  desc = '  toggle whatkey vis'
})

map('s', '<F2>', '<cmd>WhatKey "" v<cr>', {
  plugin = 'what-key.nvim',
  category = 'UI',
  desc = '  toggle whatkey vis'
})

map('c', '<F2>', '<cmd>WhatKey "" c<cr>', {
  plugin = 'what-key.nvim',
  category = 'UI',
  desc = '  toggle whatkey cmd'
})

map('t', '<F2>', '<cmd>WhatKey "" t<cr>', {
  plugin = 'what-key.nvim',
  category = 'UI',
  desc = '  toggle whatkey term'
})

map('o', '<F2>', '<cmd>WhatKey "" o<cr>', {
  plugin = 'what-key.nvim',
  category = 'UI',
  desc = '  toggle whatkey op'
})

map('n', '<F3>', '<cmd>WhichKey<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = '  toggle whichkey nor'
})

map('i', '<F3>', '<cmd>WhichKey i<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = '  toggle whichkey ins'
})

map('x', '<F3>', '<cmd>WhichKey x<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = '  toggle whichkey vis'
})

map('s', '<F3>', '<cmd>WhichKey s<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = '  toggle whichkey vis'
})

map('c', '<F3>', '<cmd>WhichKey c<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = '  toggle whichkey cmd'
})

map('t', '<F3>', '<cmd>WhichKey t<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = '  toggle whichkey term'
})

map('o', '<F3>', '<cmd>WhichKey o<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = '  toggle whichkey op'
})

-- shift+F2
map('n', '<F14>', '<cmd>WhatKeyBackground<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = '  toggle whichkey background',
})

-- map('n', '<F6>', '<Leader>Wk', {
--   plugin = 'wf.nvim',
--   category = 'UI',
--   desc = '  toggle wf.nvim',
-- })

-- ctrl+shift F2 = <F38>
-- map('n', '<F3>', '<cmd>AerialToggle!float<cr>', {
--   plugin = 'aerial.nvim',
--   category = 'UI',
--   desc = '  toggle aerial sidebar',
-- })

-- map('n', '<F4>', '<cmd>Neotree show toggle<cr>', {
--   plugin = 'neo-tree',
--   category = 'UI',
--   desc = '  toggle neotree',
-- })
--
-- ctrl+shift+f4
map('n', '<F40>', '<cmd>lua require("oil").open_float<cr>', {
  plugin = 'oil.nvim',
  category = 'UI',
  desc = '  toggle oil file manager',
})

-- map('n', '<F5>', "<cmd>lua require('telescope.run')('undo', 'undo')<cr>", {
--   plugin = 'telescope.nvim',
--   category = 'UI',
--   desc = '  toggle telescope undo',
-- })
--
-- nnoremap <silent><F6> <ESC>:execute 'colo' colors_name<cr>:syntax sync fromstart<cr>
-- redraw and reset syntax highlighting ff
-- nnoremap Q @q
-- Insert line above cursor and move cursor to that line at correct indent while staying in insert mode
-- inoremap <silent><c-o> <esc>O
-- Escape spaces in command-mode by pressing space twice
-- cnoremap <space><space> \<space>

-- yank paste, paste the last yank
-- nnoremap yp "0p
-- nnoremap yP "0P

-- vip:s/...
-- :h c_CTRL-R_CTRL-w
-- :'{,'}s/\<<C-r><C-W>\>/

-- " Add a space before/after line but keep normal mode
-- nnoremap <leader>o o<ESC>
-- nnoremap <leader>O O<ESC>

-- nnoremap d* /\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgn
-- nnoremap d# ?\<<C-r>=expand('<cword>')<CR>\>\C<CR>``dgN

-- dp to "_d
-- nnoremap <leader>< V`]<
-- nnoremap <leader>> V`]>

-- Insert line above cursor and move cursor to that line at correct indent while staying in insert mode
--   inoremap <silent><c-o> <esc>O

-- cmap w!! w !sudo tee > /dev/null %
-- For when you have edited a file and forgot to be root.

-- inoremap jj <esc>
-- nnoremap Y y$
-- " buffers overview
-- nnoremap gb :ls<CR>:b
-- " quick copy
-- nnoremap gy :%y+<CR>

-- nnoremap <Leader>S :<C-U>%substitute/\<<C-R><C-W>\>//g<Left><Left>
--
-- nnoremap <Leader>s :<C-U>%substitute/\</g<Left><Left>
-- xnoremap <Leader>s :substitute/\</g<Left><Left>
-- nnoremap <Leader>g :<C-U>%global/\<
-- xnoremap <Leader>g :global/\<
-- nnoremap <Leader>v :<C-U>%vglobal/\<
-- xnoremap <Leader>v :vglobal/\<
-- nnoremap <Leader><Leader> :<C-U>update<CR>
-- xnoremap <Leader><Leader> <Esc>:<C-U>update<CR>gv

-- gets the git history of the visual selection
-- map(
--   'v',
--   '<leader>l',
--   ":<c-u>exe ':term git log -L' line(\"'<\").','.line(\"'>\").':'.expand('%')<CR>",
--   silentnoremap
-- )


-- vim.keymap.set('v', 'YOUR_MAPPING', [[y`>pgv:norm gcc<CR>`>j^]], { noremap = true, silent = true })
-- M.comment_yank_paste = function()
-- 	local win = api.nvim_get_current_win()
-- 	local cur = api.nvim_win_get_cursor(win)
-- 	local vstart = fn.getpos("v")[2]
-- 	local current_line = fn.line(".")
-- 	if vstart == current_line then
-- 		cmd.yank()
-- 		require("Comment.api").toggle.linewise.current()
-- 		cmd.put()
-- 		set_cur(win, { cur[1] + 1, cur[2] })
-- 	else
-- 		if vstart < current_line then
-- 			cmd(":" .. vstart .. "," .. current_line .. "y")
-- 			cmd.put()
-- 			set_cur(win, { fn.line("."), cur[2] })
-- 		else
-- 			cmd(":" .. current_line .. "," .. vstart .. "y")
-- 			set_cur(win, { vstart, cur[2] })
-- 			cmd.put()
-- 			set_cur(win, { fn.line("."), cur[2] })
-- 		end
-- 		require("Comment.api").toggle.linewise(fn.visualmode())
-- 	end
-- end
-- Shift-F5
map('n', '<F17>', '<cmd>MundoToggle<cr>', {
  plugin = 'mundo',
  category = 'UI',
  desc = '  toggle mundo undo',
})

map('n', '<F6>', '<cmd>TSPlaygroundToggle<cr>', {
  category = 'UI',
  plugin = 'treesitter.nvim',
  desc = '  toggle treesitter playground',
})

-- Shift-F6
map('n', '<F18>', '<cmd>InspectTree<cr>', {
  category = 'UI',
  plugin = 'treesitter.nvim',
  desc = '  toggle inspect treesitter',
})

--------------------------------------------------------------------------------------------------
-- QUICKFIX --------------------------------------------------------------------------------------

map('n', '<C-q>', '<cmd>lua require"qf".toggle("c", true)<CR>', {
  category = 'Quickfix',
  label = '  togggle quickfix',
  desc = '  togggle quickfix window',
})
-- nnoremap <leader>j <cmd>lua require'qf'.below('l')<CR> " Go to next location list entry from cursor
-- nnoremap <leader>J <cmd>lua require'qf'.below('c')<CR> " Go to next quickfix entry from cursor
-- nnoremap ]q <cmd>lua require'qf'.below('visible')<CR>
map('n', '<M-lt>', '<cmd>cprev<cr>', {
  category = '  Quickfix prev',
  label = '  quickfix prev',
})

map('n', '<M->>', '<cmd>cnext<cr>', {
  category = '  Quickfix next',
  label = '  quickfix next',
})


--------------------------------------------------------------------------------------------------
-- WINDOWS ---------------------------------------------------------------------------------------

vmap('n', '<c-j>', {
  category = 'Window',
  label = ' window down 󰁆',
  desc = ' move to window below 󰁆',
})

vmap('n', '<c-k>', {
  category = 'Window',
  label = ' window up',
  desc = ' move to window 󰁞',
})

vmap('n', '<c-h>', {
  category = 'Window',
  label = ' window left',
  desc = ' move to window left',
})

vmap('n', '<c-l>', {
  category = 'Window',
  label = ' window right',
  desc = ' move to window right',
})

vmap('n', '<c-w>o', {
  category = 'Window',
  label = ' close other windows',
  desc = ' close other windows except current',
})

map('n', '<M-o>', '<c-w>o', {
  category = 'Window',
  label = ' close other windows',
  desc = ' close other windows except current',
})

vmap('n', '<C-w>x', {
  category = 'Window',
  label = ' swap windows',
  desc = ' swap windows',
})

vmap('n', '<c-w>+', {
  category = 'Window',
  label = ' window +height',
  desc = ' increase height of focused window',
})

vmap('n', '<c-w>-', {
  category = 'Window',
  label = ' window -height',
  desc = ' decrease height of focused window',
})

-- actually map to reverse direction to be compatible with indent motions
vmap('n', '<c-w><', {
  category = 'Window',
  label = ' window +width',
  desc = ' increase width of focused window',
})

-- actually map to reverse direction to be compatible with indent motions
vmap('n', '<c-w>>', {
  category = 'Window',
  label = ' window -width',
  desc = ' decrease width of focused window',
})

vmap('n', '<c-w>=', {
  category = 'Window',
  label = ' windows even',
  desc = ' resize windows evenly',
})

map('n', '<leader>=', '<c-w>=', {
  category = 'Window',
  label = ' windows even',
  desc = ' resize windows evenly',
})

map('n', '<M-w>', '<cmd>set wrap!<cr>', {
  category = 'Windows',
  desc = ' toggle word wrap',
})

vmap('n', '<c-w>w', {
  category = 'Window',
  label = ' window next',
  desc = ' focus the next window',
})

vmap('n', '<c-w>W', {
  category = 'Window',
  label = ' window prev',
  desc = ' focus the previous window',
})

map('n', '<leader>;', '<c-w>w', {
  category = 'Window',
  label = ' window next',
  desc = ' focus the next window',
})

map({ 'n' }, '<leader><leader>', "<c-w>W", {
  category = 'Pickers',
  label = ' window prev',
  desc = ' focus the prev window',
})

map('n', '<leader>:', '<c-w>W', {
  category = 'Window',
  label = ' window prev',
  desc = ' focus the previous window',
})

map({'n', 'x'}, '<C-Tab>', '<c-w>w', {
  category = 'Window',
  label = 'window next',
  desc = ' focus the next window',
})

map({'n', 'x'}, '<C-S-Tab>', '<c-w>W', {
  category = 'Window',
  label = 'window prev ',
  desc = ' focus the prev window',
})

map({'i'}, '<C-Tab>', '<c-o><c-w>w', {
  category = 'Window',
  label = 'window next',
  desc = ' focus the next window',
})

map({'i'}, '<C-S-Tab>', '<c-o><c-w>W', {
  category = 'Window',
  label = 'window prev ',
  desc = ' focus the prev window',
})

map('n', '<leader>v', '<cmd>vnew<cr>', {
  category = 'Window',
  label = ' window split-h',
  desc = ' window split horizontally',
})

map('n', '<leader>s', '<cmd>new<cr>', {
  category = 'Window',
  label = ' window split-v',
  desc = ' window split vertically',
})

map({ "n" }, "<C-w><C-CR>", "<cmd>lua require('commands.ui').smart_win_split()<cr>", { desc = " smart window split" })

-- TODO: switch _ and | and make thme toggleable
map('n', '_', function()
  local winid = vim.api.nvim_get_current_win()
  local win_max = vim.api.nvim_get_option_value('lines', {
    scope = 'global'
  }) - vim.api.nvim_win_get_height(winid) < vim.api.nvim_get_option_value('winheight', { scope = 'global'  })
  if win_max then
    vim.cmd('wincmd =')
  else
    vim.cmd('wincmd _')
  end
end, {
    category = 'Window',
    label = ' toggle max h-split height',
    desc = ' toggle max height of vertical split',
  })

vmap('n', '<c-w>_', {
  category = 'Window',
  label = ' max v-split height',
  desc = ' maximize height of vertical split',
})

map('n', '<leader>_', '<c-w>_', {
  category = 'Window',
  label = ' max v-split height',
  desc = ' maximize height of vertical split',
})

map('n', '|', function()
  local winid = vim.api.nvim_get_current_win()
  local win_max = vim.api.nvim_get_option_value('columns', {
   scope = 'global'
  }) - vim.api.nvim_win_get_width(winid) < vim.api.nvim_get_option_value('winwidth', { scope = 'global' })
  if win_max then
    vim.cmd('wincmd =')
  else
    vim.cmd('wincmd |')
  end
end, {
  category = 'Window',
  label = ' toggle max v-split width',
  desc = ' toggle max width of horizontal split',
})

vmap('n', '<c-w>|', {
  category = 'Window',
  label = ' max h-split width',
  desc = ' maximize width of horizontal split',
})

map('n', '<leader>|', '<c-w>|', {
  category = 'Window',
  label = ' max h-split width',
  desc = ' maximize width of horizontal split',
})

-- map('n', '<M-S-Right>', '<cmd>wincmd l<cr>', {
--   category = 'Window',
--   label = ' select right window',
--   desc = ' move to right window',
-- })

-- map('n', '<M-S-Left>', '<cmd>wincmd h<cr>', {
--   category = 'Window',
--   label = ' select left window',
--   desc = ' move to left window',
-- })
-- map('n', '<M-S-Down>', '<cmd>wincmd j<cr>', {
--   category = 'Window',
--   label = ' select down window',
--   desc = ' move to bottom  window',
-- })

-- map('n', '<M-S-Up>', '<cmd>wincmd k<cr>', {
--   category = 'Window',
--   label = ' select up window',
--   desc = ' move to up window',
-- })

map('n', '<leader>q', '<cmd>silent! tabclose | Sayonara<cr>', {
  category = 'Window',
  label = ' close window',
  desc = ' close window smartly wih sayonara',
})

map('n', '<leader>clc', '<cmd>set conceallevel=0<cr>', {
  category = 'Window',
  label = '󰈉 conceal clear',
  desc = '󰈉 clear all concealing from window',
})

map('n', '<leader>cl0', '<cmd>set conceallevel=0<cr>', {
  category = 'Window',
  label = '󰈉 set conceal 0',
  desc = '󰈉 set conceal level of window to 0',
})

map('n', '<leader>cl1', '<cmd>set conceallevel=1<cr>', {
  category = 'Window',
  label = '󰈉 set conceal 1',
  desc = '󰈉 set conceal level of window to 1',
})

map('n', '<leader>cl2', '<cmd>set conceallevel=2<cr>', {
  category = 'Window',
  label = '󰈉 set conceal 2',
  desc = '󰈉 set conceal level of window to 2',
})

map('n', '<leader>cl3', '<cmd>set conceallevel=3<cr>', {
  category = 'Window',
  label = '󰈉 set conceal 3',
  desc = '󰈉 set conceal level of window to 3',
})

--------------------------------------------------------------------------------------------------
-- TREESITTER ------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
-- OTHER UI ---------------------------------------------------------------------------------------

map('n', '<M-C-Y>', '<cmd>ChatGPT<cr>', {
  category = 'Other UI',
  plugin = 'neo-ai',
  label = 'toggle chatgpt',
  desc = 'toggle chatgpt',
})
--
map('n', '<C-y>', '<cmd>NeoAI<cr>', {
  category = 'Other UI',
  plugin = 'neo-ai',
  label = 'toggle the side panel of neo ai',
  desc = 'toggle the side panel of neo ai',
})

map('n', '<M-y>', '<cmd>NeoAIToggle<cr>', {
  category = 'Other UI',
  plugin = 'neo-ai',
  label = 'toggle the side panel of neo ai',
  desc = 'toggle the side panel of neo ai',
})

map('n', '<C-p>', "<cmd>lua require('telescope.run')('builtin', 'find_files')<cr>", {
  category = 'Other UI',
  plugin = 'telescope.nvim',
  label = 'files project',
  desc = 'find files in project telescope',
})

map('n', '<C-\\>', "<cmd>lua require('telescope.run')('fd_cwd')<cr>", {
  category = 'Other UI',
  plugin = 'telescope.nvim',
  label = 'files curr dir',
  desc = 'find files in current directory telescope',
})

-- map('n', '<M-Bslash>', '<cmd>lua require("oil").toggle_float()<cr>', {
--   plugin = 'oil.nvim',
--   desc = 'toggle oil file manager',
-- })
map('n', '<M-Bslash>', '<cmd>MiniFiles<cr>', {
  plugin = 'minifiles',
  category = 'Other UI',
  desc = 'toggle minifiles file manager',
})

--------------------------------------------------------------------------------------------------
-- PICKERS ---------------------------------------------------------------------------------------

-- TODO: why does this not work? <cmd>lua require('oil').open_float<cr>
-- map('n', '-', require("oil").toggle_float, {
--   plugin = 'oil.nvim',
--   category = 'Pickers',
--   desc = 'toggle oil file manager',
-- })
-- vim.keymap.set('n', '-', require('oil').open_float, { desc = 'Open parent directory' })

map('n', '<C-g>', "<cmd>lua require('telescope.run')('leaderf', { theme = 'dropdown' })<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'buffers',
  desc = 'buffers in telescope',
})

-- map('n', '<C-t>', "<cmd>lua require('telescope.run')('builtin','diagnostics')<cr>", {
--   category = 'Pickers',
--   plugin = 'telescope.nvim',
--   label = 'frecency files',
--   desc = 'frecency files in telescope',
-- })

map('n', '<C-u>', "<cmd>lua require('telescope.run')('frecency','frecency')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'frecency files',
  desc = 'frecency files in telescope',
})

map('n', '<M-C-Space>', '<cmd>Navbuddy<cr>', {
  category = 'LSP',
  plugin = 'nvim-navbuddy',
  label = 'navbuddy',
  desc = 'explore symbols with navbuddy',
})

map('n', '<C-e>', "<cmd>lua require('telescope.run')('egrepify','egrepify', { grep_open_files = true })<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'grep buffers',
  desc = 'live grep open buffers in telescope',
})


map('n', '<M-e>', "<cmd>lua require('telescope.run')('egrepify','egrepify')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'grep project',
  desc = 'live grep project in telescope',
})

map('n', '<M-u>', "<cmd>lua require('telescope.run')('oldfiles', 'oldfiles')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'mru files',
  desc = 'mru files in telescope',
})

-- ^[[105;5u
 -- :map <YourKeyCombination> <C-v>uXXXX

map('n', '<M-i>', "<cmd>lua require('telescope.run')('messages', 'messages')<cr>", {
  category = 'Pickers',
  plugin = 'notify.nvim',
  label = 'notifications',
  desc = 'notifications in telescope',
})

-- map('n', '<M-space>', "<cmd>lua require('telescope.run')('builtin','grep_string', { theme = 'ivy' })<cr>", {
--   category = 'Pickers',
--   plugin = 'telescope.nvim',
--   label = 'grep cursor',
--   desc = 'grep string under cursor in telescope',
-- })

map('n', '<M-/>', "<cmd>lua require('telescope.run')('builtin','help_tags', { theme = 'ivy', preview = true })<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'helptags',
  desc = 'helptags in telescope',
})

map('n', '<M-?>', "<cmd>lua require('telescope.run')('builtin','help_tags', { theme = 'ivy', preview = true })<cr>", {
    category = 'Pickers',
    plugin = 'telescope.nvim',
    label = 'helptags',
    desc = 'helptags in telescope',
  })

map('n', '<M-g>', "<cmd>lua require('telescope.run')('projects','projects')<cr>", {
  category = 'Pickers',
  plugin = 'projects_nvim',
  label = 'find projects',
  desc = 'find projects telescope',
})

map({ 'n' }, '<C-Space>', "<cmd>lua require('telescope.run')('find_pickers','find_pickers')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'find pickers',
  desc = 'find pickers in telescope',
})



map({ 'n' }, '<leader><space>', "<cmd>lua Snacks.picker.pickers()<cr>", {
  category = 'Pickers',
  plugin = 'snacks.nvim',
  label = 'snacks pickers',
  desc = 'find pickers in snacks',
})

-- map({ 'n' }, '<M-,>', "<cmd>lua require('configs.telescope.actions.picker-history').prev_picker()<cr>", {
map({ 'n' }, '<M-,>', "<cmd>lua require('telescope.run')('builtin','resume', { cache_direction = prev })<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'find pickers',
  desc = 'find pickers in telescope',
})


map({ 'n' }, '<M-.>', "<cmd>lua require('telescope.run')('builtin','resume', { cache_direction = next })<cr>", {
    category = 'Pickers',
    plugin = 'telescope.nvim',
    label = 'find pickers',
    desc = 'find pickers in telescope',
  })

-- lua require('configs.telescope.actions').prev_picker()
--------------------------------------------------------------------------------------------------
-- GIT -------------------------------------------------------------------------------------------
-- TODO: add precheck function to ensure in git dir

map('n', '<leader>gf', "<cmd>require('telescope.run')('builtin', 'git_files')<cr>", {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = '󰊢 git files',
  desc = '󰊢 show git files in telescope',
})

map('n', '<leader>gb', "<cmd>require('telescope.run')('builtin', 'git_files')<cr>", {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = '󰊢 git branches',
  desc = '󰊢 show git branches in telescope',
})

map('n', '<leader>gs', "<cmd>require('telescope.run')('builtin', 'git_files')<cr>", {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = '󰊢 git status',
  desc = '󰊢 show git status in telescope',
})

map('n', '<leader>gc', "<cmd>require('telescope.run')('builtin', 'git_commits')<cr>", {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = '󰊢 git commits',
  desc = '󰊢 show git commits in telescope',
})

map('n', '<leader>gC', "<cmd>require('telescope.run')('builtin', 'git_bcommits')<cr>", {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = '󰊢 git bcommits',
  desc = '󰊢 show git bcommits in telescope',
})

map('n', '<leader>gn', '<cmd>Gitsigns next_hunk<cr>', {
  category = 'Git',
  plugin = 'gitsigns.nvim',
  label = '󰊢 go next hunk',
  desc = '󰊢 go to next git hunk (gitsigns.nvim)',
})

map('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<cr>', {
  category = 'Git',
  plugin = 'gitsigns.nvim',
  label = '󰊢 go prev hunk',
  desc = '󰊢 go to previous git hunk (gitsigns.nvim)',
})

map('n', '<leader>gv', '<cmd>Gitsigns preview_hunk<cr>', {
  category = 'Git',
  label = '󰊢 git preview hunk',
  desc = '󰊢 preview git hunk (gitsigns.nvim)',
})

map('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', {
  category = 'Git',
  label = '󰊢 git reset hunk',
  desc = '󰊢 reset git hunk (gitsigns.nvim)',
})

map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', {
  category = 'Git',
  label = '󰊢 git reset buffer',
  desc = '󰊢 reset git buffer (gitsigns.nvim)',
})

--------------------------------------------------------------------------------------------------
-- FORMAT ----------------------------------------------------------------------------------------

map('n', 'gtf', 'gq', {
  category = 'Format',
  label = '󰉶 format',
  desc = '󰉶 format operator',
})

map('n', 'gtF', 'gw', {
  category = 'Format',
  label = '󰉶 format restore',
  desc = '󰉶 format operator with cursor restore',
})

-- map('n', 'gq', '<nop>')
-- map('n', 'gw', '<nop>')

-- Delete trailing stuff
map('n', '<leader>d', '<cmd>normal! mz$x`z<CR>', { desc = '󱎘 Delete char at EoL' })

map('n', '<leader>[', '`[V`]<', {
  category = 'Format',
  label = '󰉶 indent all lines',
  desc = '󰉶 indent all lines',
})

map('n', '<leader>]', ' `[V`]>', {
  category = 'Format',
  label = '󰉶 unindent all lines',
  desc = '󰉶 unindent all lines',
})

map('x', '<', '<gv', {
  category = 'Format',
  label = '󰉶 unindent',
  desc = '󰉶 unindent repeatedly',
})

map('x', '>', '>gv', {
  category = 'Format',
  label = '󰉶 indent',
  desc = '󰉶 indent repeatedly',
})

-- map('n', '<', '<<', {
--   category = 'Format',
--   label = '󰉶 unindent',
--   desc = '󰉶 unindent repeatedly',
-- })

-- map('n', '>', '>>', {
--   category = 'Format',
--   label = '󰉶 indent',
--   desc = '󰉶 indent repeatedly',
-- })

map({ 'n' }, '<M-;>', '<cmd>ISwapNodeWith<cr>', {
  category = 'Format',
  label = '易swap node with',
  desc = '易swap/exchange node objects with',
  plugin = 'iswap.nvim',
})

--------------------------------------------------------------------------------------------------
-- PAIRS -----------------------------------------------------------------------------------------

map('n', ']a', '<cmd>execute ":" . v:count . "next"<CR>', {
  category = 'Pairs',
  desc = 'execute next argument ',
})

map('n', '[a', '<cmd>execute ":" . v:count . "previous"<CR>', {
  category = 'Pairs',
  desc = 'execute prev argument ',
})

--------------------------------------------------------------------------------------------------
-- TERMINAL --------------------------------------------------------------------------------------

map('t', '<C-w><C-q>', '<C-\\><C-n>', {
  category = 'Terminal',
  desc = 'terminal exit',
})
map('t', '<C-w><C-h>', '<C-\\><C-n><C-w>h', {
  category = 'Terminal',
  desc = 'terminal navigate left',
})
map('t', '<C-w><C-j>', '<C-\\><C-n>C-w>j', {
  category = 'Terminal',
  desc = 'terminal navigate down',
})
map('t', '<C-w><C-k>', '<C-\\><C-n>C-w>k', {
  category = 'Terminal',
  desc = 'terminal navigate up',
})
map('t', '<C-w><C-l>', '<C-\\><C-n>C-w>l', {
  category = 'Terminal',
  desc = 'terminal navigate right',
})

--------------------------------------------------------------------------------------------------
-- HOVER -----------------------------------------------------------------------------------------

vmap('n', 'g<C-g>', {
  category = 'Hover',
  label =  ' words/lines count',
  desc = ' show current and total characters, words, bytes and lines',
})

map('n', 'gha', '<cmd>ascii<cr>', {
  category = 'Hover',
  label = ' ascii cursor',
  desc = ' show ascii under cursor',
})

map('n', 'ghh', '<cmd>Inspect<cr>', {
  category = 'Hover',
  label = ' highlights cursor',
  desc = ' show highlights under cursor',
})

map('n', 'ghH', '<cmd>InspectSticky<cr>', {
  category = 'Hover',
  label = ' highlights sticky',
  desc = ' sticky highlights under cursor',
})

map('n', 'ghw', 'g<C-g>', {
  category = 'Hover',
  label = ' wordcount cursor',
  desc = ' show wordcount under cursor',
})

map('n', 'ght', '<cmd>TSNodeUnderCursor<cr>', {
  category = 'Hover',
  plugin = 'treesitter.nvim',
  label = ' show ts node',
  desc = ' show treesitter node under cursor',
})

map('n', 'ghT', '<cmd>TSHighlightCapturesUnderCursor<cr>', {
  category = 'Hover',
  plugin = 'treesitter.nvim',
  label = ' show ts highlights',
  desc = ' show treesitter highlights under cursor',
})


--------------------------------------------------------------------------------------------------
-- SYSTEM ----------------------------------------------------------------------------------------

map('n', '<leader>ii', '<cmd>ImportStatus<cr>', {
  category = 'System',
  label =  '  import status',
  desc = '  show import status interface',
})

map('n', '<leader>il', '<cmd>Lazy<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = '  lazy.nvim home view',
  desc = '  show lazy.nvim home view',
})

map('n', '<leader>ix', '<cmd>Lazy clean<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = '  lazy.nvim clean plugins',
  desc = '  show lazy.nvim plugin remover',
})

map('n', '<leader>ic', '<cmd>Lazy check<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = '  lazy.nvim check',
  desc = '  show lazy.nvim plugins check',
})

map('n', '<leader>is', '<cmd>Lazy sync<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = '  lazy.nvim sync',
  desc = '  show lazy.nvim plugins sync',
})

map('n', '<leader>io', '<cmd>option<cr>', {
  category = 'System',
  label = '  show options window',
  desc = '  show output of all configured options',
})

map('n', '<leader>ip', '<cmd>Lazy profile<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = '  lazy.nvim profile',
  desc = '  show lazy.nvim plugins profile',
})

map('n', '<leader>it', "<cmd>lua require('telescope.run')('lazy', 'lazy')<cr>", {
  category = 'System',
  plugin = 'lazy.nvim',
  label = '  lazy.nvim telescope',
  desc = '  show lazy.nvim plugins in telescope',
})

map( 'n', '<leader>iy', "<cmd>YankPath<cr>", {
    category = 'System',
    label = '  yank filename',
    desc = '  yank the current filename to clipboard',
  }
)

map('n', '<leader>iY', '<cmd>%y+<CR>', {
  category = 'System',
  label = '  yank buffer',
  desc = '  yank the full buffer to clipboard',
})

map('n', '<leader>if', '<cmd>file<cr>', {
  category = 'System',
  desc = '  print filename in stdout',
  label = '  print filename',
})

map('n', '<leader>iF', "<cmd>lua print(vim.fn.expand('%:p'))<cr>", {
  category = 'System',
  desc = '  print full filename in stdout',
  label = '  print full filename',
})

local pathOfThisFile = debug.getinfo(1).source:sub(2)
map('n', '<leader>ie', function()
  vim.cmd.edit(pathOfThisFile)
end, { desc = '⌨️ Edit ' .. vim.fs.basename(pathOfThisFile) })

-- open new scope / brace
-- map({ 'i' }, 'g{', function()
--   require('funcs.quality-of-life').openNewScope()
-- end, { desc = ' Open new scope' })

map({ 'n' }, 'g{', function()
  require('funcs.quality-of-life').openNewScope()
end, { desc = ' Open new scope' })

--------------------------------------------------------------------------------

-- stats, additional debugging info
-- map("n", "<leader>iF", "", {
--   category = "System",
--   desc = "display filename in notification",
--   label = "notify filename",
-- })

-- flit.nvim can do things like `ds`, `cs`, `ys` which allow to pre-visualize the text-object on which you're going to operate.
-- This is the vim-way, I think.

local map_textobjects = function()
  local textobjRemaps = {
    c = '}', -- [c]urly brace
    r = ']', -- [r]ectangular bracket
    m = 'W', -- [m]assive word
    q = '"', -- [q]uote
    z = "'", -- [z]ingle quote
    e = '`', -- t[e]mplate string / inline cod[e]
  }

  local textobjMaps = {
    func = 'f', -- [f]unction
    cond = 'o', -- c[o]nditional
    call = 'l', -- cal[l]
    wikilink = 'R', -- two [R]ectangular brackets
    codeblock = 'E', -- Markdown codeblock (uppercase of e for `)
  }

  -- remapping of builtin text objects
  for remap, original in pairs(u.textobjRemaps) do
    keymap({ 'o', 'x' }, 'i' .. remap, 'i' .. original, { desc = '󱡔 inner ' .. original })
    keymap({ 'o', 'x' }, 'a' .. remap, 'a' .. original, { desc = '󱡔 outer ' .. original })
  end

  -- special remaps
  keymap('o', 'k', 'i"', { desc = '󱡔 inner quote' })
  keymap('o', 'J', '2j') -- dj = delete 2 lines, dJ = delete 3 lines
end
