local get_theme = function(theme)
  local winwidth = vim.api.nvim_win_get_width(0)
  local themes = {
    dropdown = require("telescope.themes").get_dropdown({
      winblend = 20,
      -- layout_config = { width = 0.5 },
      -- results_height = 15,
      previewer = false,
    }),
    ivy = require("telescope.themes").get_ivy({
      winblend = 20,
      layout_config = { height = 15 },
      preview = { hide_on_startup = winwidth < 120 },
    }),
    cursor = require("telescope.themes").get_cursor({
      winblend = 20,
      layout_config = { height = 15 },
    }),
    minimal = require("telescope.themes").get_minimal({
      winblend = 20,
    }),
  }
  return themes[theme]
end

return { get_theme = get_theme }
