local entry_display = require('telescope.pickers.entry_display')

local displayer = entry_display.create({
  separator = ' ',
  items = {
    { remaining = true },
    { remaining = true },
  },
})

local entry_maker = function(entry)
  return {
    value = entry,
    display = function()
      return displayer({
        { string.format('[%s]', entry.alias), 'TelescopeDevdocsCategory' },
        { entry.name, 'TelescopeDevdocsTitle' },
      })
    end,
    ordinal = string.format('[%s] %s', entry.alias, entry.name),
  }
end

return entry_maker
