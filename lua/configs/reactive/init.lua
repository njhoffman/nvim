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

-- TODO: different cursorline hl for initial WhichKey d and subsequent ones
local reactive = require('reactive')
reactive.opfunc_get = function(opfunc)
  local res = require('configs.reactive.opfuncs').get_opfunc(opfunc)
  return res and res[1] and res[1][1] or nil
end

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
