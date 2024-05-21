local state = require('histories.state')
local select_utils = require('histories.select.utils')

local last = { select = nil, change = nil }

local check_selects = function(max)
  local curr, hash = select_utils.get_pos()
  if
    last.change ~= hash.change
    and vim.fn.join(curr.change.from, ' ') ~= vim.fn.join(curr.change.to, ' ')
  then
    last.change = hash.change
    table.insert(
      state.selects,
      vim.tbl_deep_extend('force', {}, curr.change, {
        name = vim.api.nvim_buf_get_name(curr.change.to[1]),
        time = os.time(),
        type = 'change',
      })
    )
  end

  if
    last.select ~= hash.select
    and last.change ~= hash.select
    and vim.fn.join(curr.select.from, ' ') ~= vim.fn.join(curr.select.to, ' ')
  then
    last.select = hash.select
    table.insert(
      state.selects,
      vim.tbl_deep_extend('force', {}, curr.select, {
        name = vim.api.nvim_buf_get_name(curr.select.to[1]),
        time = os.time(),
        type = 'select',
      })
    )
  end
  -- trim entries after max_selects
  for _ = 1, #state.selects - max do
    table.remove(state.selects, 1)
  end
  select_utils.log_selects()
end

local watch = function(max)
  vim.api.nvim_create_autocmd({ 'ModeChanged' }, {
    group = state.augroup,
    pattern = '*:*',
    desc = 'Track changes out of visual mode to track selects history',
    callback = function(ev)
      local from, to = unpack(vim.split(ev.match, ':'))
      if
        (from == 'v' or from == 'V' or from == '') and (to ~= 'v' and to ~= 'V' and to ~= '')
      then
        check_selects(max)
      end
    end,
  })
end

-- vim.paste = (function(overridden)
--   return function(lines, phase)
--     for i,line in ipairs(lines) do
--       -- Scrub ANSI color codes from paste input.
--       lines[i] = line:gsub('\27%[[0-9;mK]+', '')
--     end
--     overridden(lines, phase)
--   end
-- end)(vim.paste)

return { watch = watch }
