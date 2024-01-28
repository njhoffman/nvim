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

local default_preset = {
  name = 'cursorline',
  init = function()
    vim.opt.cursorline = true
  end,
  static = {
    winhl = {
      inactive = {
        CursorLine = { bg = '#101620' }, -- #061028
        CursorLineNr = { fg = '#40a0f0', bg = '#101820', italic = true },
      },
    },
  },
  opfuncs = {
    -- 's' here is that unique name we passed into the `set_opfunc` method in the mapping
    s = {
      winhl = {
        StatusLine = { bg = '#5b21b6' },
      },
    },
    D = {
      winhl = {
        CursorLine = { bg = '#350808' },
        CursorLineNr = { fg = '#fca5a5', bg = '#350808', italic = true },
      },
    },
  },
  modes = {
    no = {
      operators = {
        -- switch case
        [{ 'gu', 'gU', 'g~', '~' }] = {
          winhl = {
            CursorLine = { bg = '#334155' },
            CursorLineNr = { fg = '#cbd5e1', bg = '#334155', italic = true },
          },
        },
        -- change
        c = {
          winhl = {
            CursorLine = { bg = '#00224a' },
            CursorLineNr = { fg = '#23d5ff', bg = '#162054', italic = true },
          },
        },
        -- delete
        d = {
          winhl = {
            CursorLine = { bg = '#350808' },
            CursorLineNr = { fg = '#fca5a5', bg = '#350808' },
          },
        },
        -- yank
        y = {
          winhl = {
            CursorLine = { bg = '#091240' },
            CursorLineNr = { fg = '#8dbaff', bg = '#11183e', italic = true },
          },
        },
      },
    },
    i = {
      winhl = {
        -- #10a4ca
        CursorLine = { bg = '#00161c' },
        CursorLineNr = { fg = '#33bca6', bg = '#00121c', italic = true },
      },
    },
    c = {
      winhl = {
        CursorLine = { bg = '#121016' },
        CursorLineNr = { fg = '#ffffff', bg = '#202020', italic = true },
      },
    },
    n = {
      winhl = {
        CursorLine = { bg = '#040f20' },
        CursorLineNr = { fg = '#40a0f0', bg = '#101820', italic = true },
      },
    },
    -- visual
    [{ 'v', 'V', '\x16' }] = {
      winhl = {
        CursorLineNr = { fg = '#6874fe', bg = '#141436', italic = true },
        Visual = { bg = '#14143f', bold = true, italic = true },
      },
    },
    -- select
    [{ 's', 'S', '\x13' }] = {
      winhl = {
        CursorLineNr = { fg = '#c4b5fd', italic = true },
        Visual = { bg = '#2e1065' },
      },
    },
    -- replace
    R = {
      winhl = {
        CursorLine = { bg = '#180c00' },
        CursorLineNr = { fg = '#fdba74', bg = '#241000', italic = true },
      },
    },
  },
}

require('reactive').setup({
  builtin = {
    cursorline = false,
    cursor = true,
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

local current_mode = vim.api.nvim_get_mode().mode
vim.api.nvim_create_autocmd('ModeChanged', {
  -- group = group,
  pattern = '*:*',
  -- desc = 'Reactive: watches for mode changes to update highlights and run callbacks',
  callback = function(opts)
    local from, to = unpack(vim.split(opts.match, ':'))
    current_mode = to
    -- vim.dbglog('reactive: ModeChanged "' .. vim.v.operator .. '" ' .. from .. ':' .. to)
  end,
})

local Highlight = require('reactive.highlight')
local Snapshot = require('reactive.snapshot')

vim.api.nvim_create_autocmd('User', {
  pattern = 'WhichKeyMode_*',
  desc = 'reactive watches for pseudo-mode changes from which-key to update highlights and run callbacks',
  callback = function(opts)
    -- local _, new_mode, new_op = vim.split(opts.match, '_')
    -- if new_mode ~= current_mode then
    --   vim.dbglog('reactive: WhichKeyMode changed: ' .. new_op ..  ' from ' .. current_mode .. ' to ' .. new_mode)
    --   Snapshot:set_modes(current_mode, new_mode)
    --   Highlight:apply(Snapshot:gen({ callbacks = true }))
    --   current_mode = new_mode
    -- end
  end,
})

require('reactive').add_preset(default_preset)
