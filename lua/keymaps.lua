local mapper = require('mapper')
local map = mapper.map
local vmap = mapper.vmap
local prefix = mapper.prefix

--       况  ﱔ    ﮝ  ﬠ ﬡ ײַ יִ       בּ 易

prefix('n', 'z', 'folds 󰘖 ')
prefix('n', 'g', 'go ײַ ')
prefix('n', 'gh', 'hover  ')
prefix('n', 'gt', 'text-case  ')
prefix('n', 'gq', 'quickfix  ')
prefix('n', 'gP', 'preview  ')
prefix('n', 'go', 'debug out  ')
prefix('n', ']', 'next 怜')
prefix('n', '[', 'previous 玲')

--         
-- prefix('n', '<c-w>', 'window')
prefix('n', '<leader>g', 'git 󰊢')
prefix('n', '<leader>f', 'file ')
prefix('n', '<leader>p', 'paste ')
prefix('n', '<leader>i', 'internal  ')
prefix('n', '<leader>u', 'undo 󰕌')
prefix('n', '<leader>cl', 'conceal 󰈉 ')

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
-- nmap cg* *Ncgn
-- -- Make the last change as an initiation for cgn.
-- vim.keymap.set("n", "g.", [[/\V<C-r>"<CR>cgn<C-a><Esc>]])
--------------------------------------------------------------------------------------------------

-- COMMAND ---------------------------------------------------------------------------------------
-- -- change local working directory
-- keymap('n', '<leader>cd', ':lcd %:h<CR>', opts)
--
-- Copy Last Command
-- keymap("n", "<leader>lc", function()
-- 	local lastCommand = fn.getreg(":"):gsub("^lua[ =]*", "")
-- 	fn.setreg("+", lastCommand)
-- 	u.notify("Copied", lastCommand)
-- end, { desc = "󰘳 Copy last command" })
--
-- -- show current filetype & buftype
-- keymap("n", "<leader>lf", function()
-- 	local out = {
-- 		"filetype: " .. bo.filetype,
-- 		"buftype: " .. bo.buftype,
-- 		("indent: %s (%s)"):format(bo.expandtab and "spaces" or "tabs", bo.tabstop),
-- 	}
-- 	local ok, node = pcall(vim.treesitter.get_node)
-- 	if ok and node then table.insert(out, "node: " .. node:type()) end
-- 	u.notify("Buffer Information", table.concat(out, "\n"), "trace")
-- end, { desc = " Buffer Info" })

-- TODO: differentiate between vim/lua, auto remove comments

map({ 'v' }, '<space>', '"xy:@x<cr>', {
  category = 'Command',
  label = ' execute selected',
  desc = ' execute selected lines',
})

map({ 'n', 'v' }, ';', ':', {
  category = 'Command',
  label = ' open cmdline',
  desc = ' open the command line',
  nowait = true,
})

map({ 'n', 'v' }, ':', 'q:', {
  category = 'Command',
  label = ' open cmdwin',
  desc = ' open the command window',
  nowait = true,
  silent = true,
})

map({ 'n', 'v' }, '<M-:>', 'q:', {
  category = 'Command',
  realkeys = '<C-S-;>',
  silent = true,
  label = ' open cmdwin',
  desc = ' open the command window',
})

vmap({ 'c' }, '<C-T>', {
  category = 'Command',
  label = ' open cmdwin',
  desc = ' open the command window',
})

map('c', '<M-b>', '<C-T><Esc>', {
  category = 'Command',
  label = ' open cmdwin normal',
  desc = ' open command window from the command line in normal mode',
})

map('c', '<M-f>', '<C-T><Esc>', {
  category = 'Command',
  label = ' open cmdwin normal',
  desc = ' open command window from the command line in normal mode',
})

map('c', '<c-d>', '<C-c>', {
  category = 'Command',
  label = ' close cmdline',
  desc = ' close the command line',
})

map('c', '<c-s>', '<cmd>silent! w<cr><esc>', {
  category = 'Command',
  label = ' save cmdline',
  desc = ' save in command line',
  silent = true,
})

map('c', '<c-y>', '<c-r>*', {
  category = 'Command',
  label = ' yank cmdline',
  desc = ' yank from command line',
})

map('c', '<C-^>', '<Home>', {
  category = 'Command',
  label = ' goto start cmdline',
  desc = ' go to beginning of command line',
})

--  c-$
map('c', '<C-\\>', '<End>', {
  category = 'Command',
  label = ' goto end cmdline ',
  desc = ' go to end of command line',
})

-- map('c', '<M-p>', '<S-Up>', {
--   category = 'Command',
--   label = ' history up cmdline',
--   desc = ' navigate history up command line',
-- })
--
-- --  c-$
-- map('c', '<M-n>', '<S-Down>', {
--   category = 'Command',
--   label = ' history down cmdline',
--   desc = ' navigate history down command line',
-- })
--
map('c', '<C-g>', '<C-r>%', {
  category = 'Command',
  label = ' insert filename cmdline',
  desc = ' insert filename into the command line',
})

--------------------------------------------------------------------------------------------------
-- BUFFERS ---------------------------------------------------------------------------------------

map({ 'n', 'x', 'i' }, '<C-d>', function()
  -- require('funcs.alt-alt').betterClose()
  require('commands.ui').close_multi()
end, { desc = '󰽙 close buffer/window' })

-- -- COMMENTS
map('n', 'gch', function()
  require('funcs.quality-of-life').commentHr()
end, { desc = '  horizontal divider' })

-- TODO: enable visual selection
map({ 'x' }, 'gC', function()
  require('funcs.quality-of-life').duplicateAsComment()
end, { desc = '  duplicate line as comment' })

map({ 'n' }, 'gcC', function()
  require('funcs.quality-of-life').duplicateAsComment()
end, { desc = '  duplicate line as comment' })

map({ 'n' }, 'gc<space>', function()
  require('funcs.quality-of-life').duplicateAsComment()
end, { desc = '  duplicate line as comment' })
--
-- Jump history
-- non-unique, since it overwrites nvim default: https://neovim.io/doc/user/vim_diff.html#default-mappings
-- keymap("n", "<C-l>", "<C-i>", { desc = "󱋿 Jump forward", unique = false })
-- keymap("n", "<C-h>", "<C-o>", { desc = "󱋿 Jump back" })

map('n', '<CR>', '<cmd>lua require("funcs.alt-alt").gotoAltBuffer()<cr>', {
  label = '󰽙 goto alt-buffer',
  desc = '󰽙 goto alternative/last buffer',
})

map('n', '<BS>', '<cmd>e #<cr>', {
  category = 'Buffers',
  label = '󰽙 last buffer',
  desc = '󰽙 open the last buffer',
  silent = true,
})
local bufvar = { { '<Plug>(CybuPrev)', '<Plug>(CybuNext)' }, { '<cmd>BufferPrev<cr>', '<cmd>BufferNext<cr>' } }

map({ 'n' }, '<leader>fs', '<cmd>lua vim.treesitter.get_parser(0):parse()<cr>', {
  category = 'Buffers',
  label = '󰽙 reset treesitter highlighting',
})

map('n', 'H', bufvar[2][1], {
  category = 'Buffers',
  label = '󰽙 left buffer',
  desc = '󰽙 open the left (prev) buffer',
})

map('n', 'L', bufvar[2][2], {
  category = 'Buffers',
  label = '󰽙 right buffer',
  desc = '󰽙 open the right (next) buffer',
})

map('n', '<leader>!', '<cmd>BufferCloseAllButCurrent<cr>', {
  category = 'Buffers',
  label = '󰽙 close other bufs',
  desc = '󰽙 close all buffers except current',
})

map({ 'n', 's', 'v', 'i' }, '<C-s>', '<cmd>silent! w<cr><esc>', {
  category = 'Buffers',
  label = '󰽙 write buffer',
  desc = '󰽙 write to buffer',
  silent = true,
})

map('n', '<leader>*', '<cmd>wall<cr>', {
  category = 'Buffers',
  label = '󰽙 write all',
  silent = true,

  desc = '󰽙 write all buffers',
})

map('n', '<leader>w', '<cmd>noa w<cr>', {
  category = 'Buffers',
  label = '󰽙 write noa',
  desc = '󰽙 write without autocommands',
  silent = true,
})

map('n', '<leader>D', '<cmd>BufferDelete<cr>', {
  category = 'Buffers',
  label = '󰽙 delete buffer',
  desc = '󰽙 delete buffer without closing window',
})

-- map('n', '<S-Space>', '"_caw', { desc = '󱡔 change word' })
-- map('n', '<S-Space>', '"_daw', { desc = '󱡔 delete word' })
map('i', '<M-BS>', '<Esc>cvb', {
  category = 'Buffers',
  desc = '󰽙 delete previous word',
  silent = true,
})

-- TODO: multiple category Buffers, Windows
map('n', '<C-d>', '<cmd>CloseMulti<cr>', {
  category = 'Buffers',
  label = '󰽙 close multi',
  desc = '󰽙 close tabpage, window, or buffer in that order',
})

map('n', '<M-d>', '<cmd>CloseMultiNoPrompt<cr>', {
  category = 'Buffers',
  label = '󰽙 close multi noprompt',
  desc = '󰽙 close tabpage, window, or buffer without prompting for save',
})
map('n', '<M-w>', '<cmd>set wrap!<cr>', {
  category = 'Buffers',
  label = '󰽙 toggle wrap',
  desc = '󰽙 toggle word wrap',
})

map('n', '<leader><space>', '<C-^>', {
  category = 'Buffers',
  desc = '󰽙 switch to last buffer',
})

map('n', '<leader>fn', [[:e <C-R>=expand("%:p:h") . "/" <CR>]], {
  category = 'Buffers',
  label = '󰽙 new file in cwd',
  desc = '󰽙 create new file in current directory',
})

map('n', '<leader>fn', [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], {
  category = 'Buffers',
  label = '󰽙 new file h-split',
  desc = '󰽙 create new file in a horizontal split',
})

map('n', '<leader>fp', "<cmd>echo expand('%:p')<CR>", {
  category = 'Buffers',
  label = '󰽙 print path',
  desc = '󰽙 print path of current buffer',
})

map('n', 'gf', '/"\\|\'<cr>hgF', {
  silent = true,
  category = 'Buffers',
  label = '󰽙 goto file',
  desc = '󰽙 open file under cursor',
})

vmap('n', 'gF', {
  silent = true,
  category = 'Buffers',
  label = '󰽙 goto file:num',
  desc = '󰽙 open file:num under cursor ',
})

map('n', '<leader>cd', '<cmd>cd %:h<cr>', {
  category = 'Buffers',
  label = '󰽙 cd buffer',
  desc = '󰽙 change current working directory to buffer directory',
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
-- -- Append to / delete from EoL
-- local trailChars = { ",", ";", ")", "'", '"', "|", "\\", "{", ".", "}" }
-- for _, key in pairs(trailChars) do
--   keymap("n", "<leader>" .. key, "mzA" .. key .. "<Esc>`z", { desc = "which_key_ignore" })
-- end
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

map('n', '<leader>ur', function()
  vim.cmd('silent later ' .. tostring(vim.opt.undolevels:get()))
end, { desc = '󰛒 redo All' })

-- save open time for each buffer
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    vim.b.timeOpened = os.time()
  end,
})
map({ 'n', 'x' }, '<leader>uc', function()
  require('funcs.alt-alt').reopenBuffer()
end, { desc = '󰽙 undo buffer closing' })

map({ 'n', 'x' }, '<leader>ul', '<cmd>undolist<cr>', { desc = '󰽙 undo show list' })

-- -- undo 0, earlier 5m, earlier 1h, later 5h, later 1f (file writes later)
-- map('i', ',', ',<c-g>u', { category = 'Buffers', desc = 'add undo at ,' })
-- map('i', '.', '.<c-g>u', { category = 'Buffers', desc = 'add undo at .' })

map('n', '<leader>uo', function()
  local now = os.time()
  local secsPassed = now - vim.b.timeOpened
  vim.cmd.earlier(tostring(secsPassed) .. 's')
end, { desc = '󰜊 Undo since last open' })

-- stylua: ignore start
--
--------------------------------------------------------------------------------------------------
-- MACROS ---------------------------------------------------------------------------------------

-- Taking from here: https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
-- function! ExecuteMacroOverVisualRange()
--   echo "@".getcmdline()
--   execute ":'<,'>normal @".nr2char(getchar())
-- endfunction
map('x', '@', ':<C-u>echo "@".getcmdline() | execute ":\'<,\'>normal @" . nr2char(getchar())<CR>', {
  category = 'Macros',
  desc = 'allows running macros only on selected files',
})

map('x', '.', ':normal .<CR>', {
  category = 'Macros',
  desc = 'dot repeat macro',
})
--------------------------------------------------------------------------------------------------
-- EXITING ---------------------------------------------------------------------------------------

map('n', '<C-X>', '<cmd>silent! tabclose | qa<cr>', {
  category = 'Exiting',
  label = 'exit save',
  desc = 'quick exit with prompt for save',
})

map('n', '<M-C-X>', '<cmd>silent! tabclose | xa<cr>', {
  category = 'Exiting',
  label = 'exit nosave',
  desc = 'quick exit without saving',
})

--------------------------------------------------------------------------------------------------
-- EXECUTE ---------------------------------------------------------------------------------------

map('n', '!@', '<cmd>@:<cr>', {
  category = 'Execute',
  label = 'repeat ex-command',
  desc = 'repeat the last command',
})

map('n', '!~', '<cmd>RunSelect<cr>', {
  category = 'Execute',
  label = 'select runner task',
  desc = 'assign task to runner',
})

map('n', '!!', '<cmd>Run<cr>', {
  category = 'Execute',
  label = 'repeat runner command',
  desc = 'execute configured runner task',
})

map('n', '<M-r>', '<cmd>Restart<cr>', {
  category = 'Execute',
  label = 'restart',
  desc = 'restart neovim instance',
})

map('n', '<M-!>', '<cmd>RestartTarget<cr>', {
  category = 'Execute',
  label = 'restart target',
  desc = 'restart target of remote neovim instannce',
})

vmap('n', 'gx', {
  category = 'Execute',
  label = 'xdg-open file',
  desc = 'open file with xdg-open under cursor',
})

--------------------------------------------------------------------------------------------------
-- MOTION ----------------------------------------------------------------------------------------
-- vim.keymap.set("x", "C", function()
--     vim.api.nvim_input('y/"<CR>Ncgn')
-- end, { silent = true })
-- nmap cg* *Ncgn
-- -- Make the last change as an initiation for cgn.
-- vim.keymap.set("n", "g.", [[/\V<C-r>"<CR>cgn<C-a><Esc>]])

-- map('n', 'gn', "g#<cmd>lua require('hlslens').start()<cr>", {
--   category = 'Motion',
--   plugin = 'hlslens',
--   label = 'prev search',
--   desc = 'next matching from previous search (hls lens)',
-- })

map('n', '<leader>R', '*:%s//', {
  category = 'Motion',
  label = 'replace cursor word',
  desc = 'search and replace word under cursor',
})

-- map("i", "jk", "<esc>", {
--   category = "Motion",
--   label = "insert mode escape",
--   desc = "quickly escape insert mode",
-- })

map('i', 'kj', '<esc>', {
  category = 'Motion',
  label = 'insert mode escape',
  desc = 'quickly escape insert mode',
})

map('n', 'D', 'd$', {
  category = 'Motion',
  label = 'delete to end',
  desc = 'delete to end of line',
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

map('n', '<c-b>', '<Plug>(SmoothieBackwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  label = 'scroll backwards',
  desc = 'smoothie scroll backwards',
  noremap = false,
})

map('n', '<PageUp>', '<Plug>(SmoothieBackwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  label = 'scroll backwards',
  desc = 'smoothie page-up scroll backwards',
  noremap = false,
})

map('n', '<c-f>', '<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  label = 'scroll forwards',
  desc = 'smoothie scroll forwards',
  noremap = false,
})

map('n', '<PageDown>', '<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  label = 'scroll forwards',
  desc = 'smoothie page-down scroll forwards',
  noremap = false,
})

map('n', '<space>', '<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)<Plug>(SmoothieDownwards)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  label = 'scroll forwards x2',
  desc = 'smoothie scroll forwards x2',
  noremap = false,
})

map('n', 'G', '<Plug>(Smoothie_G)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  label = 'scroll bottom',
  desc = 'smoothie scroll to bottom',
  noremap = false,
})

map('n', 'gg', '<Plug>(Smoothie_gg)', {
  category = 'Motion',
  plugin = 'vim-smoothie',
  label = 'scroll top',
  desc = 'smoothie scroll to top',
  noremap = false,
})

-- todo: why do i ahve to rebind this
map('i', '<C-D>', '<cmd>norm d$<cr>', {
  category = 'Motion',
  label = 'delete to eol',
  desc = 'delete until the end of line',
})

map('n', 'gp', '`[v`]', {
  category = 'Motion',
  label = 'select last visual',
  desc = 'select last visual block afrom bracket marks',
})

vmap('n', 'gi', {
  category = 'Motion',
  label = 'goto last insert',
  desc = 'goto last mark of insertion',
})

vmap('n', 'gI', {
  category = 'Motion',
  label = 'goto begin insert',
  desc = 'goto beginning mark of insertion',
})

vmap('n', 'gv', {
  category = 'Motion',
  label = 'select last visual',
  desc = 'select last visual block afrom bracket marks',
})

map('i', '<esc>', '<Esc>`^', {
  category = 'Motion',
  desc = 'convenience cursor placement after insert',
  silent = true,
})

map({ 'n', 'v' }, "<M-;>", '<cmd>HopLineStart<cr>', {
  category = 'Motion',
  plugin = 'hop.nvim',
  label = 'hop to line',
  desc = 'hop to line',
})

map({ 'n', 'v' }, "<M-'>", '<cmd>HopWord<cr>', {
  category = 'Motion',
  plugin = 'hop.nvim',
  label = 'hop to word',
  desc = 'hop to word',
})

map('n', 'gV', '"`[" . strpart(getregtype(), 0, 1) . "`]"', {
  category = 'Motion',
  label = 'select changed text',
  desc = 're-select latest changed, put, or yanked text',
  expr = true,
})

--  -- Search inside visually highlighted text. Use `silent = false` for it to
--  -- make effect immediately.
--  map('x', 'g/', '<esc>/\\%V', { silent = false, desc = 'Search inside visual selection' })
--  -- Search visually selected text (slightly better than builtins in Neovim>=0.8)
--  map('x', '*', [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
--  map('x', '#', [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

map('i', '<c-f>', '<Esc>ea', {
  category = 'Motion',
  label = 'jump over word',
  desc = 'jump over word while staying in insert mode',
})

map('n', 'U', '', {
  category = 'Motion',
  label = 'disable line undo',
  desc = 'disable line undo so it can prefix other commands',
})

map('n', 'U', '<c-r>', {
  category = 'Motion',
  label = 'asssign line undo',
  desc = 'assign line undo',
})

map({ 'n' }, "<M-BS>", '<cmd>pop<cr>', {
  category = 'Motion',
  desc = 'jump to previous tag',
})

vmap({ 'n' }, "<C-]>",  {
  category = 'Motion',
  desc = 'jump to next tag',
})

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

-- nnoremap U <nop>
-- nnoremap US :Gstatus<cr>
-- nnoremap UY :Gpull<cr>
-- nnoremap UP :Gpush<cr>
-- nnoremap UD :Gdiff<cr>
-- nnoremap UB :Gblame -w<cr>
-- nnoremap UE :Gedit<cr>

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

-- TODO: google searching
-- vim.api.nvim_set_keymap("n", "<C-q>", "", { silent = true, noremap = true })
-- local searching_google_in_normal = [[:lua fn.system({'open', 'https://google.com/search?q=' .. vim.fn.expand("<cword>")})<CR>]]
-- local searching_google_in_visual = [[<ESC>gv"gy<ESC>:lua fn.system({'open', 'https://google.com/search?q=' .. vim.fn.getreg('g')})<CR>]]
-- vim.api.nvim_set_keymap("n", "<C-q><C-g>", searching_google_in_normal, { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("v", "<C-q><C-g>", searching_google_in_visual, { silent = true, noremap = true })

--------------------------------------------------------------------------------------------------
-- UI --------------------------------------------------------------------------------------------

vmap('n', 'g<C-G>', {
  category = 'UI',
  label = 'ascii cursor',
  desc = 'show ascii under cursor',
})

vmap('n', 'g<C-g>', {
  category = 'UI',
  label = 'words/lines count',
  desc = 'show current and total characters, words, bytes and lines',
})

map('n', '_', '<cmd>noh<cr> | <cmd>nohlsearch<cr> | <cmd>LspRestart<cr>', {
  category = 'UI',
  desc = 'remove highlights and refresh',
})

map(
  'n',
  '<M-c>',
  '<cmd>noh<cr> | <cmd>nohlsearch<cr> | <cmd>ClosePopups<cr> | <cmd>LspRestart<cr>',
  { category = 'UI', desc = 'remove hls, close popups and refresh' }
)

map(
  'n',
  '<M-->',
  '<cmd>noh<cr> | <cmd>nohlsearch<cr> | <cmd>ClosePopups<cr> | <cmd>LspRestart<cr>',
  { category = 'UI', desc = 'remove hls, close popups and refresh' }
)


-- map('n', '<M-b>', "<cmd>noh<cr> | <cmd>only<cr> | :RefreshLSP<cr> | :lua require'feline'.reset_highlights()<cr>", {
--   category = 'UI',
--   desc = 'remove hls, refresh colors and lsp',
-- })

-- map('n', '<M-C-_>', '<cmd>only<cr> | <cmd>ClosePopups<cr> | <cmd>diffupdate<cr> |  <cmd>normal! <C-L><cr>', {
--   category = 'UI',
--   desc = 'close all other windows',
-- })
-- map('n', '<C-c>', '<cmd>only<cr> | <cmd>ClosePopups<cr> | <cmd>diffupdate<cr> | <cmd>normal! <C-L><cr>', {
--   category = 'UI',
--   desc = 'close all other windows',
-- })
map('n', '<F1>', "<cmd>lua require('telescope.run')('builtin', 'help_tags')<cr>", {
  plugin = 'telescope.nvim',
  category = 'UI',
  desc = 'toggle help',
})

map('n', '<F2>', '<cmd>WhichKey<cr>', {
  plugin = 'which-key.nvim',
  category = 'UI',
  desc = 'toggle whichkey',
})
-- ctrl+shift F2
map('n', '<F38>', '<Leader>Wk', {
  plugin = 'wf.nvim',
  category = 'UI',
  desc = 'toggle wf.nvim',
})

map('n', '<F3>', '<cmd>AerialToggle!float<cr>', {
  plugin = 'aerial.nvim',
  category = 'UI',
  desc = 'toggle aerial sidebar',
})

map('n', '<F4>', '<cmd>Neotree show toggle<cr>', {
  plugin = 'neo-tree',
  category = 'UI',
  desc = 'toggle neotree',
})

-- ctrl+shift+f4
map('n', '<F40>', '<cmd>lua require("oil").open_float<cr>', {
  plugin = 'oil.nvim',
  category = 'UI',
  desc = 'toggle oil file manager',
})

map('n', '<F5>', "<cmd>lua require('telescope.run')('undo', 'undo')<cr>", {
  plugin = 'telescope.nvim',
  category = 'UI',
  desc = 'toggle telescope undo',
})

-- Shift-F5
map('n', '<F17>', '<cmd>MundoToggle<cr>', {
  plugin = 'mundo',
  category = 'UI',
  desc = 'toggle mundo undo',
})

map('n', '<F6>', '<cmd>TSPlaygroundToggle<cr>', {
  category = 'UI',
  plugin = 'treesitter.nvim',
  desc = 'toggle treesitter playground',
})

-- Shift-F6
map('n', '<F18>', '<cmd>InspectTree<cr>', {
  category = 'UI',
  plugin = 'treesitter.nvim',
  desc = 'toggle inspect treesitter',
})

--------------------------------------------------------------------------------------------------
-- QUICKFIX --------------------------------------------------------------------------------------

map('n', '<C-c>', '<cmd>lua require"qf".toggle("c", true)<CR>', {
  category = 'Quickfix',
  label = 'togggle quickfix',
  desc = 'togggle quickfix window',
})
-- nnoremap <leader>j <cmd>lua require'qf'.below('l')<CR> " Go to next location list entry from cursor
-- nnoremap <leader>J <cmd>lua require'qf'.below('c')<CR> " Go to next quickfix entry from cursor
-- nnoremap ]q <cmd>lua require'qf'.below('visible')<CR>
map('n', '<M-lt>', '<cmd>cprev<cr>', {
  category = 'Quickfix prev',
  label = 'quickfix prev',
})

map('n', '<M->>', '<cmd>cnext<cr>', {
  category = 'Quickfix next',
  label = 'quickfix next',
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

vmap('n', '<c-w><', {
  category = 'Window',
  label = ' window +width',
  desc = ' increase width of focused window',
})

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

vmap('n', '<c-w>W', {
  category = 'Window',
  label = ' window prev',
  desc = ' focus the previous window',
})
map('n', '<leader>:', '<c-w>W', {
  category = 'Window',
  label = ' window prev',
  desc = ' focus the previous window',
})

vmap('n', '<c-w>w', {
  category = 'Window',
  label = ' window next',
  desc = ' focus the next window',
})
map('n', '<leader>;', '<c-w>w', {
  category = 'Window',
  label = ' window next',
  desc = ' focus the next window',
})

-- map('n', '<Tab>', '<c-w>w', {
--   category = 'Window',
--   label = 'window next',
--   desc = ' focus the next window',
-- })
--
-- map('n', '<S-Tab>', '<c-w>W', {
--   category = 'Window',
--   label = 'window prev ',
--   desc = ' focus the prev window',
-- })

map('n', '<leader>H', '<cmd>vnew<cr>', {
  category = 'Window',
  label = ' window split-h',
  desc = ' window split horizontally',
})

map('n', '<leader>V', '<cmd>new<cr>', {
  category = 'Window',
  label = ' window split-v',
  desc = ' window split vertically',
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

-- vmap('x', '<tab>', {
--   category = 'Treesitter',
--   plugin = 'treesitter.nvim',
--   label = 'incsel scope expand',
--   desc = 'scope incremental selection',
-- })
--
-- vmap('x', '<cr>', {
--   category = 'Treesitter',
--   plugin = 'treesitter.nvim',
--   label = 'incsel expand',
--   desc = 'incremental selection expand',
-- })
--
-- vmap('x', '<s-tab>', {
--   category = 'Treesitter',
--   plugin = 'treesitter.nvim',
--   label = 'incsel shrink',
--   desc = 'incremental selection shrink',
-- })

vmap('n', 'g0', {
  category = 'Treesitter',
  plugin = 'treesitter.nvim',
  label = 'list ts toc',
  desc = 'list treesitter table of contents definitions',
})

--------------------------------------------------------------------------------------------------
-- PICKERS ---------------------------------------------------------------------------------------

map('n', '<C-p>', "<cmd>lua require('telescope.run')('builtin', 'find_files')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'files project',
  desc = 'find files in project telescope',
})

map('n', '<C-\\>', "<cmd>lua require('telescope.run')('fd_cwd')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'files curr dir',
  desc = 'find files in current directory telescope',
})

-- map('n', '<M-Bslash>', '<cmd>lua require("oil").toggle_float()<cr>', {
--   plugin = 'oil.nvim',
--   category = 'UI',
--   desc = 'toggle oil file manager',
-- })
map('n', '<M-Bslash>', '<cmd>MiniFiles<cr>', {
  plugin = 'minifiles',
  category = 'UI',
  desc = 'toggle minifiles file manager',
})

-- TODO: why does this not work? <cmd>lua require('oil').open_float<cr>
map('n', '-', require("oil").toggle_float, {
  plugin = 'oil.nvim',
  category = 'UI',
  desc = 'toggle oil file manager',
})
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

map('n', '<C-e>', "<cmd>lua require('telescope.run')('builtin','live_grep', { grep_open_files = true })<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'grep buffers',
  desc = 'live grep open buffers in telescope',
})

map('n', '<M-u>', "<cmd>lua require('telescope.run')('oldfiles', 'oldfiles')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'mru files',
  desc = 'mru files in telescope',
})

map('n', '<M-i>', "<cmd>lua require('telescope.run')('messages', 'messages')<cr>", {
  category = 'Pickers',
  plugin = 'notify.nvim',
  label = 'notifications',
  desc = 'notifications in telescope',
})

map('n', '<M-space>', "<cmd>lua require('telescope.run')('builtin','grep_string', { theme = 'ivy' })<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'grep cursor',
  desc = 'grep string under cursor in telescope',
})

map('n', '<M-/>', "<cmd>lua require('telescope.run')('builtin','help_tags', { cursor = true })<cr>", {
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

map({ 'n', 'x' }, '<C-Space>', "<cmd>lua require('telescope.run')('find_pickers','find_pickers')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'repeat telescope',
  desc = 'repeast last telescope command',
})

-- lua require('configs.telescope.actions').prev_picker()
-- <cmd>lua require('telescope.run')('builtin','resume', { cache_direction = next })<cr>
map({ 'n', 'x' }, '<leader><leader>', "<cmd>lua require('telescope.run')('builtin','resume', { cache_direction = 'prev' })<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'find pickers',
  desc = 'find pickers in telescope',
})

map('n', '<M-e>', "<cmd>lua require('telescope.run')('builtin','live_grep')<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'grep project',
  desc = 'live grep project in telescope',
})

map('n', '<M-y>', '<cmd>ChatGPT<cr>', {
  category = 'Pickers',
  plugin = 'neo-ai',
  label = 'toggle chatgpt',
  desc = 'toggle chatgpt',
})
--
map('n', '<C-y>', '<cmd>NeoAI<cr>', {
  category = 'Pickers',
  plugin = 'neo-ai',
  label = 'toggle the side panel of neo ai',
  desc = 'toggle the side panel of neo ai',
})
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

map('n', '<leader>gc', '', {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = '󰊢 git commits',
  desc = '󰊢 show git commits in telescope',
})

map('n', '<leader>gC', '', {
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

-- Delete trailing stuff
-- (wrapping in normal avoids temporarily scrolling to the side)
map('n', 'X', '<cmd>normal!mz$x`z<CR>', { desc = '󱎘 Delete char at EoL' })

vmap('v', 'U', {
  category = 'Format',
  label = 'uppercase word',
  desc = 'format uppercase word',
})

vmap('v', 'u', {
  category = 'Format',
  label = 'lowercase word',
  desc = 'format lowercase word',
})

-- vmap('n', 'gu', {
--   category = 'Format',
--   label = 'format lowercase',
--   desc = 'format lowercase word',
-- })
--
-- vmap('n', 'gU', {
--   category = 'Format',
--   label = 'format uppsercase',
--   desc = 'format uppercase word',
-- })

map('n', '<leader>[', '`[V`]<', {
  category = 'Format',
  label = '󰉶 indent all lines',
  desc = '󰉶 indent all lines',
})

map('n', '<leader>]', '', {
  category = 'Format',
  label = '󰉶 unindent all lines',
  desc = '󰉶 unindent all lines',
})

-- map('x', '<', '<gv', {
--   category = 'Format',
--   label = '󰉶 unindent',
--   desc = '󰉶 unindent repeatedly',
-- })
--
-- map('x', '>', '>gv', {
--   category = 'Format',
--   label = '󰉶 indent',
--   desc = '󰉶 indent repeatedly',
-- })
--
map('n', 'g>', '<cmd>ISwapNodeWith<cr>', {
  category = 'Format',
  label = '易swap node with',
  desc = '易swap/exchange node objects with',
  plugin = 'iswap.nvim',
})

-- TODO: allow range
map({ 'v', 'n' }, '<M-">', '<esc><cmd>ISwapNodeWith<cr>', {
  category = 'Format',
  label = '易swap node with',
  desc = '易swap/exchange node objects with',
  plugin = 'iswap.nvim',
})

--------------------------------------------------------------------------------------------------
-- PAIRS -----------------------------------------------------------------------------------------

map('n', ']a', ':execute ":" . v:count . "next"<CR>', {
  category = 'Pairs',
  desc = 'execute next argument ',
})
map('n', '[a', ':execute ":" . v:count . "previous"<CR>', {
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

map('n', 'ght', '<cmd>TSHighlightCapturesUnderCursor<cr>', {
  category = 'Hover',
  plugin = 'treesitter.nvim',
  label = ' show ts highlights',
  desc = ' show treesitter highlights under cursor',
})

map('n', 'ghn', '<cmd>TSNodeUnderCursor<cr>', {
  category = 'Hover',
  plugin = 'treesitter.nvim',
  label = ' show ts node',
  desc = ' show treesitter node under cursor',
})
--------------------------------------------------------------------------------------------------
-- SYSTEM ----------------------------------------------------------------------------------------

map('n', '<leader>ii', '<cmd>ImportStatus<cr>', {
  category = 'System',
  label = 'import status',
  desc = 'show import status interface',
})

map('n', '<leader>il', '<cmd>Lazy<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = 'lazy.nvim home view',
  desc = 'show lazy.nvim home view',
})

map('n', '<leader>ix', '<cmd>Lazy clean<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = 'lazy.nvim clean plugins',
  desc = 'show lazy.nvim plugin remover',
})

map('n', '<leader>ic', '<cmd>Lazy check<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = 'lazy.nvim check',
  desc = 'show lazy.nvim plugins check',
})

map('n', '<leader>is', '<cmd>Lazy sync<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = 'lazy.nvim sync',
  desc = 'show lazy.nvim plugins sync',
})

map('n', '<leader>io', '<cmd>option<cr>', {
  category = 'System',
  label = 'show options window',
  desc = 'show output of all configured options',
})

map('n', '<leader>ip', '<cmd>Lazy profile<cr>', {
  category = 'System',
  plugin = 'lazy.nvim',
  label = 'lazy.nvim profile',
  desc = 'show lazy.nvim plugins profile',
})

map('n', '<leader>it', "<cmd>lua require('telescope.run')('lazy', 'lazy')<cr>", {
  category = 'System',
  plugin = 'lazy.nvim',
  label = 'lazy.nvim telescope',
  desc = 'show lazy.nvim plugins in telescope',
})

map( 'n', '<leader>iy', "<cmd>YankPath<cr>", {
    category = 'System',
    label = 'yank filename',
    desc = 'yank the current filename to clipboard',
  }
)

map('n', '<leader>iY', ':%y+<CR>', {
  category = 'System',
  label = 'yank buffer',
  desc = 'yank the full buffer to clipboard',
})

map('n', '<leader>if', '<cmd>file<cr>', {
  category = 'System',
  desc = 'print filename in stdout',
  label = 'print filename',
})

map('n', '<leader>iF', "<cmd>lua print(vim.fn.expand('%:p'))<cr>", {
  category = 'System',
  desc = 'print full filename in stdout',
  label = 'print full filename',
})

local pathOfThisFile = debug.getinfo(1).source:sub(2)
map('n', '<leader>ie', function()
  vim.cmd.edit(pathOfThisFile)
end, { desc = '⌨️ Edit ' .. vim.fs.basename(pathOfThisFile) })

-- open new scope / brace
map({ 'n', 'i' }, 'g{', function()
  require('funcs.quality-of-life').openNewScope()
end, { desc = ' Open new scope' })

--------------------------------------------------------------------------------
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

-- stats, additional debugging info
-- map("n", "<leader>iF", "", {
--   category = "System",
--   desc = "display filename in notification",
--   label = "notify filename",
-- })

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
