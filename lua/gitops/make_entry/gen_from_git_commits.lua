local entry_display = require('telescope.pickers.entry_display')

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

local function gen_from_git_commits(opts)
  return function(w)
    opts = opts or {}
    -- 4 files   5   20 
    -- 4   20   5 
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
        ordinal = entry.sha .. ' ' .. entry.message,
        display = make_display,
        current_file = opts.current_file,
      }
    end
  end
end

return gen_from_git_commits
