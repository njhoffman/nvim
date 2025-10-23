local cfg = {
  current_only = false,
  zindex = 40,
  excluded_filetypes = {},
  width = 1,
  show_in_floating = true, -- Show scrollbar in floating windows

  -- Scrollbar shape and highlight configuration per state
  -- States: active (focused window), inactive (unfocused), scrolling (during scroll)
  states = {
    active = {
      shape = {
        head = "▎",
        body = "▎",
        tail = "▎",
      },
      -- Highlight groups for each segment
      highlight = {
        head = "SatelliteBar",
        body = "SatelliteBar",
        tail = "SatelliteBar",
      },
      winblend = 50,
    },
    inactive = {
      shape = {
        head = "▎",
        body = "░",
        tail = "▎",
      },
      highlight = {
        head = "SatelliteBarInactive",
        body = "SatelliteBarInactive",
        tail = "SatelliteBarInactive",
      },
      winblend = 70,
    },
    scrolling = {
      shape = {
        head = "▲",
        body = "█",
        tail = "▼",
      },
      highlight = {
        head = "SatelliteBarScrolling",
        body = "SatelliteBarScrolling",
        tail = "SatelliteBarScrolling",
      },
      winblend = 30,
    },
  },

  -- Legacy shape config (kept for backwards compatibility, overridden by states)
  -- shape = { head = "▎", body = "▎", tail = "▎", },
  -- shape = { head = "▲", body = "█", tail = "▼", },
  --         text = " ",
  --         blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
  --         color = nil,
  --         color_nr = nil, -- cterm
  --         highlight = "CursorColumn",
  --         hide_if_all_visible = true, -- Hides handle if all lines are visible
  handlers = {

    -- local default = { max_size = 10, min_size = 3, width = 1, right_offset = 1, excluded_filetypes = {}, winblend = 0,
    --     shape = { head = '▲', body = '█', tail = '▼', },
    --     highlight = { head = 'Normal', body = 'Normal', tail = 'Normal', },
    -- }
    cursor = {
      enable = false,
      -- Supports any number of symbols
      symbols = { "⎺", "⎻", "⎼", "⎽" },
      -- symbols = { "█" },
      -- symbols = { '⎻', '⎼' }
      -- Highlights: - SatelliteCursor (default links to NonText
    },
    minidiff = {
      enable = true,
      signs = { -- can only be a single character (multibyte is okay)
        add = "│",
        change = "│",
        delete = "-",
      },
      -- Highlights:
      -- SatelliteMiniDiffAdd (default links to MiniDiffSignAdd)
      -- SatelliteMiniDiffChange (default links to MiniDiffSignChange)
      -- SatelliteMiniDiffDelete (default links to MiniDiffSignDelete)
    },
    search = {
      enable = true,
      -- Highlights:
      -- - SatelliteSearch (default links to Search)
      -- - SatelliteSearchCurrent (default links to SearchCurrent)
    },
    diagnostic = {
      enable = true,
      signs = { "-", "=", "≡" },
      min_severity = vim.diagnostic.severity.HINT,
      -- Highlights:
      -- - SatelliteDiagnosticError (default links to DiagnosticError)
      -- - SatelliteDiagnosticWarn (default links to DiagnosticWarn)
      -- - SatelliteDiagnosticInfo (default links to DiagnosticInfo)
      -- - SatelliteDiagnosticHint (default links to DiagnosticHint)
    },
    gitsigns = {
      enable = true,
      signs = { -- can only be a single character (multibyte is okay)
        add = "│",
        change = "│",
        delete = "-",
      },
      -- Highlights:
      -- SatelliteGitSignsAdd (default links to GitSignsAdd)
      -- SatelliteGitSignsChange (default links to GitSignsChange)
      -- SatelliteGitSignsDelete (default links to GitSignsDelete)
    },
    marks = {
      enable = true,
      show_builtins = false, -- shows the builtin marks like [ ] < >
      key = "m",
      -- Highlights:
      -- SatelliteMark (default links to Normal)
    },
    quickfix = {
      signs = { "-", "=", "≡" },
      -- Highlights:
      -- SatelliteQuickfix (default links to WarningMsg)
    },
  },
}

require("satellite").setup(cfg)

-- head ='🮇',
-- 	body ='🮇',
-- 	tail ='🮇',

--         head = '▲',
--         body = '█',
--         tail = '▼',
-- vim.g.scrollbar_shape = {
-- 	head ='▎',
-- 	body ='▎',
-- 	tail ='▎',
-- }

-- init = function()
-- 	vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
-- 		desc = "User: Change `SatelliteQuickfix` color",
-- 		callback = function()
-- 			vim.api.nvim_set_hl(0, "SatelliteQuickfix", { link = "DiagnosticSignInfo" })
-- 		end,
-- 	})
-- end,
-- opts = {
-- 	winblend = 10, -- only little transparency, since otherwise hard to see in some themes
-- 	handlers = {
-- 		cursor = { enable = false },
-- 		marks = { enable = false },
-- 	},
-- },
