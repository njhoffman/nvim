local timeago = require('telescope._extensions.undo.timeago')

-- the following prefix should work out to this graph structure:
-- state #1
-- └─state #2
-- state #3
-- ├─state #4
-- └─state #5
-- state #6
-- ├─state #7
-- ┆ ├─state #8
-- ┆ └─state #9
-- └─state #10

local parse_line = function(undo, order, opts)
  local prefix = ''
  if undo.alt > 0 then
    prefix = string.rep('┆ ', undo.alt - 1)
    if undo.first then
      local corner = order == 'ascending' and '┌' or '└'
      prefix = prefix .. corner .. '╴'
    else
      prefix = prefix .. '├╴'
    end
  end
  local diff_added = '  '
  local diff_deleted = '  '
  if #undo.additions > 0 then
    diff_added = '+' .. #undo.additions
  end
  if #undo.deletions > 0 then
    diff_deleted = '-' .. #undo.deletions
  end
  local formatted_time = opts.time_format == '' and timeago(undo.time) or os.date(opts.time_format, undo.time)

  local fields = {
    prefix = prefix,
    -- diff_added = diff_added,
    -- diff_deleted = diff_deleted,
    diff_added = '',
    diff_deleted = '',
    formatted_time = formatted_time,
  }
  fields.node = ''
  -- if undo.first then
  --   fields.node = ''
  if type(undo.curhead) == 'number' then
    fields.node = ''
  elseif type(undo.save) == 'number' then
    fields.node = ''
  end
  return fields
end

return parse_line
