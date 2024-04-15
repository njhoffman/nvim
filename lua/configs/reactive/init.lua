-- https://github.com/rasulomaroff/reactive.nvim/commit/57f43fac69b1a3ff9f82ad1e10ac3d34d52e6b39
local modemap = {
  n = {},
  i = {},
  R = {},
  s = {},
  v = {},
  V = {},
  ['^V'] = {},
  no = {},
  noc = {},
  noy = {},
  nod = {},
  nov = {},
  noV = {},
  ['no^V'] = {},
}

-- TODO: different cursorline hl for initial WhichKey d and subsequent ones
local reactive = require('reactive')

reactive.setup({
  builtin = {
    cursorline = false,
    cursor = false,
    modemsg = false,
  },
})

local cursorline_preset = require('configs.reactive.cursorline')
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
