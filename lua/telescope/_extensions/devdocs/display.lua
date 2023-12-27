local entry_display = require('telescope.pickers.entry_display')
-- alias = "python-3.12",
-- link = "library/asyncio-subprocess#asyncio.subprocess.Process",
-- name = "asyncio.subprocess.Process",
-- next_path = "46,`coroutine wait()`",
-- path = "46,`class asyncio.subprocess.Process`"

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
