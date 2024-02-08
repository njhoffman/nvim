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

local default_preset = {
  name = 'cursorline',
  init = function()
    vim.opt.cursorline = true
    vim.opt.guicursor:append('a:ReactiveCursor')
    -- vim.dbglog('guicursor', vim.api.nvim_get_option_value('guicursor', {}))
  end,
  static = {
    winhl = {
      inactive = {
        CursorLine = { bg = '#101620' }, -- #061028
        CursorLineNr = { fg = '#40a0f0', bg = '#101820', italic = true },
      },
    },
  },
  modes = {
    -- o = {
    --   winhl = { CursorLine = { bg = '#0e2d3d' } },
    --   hl = { CursorLineNr = { bg = '#048798' } },
    -- },
    no = {
      winhl = { CursorLine = { bg = '#001f2f' } },
      hl = { CursorLineNr = { bg = '#048798' } },
      operators = {
        ['g@'] = {
          winhl = {},
          hl = {},
          opfuncs = {
            -- 'S' here is that unique name we passed into the `set_opfunc` method in the mapping
            -- S = {
            --   winhl = {
            --     CursorLine = { bg = '#801640' }, -- #061028
            --     StatusLine = { bg = '#5b21b6' },
            --   },
            -- },
          },
        },
        -- switch case
        [{ 'gu', 'gU', 'g~', '~' }] = {
          winhl = {
            CursorLine = { bg = '#334155' },
            CursorLineNr = { fg = '#cbd5e1', bg = '#334155', italic = true },
          },
        },
        -- change
        c = {
          hl = {
            ReactiveCursor = { bg = '#93c5fd' },
          },
          winhl = {
            CursorLine = { bg = '#101f3f' },
            CursorLineNr = { fg = '#23d5ff', bg = '#162054', italic = true },
          },
        },
        -- delete
        d = {
          hl = {
            ReactiveCursor = { bg = '#fca5a5' },
          },
          winhl = {
            CursorLine = { bg = '#200018' },
            CursorLineNr = { fg = '#8c8585', bg = '#200808' },
          },
        },
        -- yank
        y = {
          hl = {
            ReactiveCursor = { bg = '#fdba74' },
          },
          winhl = {
            CursorLine = { bg = '#121240' },
            CursorLineNr = { fg = '#8dbaff', bg = '#11183e', italic = true },
          },
        },
      },
    },
    [{ 'i', 'niI' }] = {
      hl = {
        ReactiveCursor = { bg = '#5eead4' },
      },
      winhl = {
        -- #10a4ca
        CursorLine = { bg = '#00181f' },
        CursorLineNr = { fg = '#33bca6', bg = '#00121c', italic = true },
      },
    },
    c = {
      hl = {
        ReactiveCursor = { bg = '#cbd5e1' },
      },
      winhl = {
        CursorLine = { bg = '#121016' },
        CursorLineNr = { fg = '#7e7e9e', bg = '#121016', italic = true },
      },
    },
    n = {
      hl = {
        ReactiveCursor = { bg = '#ffffff' },
      },
      winhl = {
        CursorLine = { bg = '#040f20' },
        CursorLineNr = { fg = '#40a0f0', bg = '#101820', italic = true },
      },
    },
    -- visual
    [{ 'v', 'V', '\x16' }] = {
      hl = {
        ReactiveCursor = { bg = '#d8b4fe' },
      },
      winhl = {
        CursorLineNr = { fg = '#6874fe', bg = '#141436', italic = true },
        Visual = { bg = '#14143f', bold = true, italic = true },
      },
    },
    -- select
    [{ 's', 'S', '\x13' }] = {
      hl = {
        ReactiveCursor = { bg = '#c4b5fd' },
      },
      winhl = {
        CursorLineNr = { fg = '#c4b5fd', italic = true },
        Visual = { bg = '#2e1065' },
      },
    },
    -- replace
    [{ 'R', 'niR', 'niV' }] = {
      hl = {
        ReactiveCursor = { bg = '#67e8f9' },
      },
      winhl = {
        CursorLine = { bg = '#1f1400' },
        CursorLineNr = { fg = '#fdba74', bg = '#281010', italic = true },
      },
    },
  },
}
require('reactive').setup({
  builtin = {
    cursorline = false,
    cursor = false,
    modemsg = true,
  },
  -- operators = {
  --   d = {
  --     winhl = {
  --       -- if the `no` mode has StatusLine highlight, it will be overwritten by this one below
  --       StatusLine = { fg = 'yourcolor', bg = 'yourcolor' },
  --     },
  --   },
  -- },
})

require('reactive').add_preset(default_preset)
