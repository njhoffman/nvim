local get_theme = function(theme)
  local winwidth = vim.api.nvim_win_get_width(0)
  -- local themes = require('telescope.themes')
  -- builtin.find_files(themes.get_dropdown(opts))
  local flex = {
    layout_config = {
      bottom_pane = {
        height = 25,
        preview_cutoff = 40,
        prompt_position = 'top',
      },
      center = {
        preview_height = 0.5,
        height = 0.4,
        preview_cutoff = 40,
        prompt_position = 'top',
        width = 0.5,
      },
      cursor = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
      },
      horizontal = {
        height = 0.9,
        prompt_position = 'top',
        width = 0.8,
        preview_cutoff = 60,
        preview_width = 0.5,
      },
      vertical = {
        height = 0.9,
        preview_cutoff = 40,
        width = 0.8,
        prompt_position = 'top',
        mirror = true,
        preview_height = 0.5,
      },
      flex = {
        flip_columns = 130,
      },
    },
    layout_strategy = 'flex', -- flex, horizontal, veritical, center
  }

  local themes = {
    default = flex,
    dropdown = require('telescope.themes').get_dropdown({
      winblend = 20,
      -- layout_config = { width = 0.5 },
      -- results_height = 15,
      previewer = false,
    }),
    dropdown_preview = require('telescope.themes').get_dropdown({
      winblend = 20,
      previewer = true,
    }),
    ivy = require('telescope.themes').get_ivy({
      winblend = 0,
      layout_config = { height = 15 },
      preview = { hide_on_startup = winwidth < 120 },
    }),
    cursor = require('telescope.themes').get_cursor({
      winblend = 20,
      layout_config = { height = 15 },
    }),
    minimal = require('telescope.themes').get_minimal({
      winblend = 20,
    }),
  }

  if theme == '' or theme == 'flex' then
    return themes.default
  else
    if type(themes[theme]) ~= 'table' then
      vim.notify('Cannot find telescope theme: ' .. theme, 3)
      return themes.default
    else
      return themes[theme]
    end
  end
end

return { get_theme = get_theme }
