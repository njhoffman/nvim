local entry_display = require("telescope.pickers.entry_display")

local get_widths = function(items)
  local widths = {}
  for _, entry in pairs(items) do
    entry.char = " " .. entry.char .. " "
    for _, key in ipairs(vim.tbl_keys(entry)) do
      widths[key] = math.max(widths[key] or 0, vim.fn.strdisplaywidth(entry[key] or ""))
    end
  end
  return widths
end

local generate_icons = function(icons)
  local widths = get_widths(icons)

  local displayer = entry_display.create({
    separator_hl = "TelescopeResultsSeparator",
    separator = " ▏",
    items = {
      { width = widths.char },
      { width = widths.name },
      { width = widths.code },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.value.char, "TelescopeResultsVariable" },
      { entry.value.name },
      { entry.value.code, "Comment" },
    })
  end

  return function(item)
    local entry = {
      display = make_display,
      value = item,
      ordinal = item.name .. " " .. item.code,
    }
    return entry
  end
end

vim.dbglog("")
return { generate_icons = generate_icons }
