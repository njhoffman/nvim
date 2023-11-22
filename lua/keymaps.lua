local mapper = require('mapper')
local map = mapper.map
local vmap = mapper.vmap
local prefix = mapper.prefix

vim.cmd([[
  cabbrev T Telescope
  cabbrev D lua vim.dbg(
]])

prefix('n', 'z', 'folds')
prefix('n', 'g', 'goto')
prefix('n', 'gq', 'quickfix')
prefix('n', 'gP', 'preview')
prefix('n', 'g?', 'debug print')
-- prefix('n', '<c-w>', 'window')
prefix('n', '<leader>g', 'git')
prefix('n', '<leader>f', 'file')
prefix('n', '<leader>F', 'format')
prefix('n', '<leader>p', 'paste')
prefix('n', '<leader>i', 'internal tools')
prefix('n', '<leader>cl', 'conceal')

-- vim.cmd([[nnoremap <C-l> :syntax sync fromstart<CR>:redraw<CR>]])

-- ["]"] = { name = "+next" },
-- ["["] = { name = "+prev" },
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
-- vim.keymap.set("n", "cn", "*``cgn")
-- vim.keymap.set("x", "C", function()
--     vim.api.nvim_input('y/"<CR>Ncgn')
-- end, { silent = true })
--
-- -- Make the last change as an initiation for cgn.
-- vim.keymap.set("n", "g.", [[/\V<C-r>"<CR>cgn<C-a><Esc>]])
--------------------------------------------------------------------------------------------------
-- COMMAND ---------------------------------------------------------------------------------------
-- TODO: differentiate between vim/lua, auto remove comments

map({ 'v' }, '<space>', '"xy:@x<cr>', {
  category = 'Command',
  label = 'execute selected',
  desc = 'execute selected lines',
})

map({ 'n', 'v' }, ';', ':', {
  category = 'Command',
  label = 'open cmdline',
  desc = 'open the command line',
  nowait = true,
})

map({ 'n', 'v' }, ':', 'q:', {
  category = 'Command',
  label = 'open cmdwin',
  desc = 'open the command window',
  nowait = true,
})

map({ 'n', 'v' }, '<M-;>', 'q:', {
  category = 'Command',
  label = 'open cmdwin',
  desc = 'open the command window',
})

-- map({ 'c' }, '<M-f>', '<C-T>', {
--   category = 'Command',
--   label = 'open cmdwin',
--   desc = 'open the command window',
-- })

vmap({ 'c' }, '<C-T>', {
  category = 'Command',
  label = 'open cmdwin',
  desc = 'open the command window',
})

map('c', '<M-b>', '<C-T><Esc>', {
  category = 'Command',
  label = 'open cmdwin normal',
  desc = 'open command window from the command line in normal mode',
})

map('c', '<c-d>', '<C-c>', {
  category = 'Command',
  label = 'close cmdline',
  desc = 'close the commandline',
})

-- -		The cursor position is unchanged, except when the cursor was
-- 		at the end of the line, then it stays at the end.
-- 		|setcmdpos()| can be used to set the cursor position.
-- 		The |sandbox| is used for evaluating the expression to avoid
-- 		nasty side effects.
-- 	- :cmap <F7> <C-\>eAppendSome()<CR>
-- :func AppendSome()
--    :let cmd = getcmdline() .. " Some()"
--    :" place the cursor on the )
--    :call setcmdpos(strlen(cmd))
--    :return cmd
-- :endfunc
-- map("c", "<c-[>", "<esc>", {
--   category = "Command",
--   label = "close cmdline",
--   desc = "close the commandline",
-- })

map('c', '<c-s>', '<cmd>silent! w<cr><esc>', {
  category = 'Command',
  label = 'save',
  silent = true,
  desc = 'save in command window',
})

map('c', '<c-y>', '<c-r>*', {
  category = 'Command',
  label = 'yank',
  desc = 'yank from command window',
})

map('c', '<C-^>', '<Home>', {
  category = 'Command',
  label = 'goto start',
  desc = 'go to beginning of command line',
})

--  c-$
map('c', '<C-\\>', '<End>', {
  category = 'Command',
  label = 'goto start',
  desc = 'go to end of command line',
})

map('c', '<M-p>', '<S-Up>', {
  category = 'Command',
  label = 'navigate history up',
})

--  c-$
map('c', '<M-n>', '<S-Down>', {
  category = 'Command',
  label = 'navigate history down',
})

map('c', '<M-g>', '<C-r>%', {
  category = 'Command',
  label = 'insert filename',
  desc = 'insert filename into the command line',
})

--------------------------------------------------------------------------------------------------
-- BUFFERS ---------------------------------------------------------------------------------------

map('n', '<BS>', '<cmd>e #<cr>', {
  category = 'Buffers',
  silent = true,
  label = 'last buffer',
  desc = 'open the last buffer',
})
local bufvar = { { '<Plug>(CybuPrev)', '<Plug>(CybuNext)' }, { '<cmd>BufferPrev<cr>', '<cmd>BufferNext<cr>' } }

map({ 'n' }, 'E', '<cmd>lua vim.treesitter.get_parser(0):parse()<cr>', {
  category = 'Buffers',
  label = 'reset buffer highlighting',
})

map('n', 'H', bufvar[2][1], {
  category = 'Buffers',
  label = 'left buffer',
  desc = 'open the left (prev) buffer',
})

map('n', 'L', bufvar[2][2], {
  category = 'Buffers',
  label = 'right buffer',
  desc = 'open the right (next) buffer',
})

map('n', '<leader>!', '<cmd>BufferCloseAllButCurrent<cr>', {
  category = 'Buffers',
  label = 'close other bufs',
  desc = 'close all buffers except current',
})

map({ 'n', 's', 'v', 'i' }, '<C-s>', '<cmd>silent! w<cr><esc>', {
  category = 'Buffers',
  label = 'write buffer',
  silent = true,

  desc = 'write to buffer',
})

map('n', '<leader>*', '<cmd>wall<cr>', {
  category = 'Buffers',
  label = 'write all',
  silent = true,

  desc = 'write all buffers',
})

map('n', '<leader>w', '<cmd>noa w<cr>', {
  category = 'Buffers',
  label = 'write noa',
  silent = true,
  desc = 'write without autocommands',
})

map('n', '<leader>D', '<cmd>BufferDelete<cr>', {
  category = 'Buffers',
  label = 'delete buffer',
  desc = 'delete buffer without closing window',
})

map('i', '<M-BS>', '<Esc>cvb', {
  category = 'Buffers',
  desc = 'delete previous word',
}, { silent = true })

-- TODO: multiple category Buffers, Windows
map('n', '<C-d>', '<cmd>CloseMulti<cr>', {
  category = 'Buffers',
  label = 'close multi',
  desc = 'close tabpage, window, or buffer in that order',
})

map('n', '<M-d>', '<cmd>CloseMultiNoPrompt<cr>', {
  category = 'Buffers',
  label = 'close multi noprompt',
  desc = 'close tabpage, window, or buffer without prompting for save',
})
map('n', '<M-w>', '<cmd>set wrap!<cr>', {
  category = 'Buffers',
  label = 'toggle wrap',
  desc = 'toggle word wrap',
})

-- map('n', '<leader>m', [[:call AltCommand(expand('%'), ':e')<cr>]], {
--   category = 'Buffers',
--   label = 'open alt file',
--   desc = 'open alternative file associated with buffer',
-- })

map('n', '<leader><space>', '<C-^>', {
  category = 'Buffers',
  desc = 'switch to last buffer',
})

map('n', '<leader>fn', [[:e <C-R>=expand("%:p:h") . "/" <CR>]], {
  category = 'Buffers',
  label = 'new in cwd',
  desc = 'create new file in current directory',
})

map('n', '<leader>fn', [[:vsp <C-R>=expand("%:p:h") . "/" <CR>]], {
  category = 'Buffers',
  label = 'new file h-split',
  desc = 'create new file in a horizontal split',
})

map('n', '<leader>fp', "<cmd>pfn :echo expand('%:p')<CR>", {
  category = 'Buffers',
  label = 'print path',
  desc = 'print path of current buffer',
})

map('n', 'gf', '/"\\|\'<cr>hgF', {
  silent = true,
  category = 'Buffers',
  label = 'goto file',
  desc = 'open file under cursor',
})

vmap('n', 'gF', {
  silent = true,
  category = 'Buffers',
  label = 'goto file:num',
  desc = 'open file:num under cursor ',
})

map('n', '<leader>cd', '<cmd>cd %:h<cr>', {
  category = 'Buffers',
  label = 'cd buffer',
  desc = 'change current working directory to buffer directory',
})

-- undo 0, earlier 5m, earlier 1h, later 5h, later 1f (file writes later)

map('i', ',', ',<c-g>u', {
  category = 'Buffers',
  desc = 'add undo at ,',
})
map('i', '.', '.<c-g>u', {
  category = 'Buffers',
  desc = 'add undo at .',
})

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

map('n', '!~', '<cmd>@:<cr>', {
  category = 'Execute',
  label = 'repeat command',
  desc = 'repeat the last command',
})

map('n', '!@', '<cmd>RunSelect<cr>', {
  category = 'Execute',
  label = 'select runner task',
  desc = 'assign task to runner',
})

map('n', '!!', '<cmd>Run<cr>', {
  category = 'Execute',
  label = 'repeat command',
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

vmap('n', '', {
  category = 'Motion',
  label = 'xdg-open file',
  desc = 'open file with xdg-open under cursor',
})

-- map('n', '<cr>', 'ciw', {
--   category = 'Motion',
--   desc = 'enter insert mode and change word',
-- })

map('n', 'gn', "g#<cmd>lua require('hlslens').start()<cr>", {
  category = 'Motion',
  plugin = 'hlslens',
  label = 'prev search',
  desc = 'next matching from previous search (hls lens)',
})

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

map('x', 'y', 'ygv<esc>', {
  category = 'Motion',
  desc = 'yank maintaining cursor',
  silent = true,
})

map('n', 'yil', 'v0o$y', {
  category = 'Motion',
  label = 'yank in line',
  desc = 'yank in line',
  silent = true,
})

-- map('o', 'yil', '<cmd>normal yy<cr>', {
--   category = 'Motion',
--   label = 'yank in line',
--   desc = 'yank in line',
--   silent = true,
-- })

map('n', 'yy', 'mQ0y$`Q', {
  category = 'Motion',
  label = 'yank in line no eol',
  desc = 'yank in line no eol',
})

map('n', 'yY', '<cmd>normal vil<CR>', {
  category = 'Motion',
  label = 'yank in line',
  desc = 'yank in line',
})

-- map('n', 'P', '"*p', {
--   category = 'Motion',
--   label = 'paste clipboard',
--   desc = 'paste system clipboard register',
-- })

map('n', '<leader>pp', '"*p', {
  category = 'Motion',
  label = 'paste primary',
  desc = 'paste primary register',
})

map('n', '<leader>pc', '<cmd>normal p`[v`]gc<cr>', {
  category = 'Motion',
  label = 'paste comment',
  desc = 'paste as a comment',
})
map('n', 'gcp', '<cmd>normal p`[v`]gc<cr>', {
  category = 'Motion',
  label = 'paste comment',
  desc = 'paste as a comment',
})

map('n', '<leader>pm', '<cmd>set invpaste<cr>', {
  category = 'Motion',
  label = 'toggle paste mode',
  desc = 'toggle paste mode',
})

map({ 'n', 'v' }, "<M-'>", '<cmd>HopWord<cr>', {
  category = 'Motion',
  plugin = 'hop.nvim',
  label = 'hop to word',
  desc = 'hop to word',
})

-- map({ "n", "v" }, "<M-:>", "<cmd>HopLine<cr>", {
--   category = "Motion",
--   plugin = "hop.nvim",
--   label = "hop to line",
--   desc = "hop to line",
-- })

-- local cr_keys = {
--   new_line = '',
--   new_line_below = { 'o<Esc>k', 'add new line below' },
--   save_file = '',
--   pickers = '',
--   -- set('n', '<Plug>(zoom_toggle)', function()
--   --   require('user/zoom').toggle()
--   -- end)
-- }
--
-- local cr_func = function()
--   if vim.bo.filetype == 'qf' then
--     return '<CR>'
--   else
--     return cr_keys.new_line_below[0]
--     -- return '<Plug>(zoom_toggle)'
--   end
-- end
--
-- map('n', '<CR>', cr_func, {
--   category = 'Motion',
--   label = cr_keys.new_line_below[1],
--   expr = true,
-- })

vim.cmd([[
  " nnoremap <expr> <silent> <CR> &buftype ==# "quickfix" ? "\<CR>" : "o\<Esc>k"
]])

map('v', '<C-X>', '<Esc>`.``gvP``P', {
  category = 'Motion',
  label = 'swap visual block',
  desc = 'swap visual selected block with register',
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

map('n', '_', '<cmd>noh<cr> | <cmd>nohlsearch<cr> | <cmd>normal! <C-L><cr>', {
  category = 'UI',
  desc = 'remove highlights and refresh',
})

map(
  'n',
  '<C-_>',
  '<cmd>noh<cr>| <cmd>nohlsearch<cr> | <cmd>ClosePopups<cr> | <cmd>diffupdate<cr> | <cmd>normal! <C-L><cr>',
  {
    category = 'UI',
    desc = 'remove hls, close popups and refresh',
  }
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

map('n', '<M-c>', '<cmd>only<cr> | <cmd>ClosePopups<cr> | <cmd>diffupdate<cr> | <cmd>normal! <C-L><cr>', {
  category = 'UI',
  desc = 'close popups',
})

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

map('n', '<C-c>', '<cmd>QFix<cr>', {
  category = 'Quickfix',
  label = 'togggle quickfix',
  desc = 'togggle quickfix window',
})

map('n', '<M-.>', '<cmd>cnext<cr>', {
  category = 'Quickfix next',
  label = 'quickfix next',
})

map('n', '<M-,>', '<cmd>cprev<cr>', {
  category = 'Quickfix next',
  label = 'quickfix next',
})

--------------------------------------------------------------------------------------------------
-- WINDOWS ---------------------------------------------------------------------------------------

vmap('n', '<c-j>', {
  category = 'Window',
  label = 'window down',
  desc = 'move to window below',
})

vmap('n', '<c-k>', {
  category = 'Window',
  label = 'window up',
  desc = 'move to window up',
})

vmap('n', '<c-h>', {
  category = 'Window',
  label = 'window left',
  desc = 'move to window left',
})

vmap('n', '<c-l>', {
  category = 'Window',
  label = 'window right',
  desc = 'move to window right',
})

vmap('n', '<c-w>o', {
  category = 'Window',
  label = 'close other windows',
  desc = 'close other windows except current',
})

map('n', '<leader>o', '<c-w>o', {
  category = 'Window',
  label = 'close other windows',
  desc = 'close other windows except current',
})

vmap('n', '<C-w>x', {
  category = 'Window',
  label = 'swap windows',
  desc = 'swap windows',
})

vmap('n', '<c-w>+', {
  category = 'Window',
  label = 'window +height',
  desc = 'increase height of focused window',
})

vmap('n', '<c-w>-', {
  category = 'Window',
  label = 'window -height',
  desc = 'decrease height of focused window',
})

vmap('n', '<c-w><', {
  category = 'Window',
  label = 'window +width',
  desc = 'increase width of focused window',
})

vmap('n', '<c-w>>', {
  category = 'Window',
  label = 'window -width',
  desc = 'decrease width of focused window',
})

vmap('n', '<c-w>=', {
  category = 'Window',
  label = 'windows even',
  desc = 'resize windows evenly',
})

map('n', '<leader>=', '<c-w>=', {
  category = 'Window',
  label = 'windows even',
  desc = 'resize windows evenly',
})

vmap('n', '<c-w>W', {
  category = 'Window',
  label = 'window prev',
  desc = 'focus the previous window',
})
map('n', '<leader>:', '<c-w>W', {
  category = 'Window',
  label = 'window prev',
  desc = 'focus the previous window',
})

vmap('n', '<c-w>w', {
  category = 'Window',
  label = 'window next',
  desc = 'focus the next window',
})
map('n', '<leader>;', '<c-w>w', {
  category = 'Window',
  label = 'window next',
  desc = 'focus the next window',
})

map('n', '<Tab>', '<c-w>w', {
  category = 'Window',
  label = 'window next',
  desc = 'focus the next window',
})

map('n', '<S-Tab>', '<c-w>W', {
  category = 'Window',
  label = 'window prev ',
  desc = 'focus the prev window',
})

map('n', '<leader>H', '<cmd>vnew<cr>', {
  category = 'Window',
  label = 'window split-h',
  desc = 'window split horizontally',
})

map('n', '<leader>V', '<cmd>new<cr>', {
  category = 'Window',
  label = 'window split-v',
  desc = 'window split vertically',
})

vmap('n', '<c-w>_', {
  category = 'Window',
  label = 'max vertical split',
  desc = 'maximize height of vertical split',
})

map('n', '<leader>_', '<c-w>_', {
  category = 'Window',
  label = 'max vertical split',
  desc = 'maximize height of vertical split',
})

vmap('n', '<c-w>|', {
  category = 'Window',
  label = 'max horizontal split',
  desc = 'maximize width of horizontal split',
})
map('n', '<leader>|', '<c-w>|', {
  category = 'Window',
  label = 'max horizontal split',
  desc = 'maximize width of horizontal split',
})

map('n', '<leader>q', '<cmd>silent! tabclose | Sayonara<cr>', {
  category = 'Window',
  label = 'close window',
  desc = 'close window smartly wih sayonara',
})

map('n', '<leader>clc', '<cmd>set conceallevel=0<cr>', {
  category = 'Window',
  label = 'conceal clear',
  desc = 'clear all concealing from window',
})

map('n', '<leader>cl0', '<cmd>set conceallevel=0<cr>', {
  category = 'Window',
  label = 'set conceal 0',
  desc = 'set conceal level of window to 0',
})

map('n', '<leader>cl1', '<cmd>set conceallevel=1<cr>', {
  category = 'Window',
  label = 'set conceal 1',
  desc = 'set conceal level of window to 1',
})

map('n', '<leader>cl2', '<cmd>set conceallevel=2<cr>', {
  category = 'Window',
  label = 'set conceal 2',
  desc = 'set conceal level of window to 2',
})

map('n', '<leader>cl3', '<cmd>set conceallevel=3<cr>', {
  category = 'Window',
  label = 'set conceal 3',
  desc = 'set conceal level of window to 3',
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
--
vmap('n', 'gnd', {
  category = 'Treesitter',
  plugin = 'treesitter.nvim',
  label = 'goto ts def',
  desc = 'goto treesitter definition',
})

map('n', 'ght', '<cmd>TSHighlightCapturesUnderCursor<cr>', {
  category = 'Treesitter',
  plugin = 'treesitter.nvim',
  label = 'show ts highlights',
  desc = 'show treesitter highlights under cursor',
})

vmap('n', 'gtd', {
  category = 'Treesitter',
  plugin = 'treesitter.nvim',
  label = 'list ts defs',
  desc = 'list treesitter definitions under cursor',
})

vmap('n', 'g0', {
  category = 'Treesitter',
  plugin = 'treesitter.nvim',
  label = 'list ts toc',
  desc = 'list treesitter table of contents definitions',
})

vmap('n', '<a-*>', {
  category = 'Treesitter',
  plugin = 'treesitter.nvim',
  label = 'ts next',
  desc = 'treesitter next usage',
})

vmap('n', '<a-#>', {
  category = 'Treesitter',
  plugin = 'treesitter.nvim',
  label = 'ts prev',
  desc = 'treesitter previous usage',
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

map('n', '<C-Space>', "<cmd>lua require('telescope.run')('builtin','resume', { cache_direction = next })<cr>", {
  category = 'Pickers',
  plugin = 'telescope.nvim',
  label = 'repeat telescope',
  desc = 'repeast last telescope command',
})

map({ 'n', 'v' }, '<leader><leader>', "<cmd>lua require('telescope.run')('find_pickers','find_pickers')<cr>", {
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
  label = 'git files',
  desc = 'show git files in telescope',
})

map('n', '<leader>gb', "<cmd>require('telescope.run')('builtin', 'git_files')<cr>", {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = 'git branches',
  desc = 'show git branches in telescope',
})

map('n', '<leader>gs', "<cmd>require('telescope.run')('builtin', 'git_files')<cr>", {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = 'git status',
  desc = 'show git status in telescope',
})

map('n', '<leader>gc', '', {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = 'git commits',
  desc = 'show git commits in telescope',
})

map('n', '<leader>gC', '', {
  category = 'Git',
  plugin = 'telescope.nvim',
  label = 'git bcommits',
  desc = 'show git bcommits in telescope',
})

map('n', '<leader>gn', '<cmd>Gitsigns next_hunk<cr>', {
  category = 'Git',
  plugin = 'gitsigns.nvim',
  label = 'go next hunk',
  desc = 'go to next git hunk (gitsigns.nvim)',
})

map('n', '<leader>gp', '<cmd>Gitsigns prev_hunk<cr>', {
  category = 'Git',
  plugin = 'gitsigns.nvim',
  label = 'go prev hunk',
  desc = 'go to previous git hunk (gitsigns.nvim)',
})

map('n', '<leader>gv', '<cmd>Gitsigns preview_hunk<cr>', {
  category = 'Git',
  label = 'git preview hunk',
  desc = 'preview git hunk (gitsigns.nvim)',
})

map('n', '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', {
  category = 'Git',
  label = 'git reset hunk',
  desc = 'reset git hunk (gitsigns.nvim)',
})

map('n', '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', {
  category = 'Git',
  label = 'git reset buffer',
  desc = 'reset git buffer (gitsigns.nvim)',
})

--------------------------------------------------------------------------------------------------
-- FORMAT ----------------------------------------------------------------------------------------

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

vmap('n', 'gu', {
  category = 'Format',
  label = 'format lowercase',
  desc = 'format lowercase word',
})

vmap('n', 'gU', {
  category = 'Format',
  label = 'format uppsercase',
  desc = 'format uppercase word',
})

map('n', '<leader>[', '`[V`]<', {
  category = 'Format',
  label = 'indent all lines',
  desc = 'indent all lines',
})

map('n', '<leader>]', '', {
  category = 'Format',
  label = 'unindent all lines',
  desc = 'unindent all lines',
})

map('v', '<', '<gv', {
  category = 'Format',
  label = 'unindent',
  desc = 'unindent repeatedly',
})

map('v', '>', '>gv', {
  category = 'Format',
  label = 'indent',
  desc = 'indent repeatedly',
})

map('n', '<leader>Fx', '<cmd>ISwapNodeWith<cr>', {
  category = 'Format',
  label = 'swap node with',
  plugin = 'iswap.nvim',
  desc = 'swap/exchange node objects with (iswap.nvim)',
})

-- TODO: allow range
map({ 'v', 'n' }, '<M-">', '<esc><cmd>ISwapNodeWith<cr>', {
  category = 'Format',
  label = 'swap node with',
  plugin = 'iswap.nvim',
  desc = 'swap/exchange node objects with (iswap.nvim)',
})

map('n', '<leader>FU', 'gUw', {
  category = 'Format',
  label = 'uppercase word',
  desc = 'uppercase word',
})
map('n', '<leader>Fu', 'gUw', {
  category = 'Format',
  label = 'lowercase word',
  desc = 'format lowercase word',
})

map({ 'n', 'v' }, '<leader>Fs', '<cmd>Snek<cr>', {
  category = 'Format',
  label = 'format snake',
  desc = 'format snake case',
})

map({ 'n', 'v' }, '<leader>Fk', '<cmd>Kebab<cr>', {
  category = 'Format',
  label = 'format kebab',
  desc = 'format kebab case',
})

map({ 'n', 'v' }, '<leader>Fc', '<cmd>Camel<cr>', {
  category = 'Format',
  label = 'format camel',
  desc = 'format camel case',
})

map({ 'n', 'v' }, '<leader>FC', '<cmd>CamelB<cr>', {
  category = 'Format',
  label = 'format camel b',
  desc = 'format camel b case',
})

--------------------------------------------------------------------------------------------------
-- PAIRS -----------------------------------------------------------------------------------------
vim.cmd([[
  " Section: Put
  function! s:Map(...) abort
    let [mode, head, rhs; rest] = a:000
    let flags = get(rest, 0, '') . (rhs =~# '^<Plug>' ? '' : '<script>')
    let tail = ''
    let keys = get(g:, mode.'remap', {})
    if type(keys) == type({}) && !empty(keys)
      while !empty(head) && len(keys)
        if has_key(keys, head)
          let head = keys[head]
          if empty(head)
            let head = '<skip>'
          endif
          break
        endif
        let tail = matchstr(head, '<[^<>]*>$\|.$') . tail
        let head = substitute(head, '<[^<>]*>$\|.$', '', '')
      endwhile
    endif
    if head !=# '<skip>' && empty(maparg(head.tail, mode))
      return mode.'map ' . flags . ' ' . head.tail . ' ' . rhs
    endif
    return ''
  endfunction

  function! s:putline(how, map) abort
    let [body, type] = [getreg(v:register), getregtype(v:register)]
    if type ==# 'V'
      exe 'normal! "'.v:register.a:how
    else
      call setreg(v:register, body, 'l')
      exe 'normal! "'.v:register.a:how
      call setreg(v:register, body, type)
    endif
    silent! call repeat#set("\<Plug>(unimpaired-put-".a:map.")")
  endfunction

  nnoremap <silent> <Plug>(unimpaired-put-above) :call <SID>putline('[p', 'above')<CR>
  nnoremap <silent> <Plug>(unimpaired-put-below) :call <SID>putline(']p', 'below')<CR>
  nnoremap <silent> <Plug>(unimpaired-put-above-rightward) :<C-U>call <SID>putline(v:count1 . '[p', 'Above')<CR>>']
  nnoremap <silent> <Plug>(unimpaired-put-below-rightward) :<C-U>call <SID>putline(v:count1 . ']p', 'Below')<CR>>']
  nnoremap <silent> <Plug>(unimpaired-put-above-leftward)  :<C-U>call <SID>putline(v:count1 . '[p', 'Above')<CR><']
  nnoremap <silent> <Plug>(unimpaired-put-below-leftward)  :<C-U>call <SID>putline(v:count1 . ']p', 'Below')<CR><']
  nnoremap <silent> <Plug>(unimpaired-put-above-reformat)  :<C-U>call <SID>putline(v:count1 . '[p', 'Above')<CR>=']
  nnoremap <silent> <Plug>(unimpaired-put-below-reformat)  :<C-U>call <SID>putline(v:count1 . ']p', 'Below')<CR>=']
  nnoremap <silent> <Plug>unimpairedPutAbove :call <SID>putline('[p', 'above')<CR>
  nnoremap <silent> <Plug>unimpairedPutBelow :call <SID>putline(']p', 'below')<CR>

  exe s:Map('n', '[p', '<Plug>(unimpaired-put-above)')
  exe s:Map('n', ']p', '<Plug>(unimpaired-put-below)')
  exe s:Map('n', '[P', '<Plug>(unimpaired-put-above)')
  exe s:Map('n', ']P', '<Plug>(unimpaired-put-below)')
  exe s:Map('n', '=P', "<Plug>(unimpaired-put-above-reformat)")
  exe s:Map('n', '=p', "<Plug>(unimpaired-put-below-reformat)")

]])

vmap('n', ']p', {
  category = 'Pairs',
  label = 'paste after indent',
  desc = 'paste after line increasing indent',
})
vmap('n', '[p', {
  category = 'Pairs',
  label = 'paste before indent',
  desc = 'paste before line increasing indent',
})

vmap('n', ']P', {
  category = 'Pairs',
  label = 'paste after unindent',
  desc = 'paste after line decreasing indent',
})

vmap('n', '[P', {
  category = 'Pairs',
  label = 'paste before unindent',
  desc = 'paste before line decreasing indent',
})
vmap('n', '=P', {
  category = 'Pairs',
  label = 'put above and reformat',
  desc = 'paste (put) above and reformat',
})

vmap('n', '=p', {
  category = 'Pairs',
  label = 'put below and reformat',
  desc = 'paste (put) below and reformat',
})

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
prefix('n', 'gh', 'hover')
map('n', 'gha', '<cmd>ascii<cr>', {
  category = 'Hover',
  label = 'ascii cursor',
  desc = 'show ascii under cursor',
})

map('n', 'ghh', '<cmd>Inspect<cr>', {
  category = 'Hover',
  label = 'highlights cursor',
  desc = 'show highlights under cursor',
})

map('n', 'ghH', '<cmd>InspectSticky<cr>', {
  category = 'Hover',
  label = 'highlights sticky',
  desc = 'sticky highlights under cursor',
})

map('n', 'ghw', 'g<C-g>', {
  category = 'Hover',
  label = 'wordcount cursor',
  desc = 'show wordcount under cursor',
})

--------------------------------------------------------------------------------------------------
-- SYSTEM ----------------------------------------------------------------------------------------

prefix('n', 'i', 'system')

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

map(
  'n',
  '<leader>iy',
  "<cmd>let @+ = substitute(expand('%:p'), $HOME, '~', '') | lua print('Yanked: ' .. vim.fn.substitute(vim.fn.expand('%:p'), '$HOME', '~', ''))<cr>",
  {
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

-- stats, additional debugging info
-- map("n", "<leader>iF", "", {
--   category = "System",
--   desc = "display filename in notification",
--   label = "notify filename",
-- })
