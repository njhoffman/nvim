local strings = require('plenary.strings')
local entry_display = require('telescope.pickers.entry_display')

local build_widths = function(results)
  local widths = { title = 0, name = 0 }
  for _, entry in pairs(results) do
    for key, value in pairs(widths) do
      -- TODO: allow title to be a string or { string, highlight } table
      widths[key] = math.max(value, strings.strdisplaywidth(entry[key] or ''))
    end
  end
  return widths
end

local create_make_display = function(results)
  local widths = build_widths(results)
  -- TODO: allow title to be a string or { string, highlight } table
  local displayer = entry_display.create({
    separator = ' ▏',
    items = {
      { width = widths.name },
      { width = widths.title },
    },
  })
  return function(entry)
    return displayer({
      {
        strings.align_str(entry.value.name, widths.name, true),
        'TelescopeResultsClass',
      },
      {
        entry.value.title,
        'TelescopeResultsComment',
      },
    })
  end
end

local entry_maker = function(results)
  local make_display = create_make_display(results)

  return function(entry)
    return {
      value = entry,
      display = make_display,
      ordinal = entry.name,
    }
  end
end

return {
  entry_maker = entry_maker,
}
