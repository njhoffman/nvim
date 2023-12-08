local timeago = require('telescope._extensions.undo.timeago')

  -- stylua: ignore
  -- oldest to most recent
  local symbolsAscending = {
    first = '└',     --            [6]  ╶┐
    middle = '┌',    -- ├─         [7]    ╶┐
    dash = '╴',      -- ┆ ├─       [8]    ┆ 
    vertical = '│',  -- ┆ └─       [9]    ┆ 
    dash_wide = '─', -- └─        [10]    
    add = '+',
    del = '-',
  }
  -- stylua: ignore
  -- most recent to oldest
  local symbolsDescending = {
    first = '└',              --                          
    middle = ' ├',            --    │     (-1) [20]      │
    dash = '╶',               -- ┆        (-1) [19]   │ ┌─
    vertical = '│',           -- ┆ ╶┘     (-1) [18]   │ 
    vertical_dotted = '┆',    -- ┆        (-1) [17]   │ 
    dash_wide = '─',          -- ┆        (-1) [16]   ├─
    add = '+',                -- ╶┘                   
    del = '-',                --                      
  }

-- stylua: ignore
--    (-1) [6] 34 minutes ago          (-1)          alt=0 seq=6 save=5
-- ╶┘   (-1) [5] 34 minutes ago      ┆   (-1)        alt=1 seq=5 save=3
-- ┤   (-1) [4] 34 minutes ago       ┆   (-1)        alt=1 seq=4 save=2
--    (-1) [3] 35 minutes ago        ╶┘ (-1)         alt=0 seq=3 save=4
--    (-1) [2] 35 minutes ago          (-1)          alt=0 seq=2
--    (+4) [1] 35 minutes ago          (+4)          alt=0 seq=1
-- ┤│├ ┆ ─ ╴╶ ╴╶ -- ─ └ ┘┴╰ ╯ ┐┌ ┌╶┐┬ ┌ ┬   

local last_alt = -1
local prev_alts = {}

local parse_line = function(undo, order, opts)
  local fields = {}
  -- when order value equals 'descending' it is actually ascending and vice versa
  local symbols = order == 'ascending' and symbolsDescending or symbolsAscending

  if undo.alt < last_alt then
    fields.suffix = string.rep('─', undo.alt - last_alt - 1)
    fields.suffix = fields.suffix .. '╶┘'
    prev_alts[last_alt] = nil
  elseif undo.alt > last_alt then
    prev_alts[undo.alt] = true
  end

  if undo.alt > 0 then
    fields.prefix = ''
    for i = 1, undo.alt do
      if prev_alts[i] then
        fields.prefix = fields.prefix .. '┆ '
      else
        fields.prefix = fields.prefix .. '  '
      end
    end
  end

  fields.node = ''
  -- if undo.first then
  --   fields.node = ''
  if type(undo.curhead) == 'number' then
    fields.node = ''
  elseif type(undo.save) == 'number' then
    fields.node = ''
  end

  if #undo.additions > 0 then
    fields.diff_added = '+' .. #undo.additions
  end
  if #undo.deletions > 0 then
    fields.diff_deleted = '-' .. #undo.deletions
  end

  fields.formatted_time = opts.time_format == '' and timeago(undo.time) or os.date(opts.time_format, undo.time)
  last_alt = undo.alt
  return fields
end

return parse_line
