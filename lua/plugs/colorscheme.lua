local utils = require("lazy-utils")

local plugins = {
  -- marko-cerovac/material.nvim
  -- navarasu/onedark.nvim
  -- projekt0n/github-nvim-theme
  -- rebelot/kanagawa.nvim
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
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
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = { style = "moon" },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
}

utils.apply_configs(plugins)
utils.print_stats("Colorscheme", plugins)
return plugins

-- { "edluffy/hologram.nvim", cond = os.getenv("KITTY_WINDOW_ID") ~= nil
-- ["nvim-highlight-colors"] = { "brenoprata10/nvim-highlight-color" },
-- ["icon-picker.nvim"] = { "ziontee113/icon-picker.nvim"}
-- ["vim-visual-multi"] = { "mg979/vim-visual-multi" },
-- ["wilder.nvim"] = {
--   "gelguy/wilder.nvim",
--   rocks = { "luarocks-fetch-gitrec", "pcre2" },
--   requires = { "romgrk/fzy-lua-native", "kyazdani42/nvim-web-devicons" }
-- }
-- ["codewindow.nvim"] = { "gorbit99/codewindow.nvim" },
-- https://github.com/anuvyklack/windows.nvim
-- ["yank-history"] = {"yazgoo/yank-history"},
-- https://github.com/gbprod/yanky.nvim
