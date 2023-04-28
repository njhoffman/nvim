local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local ags_finders = require('gitops.finders')
local ags_mappings = require('gitops.mappings')

local M = {}

-- Opens a Telescope window with a list of git commits which changed the current file (renames included)
M.diff_commit_file = function()
  local bufnr = vim.fn.bufnr()
  pickers
    .new({
      results_title = 'BCommits ',
      prompt_title = 'Git Commits for File',
      finder = ags_finders.git_log_file_finder(bufnr, { bufnr = bufnr }),
      -- previewer = ags_previewers.git_diff_commit_file_previewer(bufnr),
      sorter = sorters.highlighter_only(),
      attach_mappings = function(_, map)
        ags_mappings.open_diff_view_current_file_selected_commit(map)
        ags_mappings.show_entire_commit(map)
        ags_mappings.open_selected_commit_in_browser(map)
        ags_mappings.copy_commit_hash_to_clipboard(map)

        return true
      end,
    }, {})
    :find()
end

M.diff_commit_file_summary = function(bufnr, opts)
  opts = opts or {}
  opts.bufnr = bufnr
  local results = ags_finders.git_log_file_finder(bufnr, opts).results
  return results
end

return M
