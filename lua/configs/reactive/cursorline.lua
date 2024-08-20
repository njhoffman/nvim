local Cursor = "ReactiveCursor"

local ignored = { buftypes = { "nofile" } }

local cursorline_preset = {
  name = "cursorline",
  skip = function()
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
    local readonly = vim.api.nvim_get_option_value("readonly", { buf = 0 })
    return buftype == "nofile" or readonly
  end,
  init = function()
    vim.opt.cursorline = true
    vim.opt.guicursor:append("a:ReactiveCursor")
  end,
  static = {
    hl = {
      -- Visual = { bg = '#001228', italic = true },
      -- Visual = { bg = '#08203f', bold = true, italic = true },
      [Cursor] = { underline = true, bg = "#3f56ff" },
    },
    winhl = {
      active = {
        CursorLine = { bg = "#040f20" },
        -- CursorLine = { bg = '#040f20' },
        -- CursorLine = { bg = '#061028' },
        -- CursorLineNr = { fg = '#44aaff', italic = true },
      },
      inactive = {
        -- CursorLine = { bg = '#020202' },
        -- CursorLine = { bg = '#000408' },
        -- CursorLine = { bg = '#001018' },
        -- CursorLineNr = { fg = '#44aaff', bold = true },
      },
    },
  },
  modes = {
    [{ "i", "niI" }] = {
      winhl = {
        -- #10a4ca, #00181f
        CursorLine = { bg = "#00161a" },
        CursorLineNr = { fg = "#33acb6", bg = "#00121a", italic = true },
      },
      hl = {
        [Cursor] = { bg = "#009cc6" },
      },
    },
    -- command
    c = {
      -- hl = {
      --   [Cursor] = { underline = true, bg = '#200808', fg = '#00f000' },
      -- },
      winhl = {
        CursorLine = { bg = "#121016", italic = true },
        CursorLineNr = { fg = "#7e7e9e", bg = "#121016", italic = true },
      },
    },
    n = {
      hl = {
        [Cursor] = { underline = true, bg = "#3f56ff" },
      },
      winhl = {
        CursorLine = { bg = "#040f20" },
        CursorLineNr = { fg = "#40a0f0", bg = "#040f20", italic = true },
      },
    },
    -- visual
    [{ "v", "V", "\x16" }] = {
      -- from = function()
      --   vim.opt.relativenumber = false
      -- end,
      -- to = function()
      --   vim.opt.relativenumber = true
      -- end,
      hl = {
        -- [Cursor] = { bg = '#7000ff', bold = true, italic = true },
        [Cursor] = { bg = "#5620ff", bold = true, italic = true },
      },
      winhl = {
        CursorLine = { bg = "#10204f", italic = true },
        CursorLineNr = { fg = "#6874fe", italic = true },
        Visual = { bg = "#08203f", bold = true, italic = true },
      },
    },
    -- select
    [{ "s", "S", "\x13" }] = {
      winhl = {
        CursorLine = { bg = "#20183f", italic = true },
        CursorLineNr = { fg = "#c4b5fd", italic = true },
        Visual = { bg = "#20183f", bold = true, italic = true },
      },
    },
    -- replace
    [{ "R", "niR", "niV" }] = {
      hl = {
        [Cursor] = { bg = "#fdba74" },
      },
      winhl = {
        CursorLine = { bg = "#1f0f00", italic = true },
        CursorLineNr = { fg = "#fdba74", bg = "#180a00", italic = true },
      },
    },
    no = {
      -- from = function()
      --   vim.opt.relativenumber = false
      -- end,
      -- to = function()
      --   vim.opt.relativenumber = true
      -- end,
      hl = {
        -- WhichKeyKey = { fg = '#00ccaa' },
        -- barbecue_basename = { fg = '#00ccaa' },
        [Cursor] = { bg = "#86508f" },
      },
      winhl = {
        CursorLine = { bg = "#12061f", italic = true },
        CursorLineNr = { bg = "#101016", italic = true },
      },
      operators = {
        ["g@"] = {
          -- winhl = {},
          -- hl = {},
          opfuncs = {
            S = {
              winhl = {
                CursorLine = { bg = "#1a1030" }, -- #061028
                CursorLineNr = { bg = "#1a1030" }, -- #061028
                -- StatusLine = { bg = '#5b21b6' },
              },
            },
            X = {
              winhl = {
                CursorLine = { bg = "#1a1030" }, -- #061028
                CursorLineNr = { bg = "#1a1030" }, -- #061028
                -- StatusLine = { bg = '#5b21b6' },
              },
            },
            ds = {
              winhl = {
                CursorLine = { bg = "#1a0010" },
                CursorLineNr = { fg = "#8c8585", bg = "#1a0010", italic = true },
              },
            },
            cs = {
              winhl = {
                CursorLine = { bg = "#041230" }, -- #162054
                CursorLineNr = { fg = "#23d5ff", bg = "#041230", italic = true },
              },
            },
          },
        },
        -- switch case
        [{ "gu", "gU", "g~", "~" }] = {
          hl = {
            [Cursor] = { bg = "#86a0ff" },
          },
          winhl = {
            CursorLine = { bg = "#18263a", italic = true },
            CursorLineNr = { fg = "#cbd5e1", bg = "#18263a", italic = true },
          },
        },
        -- change
        c = {
          hl = {
            -- [Cursor] = { underline = true, bg = '#200808', fg = '#00f000' },
            [Cursor] = { bg = "#2385ff" },
          },
          winhl = {
            CursorLine = { bg = "#041230", italic = true }, -- #162054
            CursorLineNr = { fg = "#23d5ff", bg = "#041230", italic = true },
          },
        },
        -- delete
        d = {
          hl = {
            -- [Cursor] = { underline = true, bg = '#200808', fg = '#00f000' },
            [Cursor] = { bg = "#f00808" },
          },
          winhl = {
            CursorLine = { bg = "#1a0010", italic = true },
            CursorLineNr = { fg = "#8c8585", bg = "#1a0010", italic = true },
          },
        },
        -- yank
        y = {
          hl = {
            [Cursor] = { bg = "#8f76ff" },
          },
          winhl = {
            CursorLine = { bg = "#0f162f", italic = true },
            CursorLineNr = { fg = "#8dbaff", bg = "#0f162f", italic = true },
          },
        },
      },
    },
  },
}

return cursorline_preset
