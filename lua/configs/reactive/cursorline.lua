local cursorline_preset = {
  name = 'cursorline',
  init = function()
    vim.opt.cursorline = true
    vim.opt.guicursor:append('a:ReactiveCursor')
  end,
  static = {
    winhl = {
      inactive = {
        CursorLine = { bg = '#060616' }, -- #061028
        -- CursorLineNr = { fg = '#40a0f0', bg = '#101820', italic = true },
      },
    },
  },
  modes = {
    o = {
      -- winhl = { CursorLine = { bg = '#0e2d3d' } },
      -- hl = { CursorLineNr = { bg = '#0487f8' } },
      operators = {
        c = {
          winhl = {
            CursorLine = { bg = '#162858' },
            CursorLineNr = { fg = '#23d5ff', bg = '#162054', italic = true },
          },
        },
      },
    },
    no = {
      winhl = { CursorLine = { bg = '#001f2f' } },
      operators = {
        ['g@'] = {
          -- winhl = {},
          -- hl = {},
          opfuncs = {
            -- 'S' here is that unique name we passed into the `set_opfunc` method in the mapping
            S = {
              winhl = {
                CursorLine = { bg = '#1a1030' }, -- #061028
                -- StatusLine = { bg = '#5b21b6' },
              },
            },
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
          winhl = {
            CursorLine = { bg = '#101f3f' },
            CursorLineNr = { fg = '#23d5ff', bg = '#162054', italic = true },
          },
        },
        -- delete
        d = {
          winhl = {
            CursorLine = { bg = '#200018' },
            CursorLineNr = { fg = '#8c8585', bg = '#200808' },
          },
        },
        -- yank
        y = {
          winhl = {
            CursorLine = { bg = '#121240' },
            CursorLineNr = { fg = '#8dbaff', bg = '#11183e', italic = true },
          },
        },
      },
    },
    [{ 'i', 'niI' }] = {
      winhl = {
        -- #10a4ca
        CursorLine = { bg = '#00181f' },
        CursorLineNr = { fg = '#33bca6', bg = '#00121c', italic = true },
      },
    },
    -- command
    c = {
      winhl = {
        CursorLine = { bg = '#121016' },
        CursorLineNr = { fg = '#7e7e9e', bg = '#121016', italic = true },
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
    [{ 'R', 'niR', 'niV' }] = {
      winhl = {
        CursorLine = { bg = '#1f1400' },
        CursorLineNr = { fg = '#fdba74', bg = '#281010', italic = true },
      },
    },
  },
}

return cursorline_preset
