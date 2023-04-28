local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local ags_finders = require('gitops.finders')
local ags_mappings = require('gitops.mappings')

local M = {}

--- Opens a Telescope window with a list of previous commit logs with respect to selected lines
M.diff_commit_line = function()
  local bufnr = vim.fn.bufnr()
  local opts = {
    bufnr = bufnr,
    s_start = vim.fn.getpos("'<")[2],
    s_end = vim.fn.getpos("'>")[2],
  }

  -- git log -L741,751:'app/models/patients/patient.rb'\
  -- --format='%C(auto)%h \t %as \t %C(green)%an _ %Creset %s'
  pickers
    .new({
      results_title = 'BCommits',
      prompt_title = 'Git Commits for Selected Lines',
      finder = ags_finders.git_log_location_finder(bufnr, opts),
      -- previewer = ags_previewers.git_diff_commit_file_previewer(bufnr),
      sorter = sorters.highlighter_only(),
      attach_mappings = function(_, map)
        ags_mappings.open_diff_view_current_file_selected_commit(map)
        ags_mappings.open_selected_commit_in_browser(map)
        ags_mappings.copy_commit_hash_to_clipboard(map)
        ags_mappings.show_entire_commit(map)
        return true
      end,
    }, {})
    :find()
end

M.diff_commit_line_summary = function(bufnr, _opts)
  local opts = vim.tbl_deep_extend('force', {
    bufnr = bufnr,
    s_start = vim.fn.getpos("'<")[2],
    s_end = vim.fn.getpos("'>")[2],
  }, _opts or {})

  local count = 0
  opts.entry_maker = function(arg1, arg2, arg3)
    count = count + 1
    vim.dbglog('EM', arg1, arg2, arg3)
  end
  local results = ags_finders.git_log_location_finder(bufnr, opts).results
  return tostring(results)
end

return M
