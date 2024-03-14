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
-- opt('scrolloff', 0)
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

opt('smoothscroll', true, window)
opt('concealcursor', 'nc', window)
opt('conceallevel', 0, window)
opt('cursorline', true, window)
opt('number', true, window)
opt('relativenumber', true, window)
opt('signcolumn', 'yes:1', window)

opt('textwidth', 100)
opt('shiftwidth', 2)
opt('tabstop', 2)
opt('timeout', true)
opt('shiftwidth', 2)
opt('timeoutlen', 500) -- 1000
opt('ttimeout', true) -- 50
opt('ttimeoutlen', 30) -- 50
opt('undolevels', 2000)
opt('updatetime', 2000) -- 4000
opt('whichwrap', '<,>,[,]') -- 'b,s,<,>,[,],h,l'
opt('virtualedit', 'block') -- onemore, block, insert, all
opt('wildignore', '*.o,*~,*.pyc') -- wildchar     /charm for wildmenu  0x1a ^Z, 0x1b
opt('wildignore', '*.o,*~,*.pyc') -- wildchar	   /charm for wildmenu  0x1a ^Z, 0x1b ^[, 0x0e C-n
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
--[[ vim.opt.listchars:append({
  nbsp = '󰚌',
  precedes = '…',
  extends = '…',
  multispace = '·',
  -- overridden by indent-blankline
  -- tab = '│ ',
  conceal = '?',
  lead = ' ',
  trail = ' ',
})
]]
-- window scope
opt('concealcursor', 'nc', window)
opt('conceallevel', 0, window)
opt('cursorline', true, window)
opt('number', true, window)
opt('relativenumber', true, window)
opt('signcolumn', 'yes:1', window)
opt('spell', false, window)
opt('wrap', false, window)
-- opt('winbar', ' ', window)

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
opt('equalalways', true) -- make windows the samue width when closing one
opt('cursorlineopt', 'both') -- should get cursorline in number too

-- vim.o.guicursor = 'n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor'

-- vim.opt.guicursor = {
--   "i-ci-c:ver25", -- INFO with noice.nvim, the guicursor cannot be styled in the cmdline https://github.com/folke/noice.nvim/issues/552
--   "n-sm:block",
--   "r-cr-o-v:hor10",
--   "a:blinkwait200-blinkoff350-blinkon550",
-- }


-- opt('fillchars', 'eob: ') -- Don't show `~` outside of buffer
vim.opt.fillchars:append({
  eob = ' ',
  fold = ' ',
  vert = '║',
  horiz = '═',
})

-- extra undo-points (= more fine-grained undos)
-- WARN requires `remap = true`, since it otherwise prevents vim abbreviations
-- with those chars from working
-- for _, char in pairs { ".", ",", ";", '"', ":", "'", "<Space>" } do
--   vim.keymap.set("i", char, function()
--     if vim.bo.buftype ~= "" then return char end
--     return char .. "<C-g>u"
--   end, { desc = "󰕌 Extra undopoint for " .. char, remap = true, expr = true })
-- end
--

-- opt.cpoptions:append(">") -- when you yank multiple times into a register, this puts each on a new line
-- opt.nrformats:append("alpha") -- this means you can increment lists that have letters with `g ctrl-a`
-- vim.o.whichwrap = vim.o.whichwrap .. "<,>" -- Wrap movement between lines in edit mode with arrows

-- Enable syntax highlighing if it wasn't already (as it is time consuming)
-- if vim.fn.exists('syntax_on') ~= 1 then
--   vim.cmd([[syntax enable]])
-- end
-- <C-S-Down> <M-NL> <M-C-S-Down>
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
--  map('n', 'gO', 'v:lua.MiniBasics.put_empty_line(v:true)',  { desc = 'Put empty line above', expr = true })
--  map('n', 'go', 'v:lua.MiniBasics.put_empty_line(v:false)', { desc = 'Put empty line below', expr = true })
--
-- M.load_headless_options = function()
--   vim.opt.shortmess = "" -- try to prevent echom from cutting messages off or prompting
--   vim.opt.more = false -- don't pause listing when screen is filled
--   vim.opt.cmdheight = 9999 -- helps avoiding |hit-enter| prompts.
--   vim.opt.columns = 9999 -- set the widest screen possible
--   vim.opt.swapfile = false -- don't use a swap file
-- end
--


		-- set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
		  -- \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
		  -- \,sm:block-blinkwait175-blinkoff150-blinkon175

-- <	The option is a comma-separated list of parts.  Each part consists of a
	-- mode-list and an argument-list:
		-- mode-list:argument-list,mode-list:argument-list,..
	-- The mode-list is a dash separated list of these modes:
		-- n	Normal mode
		-- v	Visual mode
		-- ve	Visual mode with 'selection' "exclusive" (same as 'v',
			-- if not specified)
		-- o	Operator-pending mode
		-- i	Insert mode
		-- r	Replace mode
		-- c	Command-line Normal (append) mode
		-- ci	Command-line Insert mode
		-- cr	Command-line Replace mode
		-- sm	showmatch in Insert mode
		-- a	all modes
	-- The argument-list is a dash separated list of these arguments:
		-- hor{N}	horizontal bar, {N} percent of the character height
		-- ver{N}	vertical bar, {N} percent of the character width
		-- block	block cursor, fills the whole character
			-- - Only one of the above three should be present.
			-- - Default is "block" for each mode.
		-- blinkwait{N}				*cursor-blinking*
		-- blinkon{N}
		-- blinkoff{N}
			-- blink times for cursor: blinkwait is the delay before
			-- the cursor starts blinking, blinkon is the time that
			-- the cursor is shown and blinkoff is the time that the
			-- cursor is not shown.  Times are in msec.  When one of
			-- the numbers is zero, there is no blinking. E.g.: >vim
				-- set guicursor=n:blinkon0
-- <			- Default is "blinkon0" for each mode.
		-- {group-name}
			-- Highlight group that decides the color and font of the
			-- cursor.
			-- In the |TUI|:
			-- - |inverse|/reverse and no group-name are interpreted
			  -- as "host-terminal default cursor colors" which
			  -- typically means "inverted bg and fg colors".
			-- - |ctermfg| and |guifg| are ignored.
		-- {group-name}/{group-name}
			-- Two highlight group names, the first is used when
			-- no language mappings are used, the other when they
			-- are. |language-mapping|

	-- Examples of parts:
	   -- n-c-v:block-nCursor	In Normal, Command-line and Visual mode, use a
				-- block cursor with colors from the "nCursor"
				-- highlight group
	   -- n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20
				-- In Normal et al. modes, use a block cursor
				-- with the default colors defined by the host
				-- terminal.  In Insert-like modes, use
				-- a vertical bar cursor with colors from
				-- "Cursor" highlight group.  In Replace-like
				-- modes, use an underline cursor with
				-- default colors.
	   -- i-ci:ver30-iCursor-blinkwait300-blinkon200-blinkoff150
				-- In Insert and Command-line Insert mode, use a
				-- 30% vertical bar cursor with colors from the
				-- "iCursor" highlight group.  Blink a bit
				-- faster.

	-- The 'a' mode is different.  It will set the given argument-list for
	-- all modes.  It does not reset anything to defaults.  This can be used
	-- to do a common setting for all modes.  For example, to switch off
	-- blinking: "a:blinkon0"

	-- Examples of cursor highlighting: >vim
	    -- highlight Cursor gui=reverse guifg=NONE guibg=NONE
	    -- highlight Cursor gui=NONE guifg=bg guibg=fg
-- <
