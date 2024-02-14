local Cursor = 'Cursor'
-- local Cursor = 'ReactiveCursor'

local cursor_preset = {
  name = 'cursor',
  init = function()
    vim.opt.guicursor:append('a:ReactiveCursor')
  end,
  static = {
    winhl = {
      inactive = {},
    },
  },
  modes = {
    o = {
      -- winhl = { CursorLine = { bg = '#0e2d3d' } },
      -- hl = { CursorLineNr = { bg = '#0487f8' } },
      operators = {
        c = {
          hl = {
            [Cursor] = { bg = '#93058d' },
          },
        },
      },
    },
    no = {
      winhl = {},
      hl = {},
      operators = {
        ['g@'] = {
          opfuncs = {},
        },
        -- switch case
        [{ 'gu', 'gU', 'g~', '~' }] = {
          hl = {
            [Cursor] = { bg = '#93c5fd' },
          },
        },
        -- change
        c = {
          hl = {
            [Cursor] = { bg = '#101f3f', fg = 'none' },
          },
        },
        -- delete
        d = {
          hl = {
            [Cursor] = { underline = true, bg = '#200808' },
          },
        },
        -- yank
        y = {
          hl = {
            [Cursor] = { bg = '#fdba74' },
          },
        },
      },
    },
    [{ 'i', 'niI' }] = {
      hl = {
        [Cursor] = { bg = '#5eead4' },
      },
    },
    -- command
    c = {
      hl = {
        [Cursor] = { bg = '#cbd5e1' },
      },
    },
    n = {
      hl = {
        -- [Cursor] = { bg = '#ffffff' },
      },
    },
    -- visual
    [{ 'v', 'V', '\x16' }] = {
      hl = {
        [Cursor] = { bg = '#2e1065', italic = true },
      },
    },
    -- select
    [{ 's', 'S', '\x13' }] = {
      hl = {
        [Cursor] = { bg = '#2e1065' },
      },
    },
    -- replace
    [{ 'R', 'niR', 'niV' }] = {
      hl = {
        [Cursor] = { bg = '#67e8f9' },
      },
    },
  },
}

return cursor_preset
