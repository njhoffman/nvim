-- alias = "python-3.12",
-- link = "library/asyncio-subprocess#asyncio.subprocess.Process",
-- name = "asyncio.subprocess.Process",
-- next_path = "46,`coroutine wait()`",
-- path = "46,`class asyncio.subprocess.Process`"
-- 1821: asyncio.subprocess.Process      library/asyncio-subprocess#asyncio.subprocess.Process   37      21      0

local utils = require('telescope._extensions.devdocs.utils')
local entry_display = require('telescope.pickers.entry_display')

local create_displayer = function(widths, state)
  local displayer = entry_display.create({
    separator = ' ▏',
    separator_hl = 'TelescopeResultsSeparator',
    items = {
      { width = widths.slug },
      { width = 25 },
      { width = 25 },
    },
  })
  return displayer
end

local displayer
local make_display = function(widths)
  return function(entry, state)
    if displayer == nil then
      displayer = create_displayer(widths, state)
    end
    return displayer({
      { entry.value.alias, 'TelescopeResultsClass' },
      { entry.value.type },
      { entry.value.name },
    })
  end
end

local create_entry_maker = function(installed)
  local widths = utils.get_widths(installed)
  local entry_maker = function(line)
    local parts = vim.fn.split(line, '\t')
    local value = {
      alias = parts[1],
      type = parts[2],
      name = parts[3],
      line_count = parts[4],
      link = parts[5],
      path = parts[6],
      next_path = parts[7],
    }
    return {
      value = value,
      display = make_display(widths),
      ordinal = string.format('%s', value.alias, value.type, value.name),
    }
  end
  return entry_maker
end

return create_entry_maker
