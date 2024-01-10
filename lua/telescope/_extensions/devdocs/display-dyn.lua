-- alias = "python-3.12",
-- link = "library/asyncio-subprocess#asyncio.subprocess.Process",
-- name = "asyncio.subprocess.Process",
-- next_path = "46,`coroutine wait()`",
-- path = "46,`class asyncio.subprocess.Process`"
-- 1821: asyncio.subprocess.Process      library/asyncio-subprocess#asyncio.subprocess.Process   37      21      0

local entry_display = require('telescope.pickers.entry_display')

local displayer = entry_display.create({
  separator = ' ▏',
  items = {
    { width = 10 },
    { remaining = true },
  },
})

local function make_display(entry)
  -- concatenating multiline env values
  return displayer({
    { entry.value[1], 'TelescopeResultsClass' },
    { entry.value[2] },
  })
end

local entry_maker = function(line)
  -- vim.dbglog('LINE', line)
  -- table.insert(results, line)
  local entry = vim.fn.split(line, '\t')
  return {
    value = entry,
    display = make_display,
    ordinal = string.format('%s %s', entry[1], entry[2]),
  }
end

return entry_maker
