local timeago = require('telescope._extensions.undo.timeago')

local format_line = function(undo, fields, opts)
  local line_parts = {
    ['$ID'] = undo.seq,
    ['$NODE'] = fields.node,
    ['$STAT'] = fields.diffstat,
    ['$TIME'] = fields.formatted_time,
  }
  local line = fields.prefix .. opts.entry_format
  for key, value in pairs(line_parts) do
    line = line:gsub(key, value)
  end
  return line
end

-- ├ ─ ┤         ┘ ─ ─ └ ┘┌ ─  ┤ ╴─╶ ╰ ╯ ┘-- │┌ ┴ ┐┬ ┌ ┬ ├ ─ ├ ┐  ╴─╶ ╰ ╯ ┘
--      (+7)  [3]  4 hours ago
-- ├─   (-3)  [4]  4 hours ago
-- └─   (+2)  [5]  4 hours ago
local parse_line = function(undo, order, opts)
  local symbolsAscending = {
    first = '└', --            [6]
    middle = '┌', -- ├─         [7] 4 hours ago
    dash = '╴', -- ┆ ├─       [8] 3 hours ago
    vertical = '│', -- ┆ └─       [9]
    dash_wide = '─', -- └─        [10]
    add = '+',
    del = '-',
  }

  local symbolsDescending = {
    first = '┘', --     
    middle = '┤', --    │     (-1) [20]
    dash = '╶', -- │        (-1) [19]
    vertical = ' │', -- │ ╶┘     (-1) [18]
    dash_wide = '─', -- │        (-1) [16]
    add = '+', -- ╶┘
    del = '-', -- 
  }

  local fields = {}
  -- when order value equals 'descending' it is actually ascending and vice versa
  local symbols = order == 'ascending' and symbolsDescending or symbolsAscending
  fields.prefix = ''
  if undo.alt > 0 then
    fields.prefix = string.rep(symbols.vertical, undo.alt - 1)
    if undo.first then
      local corner = symbols.first
      fields.prefix = fields.prefix .. symbols.dash .. corner
    else
      fields.prefix = fields.prefix .. symbols.middle
    end
  end

  fields.node = '  ' --
  if undo.first then
    fields.node = '  '
  elseif type(undo.save) == 'number' then
    fields.node = '  '
  end

  fields.diffstat = ''
  if #undo.additions > 0 then
    fields.diffstat = symbols.add .. #undo.additions
  end
  if #undo.deletions > 0 then
    if fields.diffstat ~= '' then
      fields.diffstat = fields.diffstat .. ' '
    end
    fields.diffstat = symbols.del .. #undo.deletions
  end
  fields.formatted_time = opts.time_format == '' and timeago(undo.time) or os.date(opts.time_format, undo.time)
  return fields
end

local order = require('telescope.config').values.sorting_strategy
local entry_maker = function(opts)
  return function(undo)
    -- TODO: show a table instead of a list
    if #undo.additions + #undo.deletions == 0 then
      -- skip empty changes, vim has these sometimes...
      return nil
    end
    local fields = parse_line(undo, order, opts)
    return {
      value = undo,
      display = format_line(undo, fields, opts),
      ordinal = undo.ordinal,
    }
  end
end
local setup = function(opts)
  opts = opts or {}
  opts.entry_maker = entry_maker
  return entry_maker(opts)
end

return setup
