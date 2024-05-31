local cursorline_preset = {
  name = 'cursorline',
  init = function()
    vim.opt.cursorline = true
    vim.opt.guicursor:append('a:ReactiveCursor')
  end,
  static = {
    winhl = {
      active = {

        -- CursorLine({ bg = '#061028' }),
        -- CursorLine = { bg = '#061028' },
        -- CursorLineNr = { fg = '#44aaff', italic = true },
      },
      inactive = {
        -- CursorLine = { bg = '#001018' },
        -- CursorLineNr = { fg = '#44aaff', bold = true },
      },
    },
  },
  modes = {
    [{ 'i', 'niI' }] = {
      winhl = {
        -- #10a4ca, #00181f
        CursorLine = { bg = '#00121a' },
        CursorLineNr = { fg = '#33acb6', bg = '#00121a', italic = true },
      },
      -- hl = {
      --   WhichKeyKey = { fg = '#00ccaa' },
      --   barbecue_basename = { fg = '#00ccaa' },
      -- },
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
        CursorLineNr = { fg = '#40a0f0', bg = '#040f20', italic = true },
      },
    },
    -- visual
    [{ 'v', 'V', '\x16' }] = {
      winhl = {
        -- CursorLineNr = { fg = '#6874fe', italic = true },
        Visual = { bg = '#08203f', bold = true, italic = true },
      },
    },
    -- select
    [{ 's', 'S', '\x13' }] = {
      winhl = {
        CursorLineNr = { fg = '#c4b5fd', italic = true },
        CursorLine = { bg = '#28203f' },
        Visual = { bg = '#28203f', bold = true, italic = true },
      },
    },
    -- replace
    [{ 'R', 'niR', 'niV' }] = {
      winhl = {
        CursorLine = { bg = '#1f1400' },
        CursorLineNr = { fg = '#fdba74', bg = '#281010', italic = true },
      },
    },
    no = {
      winhl = {
        CursorLine = { bg = '#06162f' },
        CursorLineNr = { bg = '#06162f' },
      },
      operators = {
        ['g@'] = {
          -- winhl = {}, hl = {},
          opfuncs = {
            S = {
              winhl = {
                CursorLine = { bg = '#1a1030' }, -- #061028
                CursorLineNr = { bg = '#1a1030' }, -- #061028
                -- StatusLine = { bg = '#5b21b6' },
              },
            },
            X = {
              winhl = {
                CursorLine = { bg = '#1a1030' }, -- #061028
                CursorLineNr = { bg = '#1a1030' }, -- #061028
                -- StatusLine = { bg = '#5b21b6' },
              },
            },
            ds = {
              winhl = {
                CursorLine = { bg = '#1a0010' },
                CursorLineNr = { fg = '#8c8585', bg = '#1a0010', italic = true },
              },
            },
            cs = {
              winhl = {
                CursorLine = { bg = '#041230' }, -- #162054
                CursorLineNr = { fg = '#23d5ff', bg = '#041230', italic = true },
              },
            },
          },
        },
        -- switch case
        [{ 'gu', 'gU', 'g~', '~' }] = {
          winhl = {
            CursorLine = { bg = '#18263a' },
            CursorLineNr = { fg = '#cbd5e1', bg = '#18263a', italic = true },
          },
        },
        -- change
        c = {
          winhl = {
            CursorLine = { bg = '#041230' }, -- #162054
            CursorLineNr = { fg = '#23d5ff', bg = '#041230', italic = true },
          },
        },
        -- delete
        d = {
          winhl = {
            Cursor = { underline = true, bg = '#200808' },
            CursorLine = { bg = '#1a0010' },
            CursorLineNr = { fg = '#8c8585', bg = '#1a0010', italic = true },
          },
        },
        -- yank
        y = {
          winhl = {
            CursorLine = { bg = '#16103f' },
            CursorLineNr = { fg = '#8dbaff', bg = '#16103f', italic = true },
          },
        },
      },
    },
  },
}

return cursorline_preset
