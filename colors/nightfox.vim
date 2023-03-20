
lua << EOF

  local config = {
    transparent = false, -- Disable setting background
    terminal_colors = true, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
    dim_inactive = false, -- Non focused panes set to alternative background
    palettes = {
      -- Custom duskfox with black background
      duskfox = {
        bg1 = "#000000", -- Black background
        bg0 = "#1d1d2b", -- Alt backgrounds (floats, statusline, ...)
        bg3 = "#121820", -- 55% darkened from stock
        sel0 = "#131b24", -- 55% darkened from stock
      },
    },
    specs = {
      all = {
        inactive = "bg0", -- Default value for other styles
      },
      duskfox = {
        inactive = "#090909", -- Slightly lighter then black background
      },
    },
    groups = {
      all = {
        NormalNC = { fg = "fg1", bg = "inactive" }, -- Non-current windows
      },
    },
  }
  vim.schedule(function()
    vim.cmd("colorscheme nightfox")
  end

EOF
