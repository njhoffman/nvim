local modemap = {
  n = {},
  i = {},
  R = {},
  s = {},
  v = {},
  V = {},
  ['^V'] = {},
  -- o = {},
  no = {},
  os = {},
  noc = {},
  oc = {},
  noy = {},
  oy = {},
  nod = {},
  od = {},
  nov = {},
  ov = {},
  noV = {},
  oV = {},
  ['no^V'] = {},
}

local reactive = require('reactive')

-- stylua: ignore
-- vim.opt.operatorfunc._value
reactive.opfunc_list = {
  -- ['cx'] = 'v:lua.require"substitute.exchange".operator_callback',
  ['X']  = 'v:lua.require"substitute.exchange".operator_callback',
  ['S']  = 'v:lua.require"substitute".operator_callback',
  -- ['gc'] = 'v:lua.MiniComment.operator',
  -- ['gb'] = 'v:lua.MiniComment.operator',
  ['gc'] = "v:lua.require'Comment.api'.locked'toggle.linewise.current'", -- n:V V:n gc
  ['gb'] = "v:lua.require'Comment.api'.locked'toggle.blockwise'", -- n:^V  ^V:i
  ['ga'] = 'v:lua.MiniAlign.align_user',
  ['gs'] = 'v:lua.MiniSplitjoin.operator',
  ['s']  = 'v:lua.MiniSurround.add',
  ["goo"]  = "v:lua.require'debugprint'.debugprint_cache",
  ["gto"]  = "v:lua.MiniSurround.replace",
-- v:lua.require'stringcase.range'.operator_callback"
-- v:lua.require'stringcase.range'.selection_operator_callback"
-- v:lua.require'" .. constants.namespace .. "'.operator_callback" (textcase.nvim)
-- "v:lua.require'ts-node-action.repeat'.repeat_action"
-- vim.go.operatorfunc = "v:lua.__remote_op_opfunc"
-- vim.o.operatorfunc = 'v:lua.MiniBasics.put_empty_line'
-- "v:lua.require'utils.escape.operatorfunc'.operatorfunc")
-- vim.go.operatorfunc = [[{x -> x}]]
-- vim.go.operatorfunc = [[v:lua.require'flash.repeat'._repeat]]
-- "v:lua.require'refactoring'.debug.printf_operatorfunc"
-- "v:lua.require'gitsigns.repeat'.repeat_action"
-- vim.go.operatorfunc = "v:lua.require'debugprint'.debugprint_cache"
-- 'MiniOperators%.replace'
-- "v:lua.require'stay-in-place'.operator_callback"
-- "v:lua.require'refactoring'.debug.printf_operatorfunc"
-- v:lua.require'substitute.range'.operator_callback
-- v:lua.require'substitute.range'.selection_operator_callback
--
}

reactive.setup({
  builtin = {
    cursorline = false,
    cursor = false,
    modemsg = false,
  },
})

local preprocess = function(preset)
  local no_operators = preset.modes.no.operators or {}
  preset.modes.o = vim.tbl_deep_extend('force', preset.modes.no, preset.modes.o)
  return preset
end

local cursorline_preset = preprocess(require('configs.reactive.cursorline'))
-- local cursor_preset = require('configs.reactive.cursor')

-- require('reactive').add_preset(cursor_preset)
require('reactive').add_preset(cursorline_preset)

-- |c |	c 	change
-- |d |	d 	delete
-- |y |	y 	yank into register (does not change the text)
-- |~ |	~ 	swap case (only if 'tildeop' is set)
-- |g~|	g~	swap case
-- |gu|	gu	make lowercase
-- |gU|	gU	make uppercase
-- |! |	! 	filter through an external program
-- |= |	= 	filter through 'equalprg' or C-indenting if empty
-- |gq|	gq	text formatting
-- |gw|	gw	text formatting with no cursor movement
-- |g?|	g?	ROT13 encoding
-- |> |	> 	shift right
-- |< |	< 	shift left
-- |zf|	zf	define a fold
-- |g@|	g@	call function set with the 'operatorfunc' option

-- n ➜ ni ➜ niI
-- n ➜ no ➜ nov
-- R ➜    ➜ Rv
-- n ➜    ➜ no
--          n
--          i
