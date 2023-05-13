local entry_display = require('telescope.pickers.entry_display')
local state = require('telescope.state')

-- stylua: ignore
local setup_highlights = function()
  vim.api.nvim_set_hl(0, 'TelescopeGitSha',             { default = true, link = 'Keyword' })
  vim.api.nvim_set_hl(0, 'TelescopeGitDate',            { default = true, link = 'Comment' })
  vim.api.nvim_set_hl(0, 'TelescopeGitMessage',         { default = true, link = 'TelescopeNormal' })
  vim.api.nvim_set_hl(0, 'TelescopeGitAuthor',          { default = true, link = 'Comment' })
  vim.api.nvim_set_hl(0, 'TelescopeGitStatsFiles',      { default = true, link = 'GitSignsChange' })
  vim.api.nvim_set_hl(0, 'TelescopeGitStatsInsert',     { default = true, link = 'GitSignsAdd' })
  vim.api.nvim_set_hl(0, 'TelescopeGitStatsDelete',     { default = true, link = 'GitSignsDelete' })
  vim.api.nvim_set_hl(0, 'TelescopeGitStatsFilesIcon',  { default = true, link = 'GitSignsChange' })
  vim.api.nvim_set_hl(0, 'TelescopeGitStatsInsertIcon', { default = true, link = 'GitSignsAdd' })
  vim.api.nvim_set_hl(0, 'TelescopeGitStatsDeleteIcon', { default = true, link = 'GitSignsDelete' })
end

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

local resolve_widths = function(opts, widths)
  local winwidth = vim.api.nvim_win_get_width(0) * (opts.theme ~= 'ivy' and 0.8 or 1)
  local defaults = { sha = 10, date = 8, message = -1, author = 20, stat_files = 5, stat_insert = 8, stat_delete = 8 }
  local maximums = { author = 20 }
  local res = {}
  for key, default_width in pairs(defaults) do
    res[key] = type(widths[key]) == 'number' and widths[key] or default_width
    if type(maximums[key]) == 'number' and maximums[key] < res[key] then
      res[key] = maximums[key]
    end
  end
  local total = res.sha + res.date + res.author + res.stat_files + res.stat_insert + res.stat_delete + 19
  res.message = math.floor(winwidth - total)
  return res
end

local function gen_from_git_commits(opts)
  return function(widths, timing)
    -- 4 files   5   20 
    -- 4   20   5 
    opts = opts or {}
    local w = resolve_widths(opts, widths)
    local displayer = entry_display.create({
      separator = ' ',
      items = {
        { width = w.sha },
        { width = w.date, right_justify = true },
        { width = w.message },
        { width = w.author, right_justify = true },
        { width = w.stat_files + 3, right_justify = true },
        { width = w.stat_insert + 3, right_justify = true },
        { width = w.stat_delete + 3, right_justify = true },
      },
    })

    if not timing.first_entry then
      ---@diagnostic disable-next-line: missing-parameter
      timing.first_entry = vim.fn.reltimestr(vim.fn.reltime(timing.total))
    end

    local make_display = function(entry)
      -- strings.align_str(entry.hash, widths.name, true),

      return displayer({
        { entry.value.sha, 'TelescopeGitSha' },
        { entry.value.date, 'TelescopeGitDate' },
        { entry.value.message, 'TelescopeGitMessage' },
        { entry.value.author, 'TelescopeGitAuthor' },
        { entry.value.stat_files .. '  ', 'TelescopeGitStatsFiles' },
        { entry.value.stat_insert .. '  ', 'TelescopeGitStatsInsert' },
        { entry.value.stat_delete .. '  ', 'TelescopeGitStatsDelete' },
        -- { entry., 'TelescopeResultsIdentifier' },
      })
    end

    setup_highlights()

    return function(entry)
      return {
        value = entry,
        ordinal = (entry.sha or '') .. ' ' .. (entry.message or ''),
        display = make_display,
        current_file = opts.current_file,
      }
    end
  end
end

return gen_from_git_commits
