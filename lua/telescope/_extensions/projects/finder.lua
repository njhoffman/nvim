local finders = require('telescope.finders')
local display = require('project_nvim.display')

local entry_display = require('telescope.pickers.entry_display')

local create = function(projects)
  local display_items = {
    { width = 2 },
    { width = 0 },
    { width = 0, right_justify = true },
    { width = 0, remaining = true },
  }

  for _, result in ipairs(projects) do
    local function update_width(idx, len)
      display_items[idx].width = len > display_items[idx].width and len or display_items[idx].width
    end
    update_width(2, #result.name)
    update_width(3, #result.display_group)
    update_width(4, #result.display_path)
  end
  local displayer = entry_display.create({
    separator = ' ',
    items = display_items,
  })
  local function make_display(entry)
    return displayer({
      { entry.icon[1], entry.icon[2] },
      { entry.name, 'TelescopeProjectName' },
      { entry.group, entry.group_highlight },
      { entry.path, 'TelescopeProjectPath' },
    })
  end

  return finders.new_table({
    results = projects,
    entry_maker = function(entry)
      return {
        display = make_display,
        group_highlight = entry.group_highlight,
        name = entry.name,
        icon = entry.icon,
        group = entry.display_group,
        path = entry.display_path,
        ordinal = entry.name .. ' ' .. entry.path,
      }
    end,
  })
end

return {
  create = create,
}
