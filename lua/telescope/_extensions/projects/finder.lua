local finders = require("telescope.finders")
local entry_display = require("telescope.pickers.entry_display")

local function create_finder(display_items, parsed_results)
  local displayer = entry_display.create({
    separator = " ",
    items = display_items,
  })
  local function make_display(entry)
    return displayer({
      { entry.name, "TelescopeProjectName" },
      { entry.group, entry.group_highlight },
      { entry.path, "TelescopeProjectPath" },
    })
  end

  return finders.new_table({
    results = parsed_results,
    entry_maker = function(entry)
      return {
        display = make_display,
        group_highlight = entry.group_highlight,
        name = entry.name,
        group = entry.display_group,
        path = entry.display_path,
        ordinal = entry.name .. " " .. entry.path,
      }
    end,
  })
end

return {
  create = create_finder,
}
