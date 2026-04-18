local get_theme = function(theme)
  local themes = {
    dropdown = require("telescope.themes").get_dropdown({
      winblend = 20,
      previewer = false,
    }),
    dropdown_preview = require("telescope.themes").get_dropdown({
      winblend = 20,
      previewer = true,
    }),
    ivy = require("telescope.themes").get_ivy({
      winblend = 0,
      layout_config = {
        height = function(_, _, max_lines)
          return math.min(max_lines, 15)
        end,
      },
    }),
    cursor = require("telescope.themes").get_cursor({
      winblend = 20,
      layout_config = {
        height = function(_, _, max_lines)
          return math.min(max_lines, 15)
        end,
      },
    }),
    minimal = require("telescope.themes").get_minimal({
      winblend = 20,
    }),
  }

  if theme == "" or theme == "default" or theme == "flex" then
    return {}
  elseif type(themes[theme]) ~= "table" then
    vim.notify("Cannot find telescope theme: " .. theme, vim.log.levels.WARN)
    return {}
  else
    return themes[theme]
  end
end

return { get_theme = get_theme }
