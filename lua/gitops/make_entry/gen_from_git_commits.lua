local entry_display = require('telescope.pickers.entry_display')
local state = require('telescope.state')
local ops_utils = require('gitops.utils')

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

local parse_author = function(author)
  return author
end

local parse_date = function(time_ago, short_level)
  --    a:6         b:10                c:24
  --    13h      13 hours       1 year, 11 months ago
  --   6d.3h      6 days
  --   2w.4d      2 weeks
  --    12m      12 months
  --    1y        1 year
  --  1y.11m     1 yr 11 mo
  --    2y        2 years

  local date = string.gsub(time_ago, '[)(]+', '')
  if short_level == 1 then
    date = string.gsub(date, ' ago', '')
    if string.match(date, 'years?,') then
      date = string.gsub(date, ' years?,? ?', 'yr ')
      date = string.gsub(date, ' months? ?', 'mo')
    end
  elseif short_level == 2 then
    date = string.gsub(date, ' ago', '')
    date = string.gsub(date, ' ?hours?', 'h')
    date = string.gsub(date, ' ?weeks?', 'w')
    date = string.gsub(date, ' ?days?', 'd')
    if string.match(date, 'years?, ') then
      date = string.gsub(date, ' years?,? ?', 'y.')
      date = string.gsub(date, ' ?months? ?', 'm')
    end
    date = string.gsub(date, ' years?', 'y')
    date = string.gsub(date, ' months?', 'm')
  end
  local width = short_level == 2 and 8 or short_level == 1 and 12 or 24
  return ops_utils.align_text(date, 'center', width, ' ')
  -- return date
end

-- 4 files   5   20 
-- 4   20   5 
local parse_log_line = function(line)
  local parsed = {}
  for _, key in pairs({ 'sha', 'date', 'message', 'author', 'stat_files', 'stat_insert', 'stat_delete' }) do
    parsed[key] = '--'
  end

  local parts = vim.fn.split(line, ' ')
  if type(parts) ~= 'table' or vim.tbl_count(parts) > 5 then
    vim.notify('Bad response: ' .. vim.inspect(parts), 4)
  else
    parsed = vim.tbl_deep_extend('force', parsed, {
      sha = parts[1],
      date = parse_date(parts[2], 2),
      message = parts[3] or '<empty commit>',
      author = parse_author(parts[4]),
      stat_files = parts[5] and string.match(parts[5], '(%d+) files? changed') or '0',
      stat_insert = parts[5] and string.match(parts[5], '(%d+) insertions?') or '0',
      stat_delete = parts[5] and string.match(parts[5], '(%d+) deletions?') or '0',
    })
  end
  return parsed
end

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
  -- 4 files   5   20 
  -- 4   20   5 
  opts = opts or {}
  local w = resolve_widths(opts, {})
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

  -- if not timing.first_entry then
  --   ---@diagnostic disable-next-line: missing-parameter
  --   timing.first_entry = vim.fn.reltimestr(vim.fn.reltime(timing.total))
  -- end
  --
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

  return function(line)
    local entry = parse_log_line(line)
    return {
      value = entry,
      ordinal = (entry.sha or '') .. ' ' .. (entry.message or ''),
      display = make_display,
      current_file = opts.current_file,
    }
  end
end

return gen_from_git_commits
