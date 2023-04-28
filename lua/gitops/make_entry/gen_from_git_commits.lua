local entry_display = require('telescope.pickers.entry_display')

-- local handle_entry_index = function(opts, t, k)
--   local override = ((opts or {}).entry_index or {})[k]
--   if not override then
--     return
--   end
--
--   local val, save = override(t, opts)
--   if save then
--     rawset(t, k, val)
--   end
--   return val
-- end
--
-- local set_default_entry_mt = function(tbl, opts)
--   return setmetatable({}, {
--     __index = function(t, k)
--       local override = handle_entry_index(opts, t, k)
--       if override then
--         return override
--       end
--
--       -- Only hit tbl once
--       local val = tbl[k]
--       if val then
--         rawset(t, k, val)
--       end
--
--       return val
--     end,
--   })
-- end
--
local function gen_from_git_commits(opts)
  opts = opts or {}

  local displayer = entry_display.create({
    separator = ' ',
    items = {
      { width = 8 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.value, 'TelescopeResultsIdentifier' },
      entry.msg,
    })
  end

  return function(entry)
    if entry == '' then
      return nil
    end

    local sha, msg = string.match(entry, '([^ ]+) (.+)')

    if not msg then
      sha = entry
      msg = '<empty commit message>'
    end
    vim.dbglog('ENTRY', entry)
    return {
      value = sha,
      ordinal = sha .. ' ' .. msg,
      msg = msg,
      display = make_display,
      current_file = opts.current_file,
    }
  end
end

return gen_from_git_commits
