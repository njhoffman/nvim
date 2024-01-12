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

local make_display = function(entry)
  return displayer({
    { entry.value.alias, 'TelescopeResultsClass' },
    { entry.value.name },
  })
end

local entry_maker = function(line)
  -- vim.dbglog('LINE', line)
  -- table.insert(results, line)
  -- lodash-4        Array   _.zipWith       0       index#zipWith   1,### _.zipWith([arrays], [iteratee=_.identity])[source](https://github.com/lodash/lodash/blob/4.17.10/lodash.js#L8698) [npm package](https://www.npmjs.com/package/lodash.zipwith)
  local parts = vim.fn.split(line, '\t')
  local entry = {
    alias = parts[1],
    type = parts[2],
    name = parts[3],
    line_count = parts[4],
    link = parts[5],
    path = parts[6],
    next_path = parts[7],
  }
  return {
    value = entry,
    display = make_display,
    ordinal = string.format('%s %s %s', entry.alias, entry.type, entry.name),
  }
end

return entry_maker
