-- No need to copy this inside `setup()`. Will be used automatically.

-- TODO: dynamic [[, ]] mapping

-- stylua: ignore
local default = {
  -- First-level elements are tables describing behavior of a target:
  --
  -- - <suffix> - single character suffix. Used after `[` / `]` in mappings.
  --   For example, with `b` creates `[B`, `[b`, `]b`, `]B` mappings.
  --   Supply empty string `''` to not create mappings.
  --
  -- - <options> - table overriding target options.
  --
  -- See `:h MiniBracketed.config` for more info.

  buffer     = { suffix = 'gb', options = {} },
  comment    = { suffix = 'c', options = {} },
  conflict   = { suffix = 'x', options = {} },
  diagnostic = { suffix = 'd', options = {} },
  file       = { suffix = 'gf', options = {} },
  indent     = { suffix = 'gi', options = {} },
  jump       = { suffix = 'gj', options = {} },
  location   = { suffix = 'gl', options = {} },
  oldfile    = { suffix = 'go', options = {} },
  quickfix   = { suffix = 'q', options = {} },
  treesitter = { suffix = 't', options = {} },
  undo       = { suffix = 'u', options = {} },
  window     = { suffix = 'w', options = {} },
  yank       = { suffix = 'y', options = {} },
}

-- stylua: ignore
require('mini.bracketed').setup({
  buffer     = { suffix = 'gb', options = {} },
  comment    = { suffix = 'c', options  = {} },
  conflict   = { suffix = 'x', options  = {} },
  diagnostic = { suffix = 'd', options  = {} },
  file       = { suffix = 'gf', options = {} },
  indent     = { suffix = 'gi', options = {} },
  jump       = { suffix = 'gj', options = {} },
  location   = { suffix = 'gl', options = {} },
  oldfile    = { suffix = 'go', options = {} },
  quickfix   = { suffix = 'q', options  = {} },
  treesitter = { suffix = 't', options  = {} },
  window     = { suffix = 'w', options  = {} },
  yank       = { suffix = 'y', options  = {} },
  undo       = { suffix = 'gu', options = {} },
})

-- Target                                            	 Mappings	Lua function
-- Buffer                                            	 [B [b ]b ]B	MiniBracketed.buffer()
-- Comment block                                     	 [C [c ]c ]C	MiniBracketed.comment()
-- Conflict marker                                   	 [X [x ]x ]X	MiniBracketed.conflict()
-- Diagnostic                                        	 [D [d ]d ]D	MiniBracketed.diagnostic()
-- File on disk                                      	 [F [f ]f ]F	MiniBracketed.file()
-- Indent change                                     	 [I [i ]i ]I	MiniBracketed.indent()
-- Jump from jumplist inside current buffer          	 [J [j ]j ]J	MiniBracketed.jump()
-- Location from location list                       	 [L [l ]l ]L	MiniBracketed.location()
-- Old files                                         	 [O [o ]o ]O	MiniBracketed.oldfile()
-- Quickfix entry from quickfix list                 	 [Q [q ]q ]Q	MiniBracketed.quickfix()
-- Tree-sitter node and parents                      	 [T [t ]t ]T	MiniBracketed.treesitter()
-- Undo states from specially tracked linear history 	 [U [u ]u ]U	MiniBracketed.undo()
-- Window in current tab                             	 [W [w ]w ]W	MiniBracketed.window()
-- Yank selection replacing latest put region        	 [Y [y ]y ]Y	MiniBracketed.yank()
-- Using lower-suffix and upper-suffix (lower and upper case suffix) for a single target the following mappings are created:
--
-- [ + upper-suffix : go first.
-- [ + lower-suffix : go backward.
-- ] + lower-suffix : go forward.
-- ] + upper-suffix : go last.
