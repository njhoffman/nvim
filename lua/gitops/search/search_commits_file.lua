local pickers = require('telescope.pickers')
local ags_finders = require('gitops.finders')
local ags_previewers = require('gitops.previewers')
local ags_mappings = require('gitops.mappings')

local M = {}

M.search_commits_file = function(opts)
  opts = opts or {}
  local relative_file_name = vim.fn.expand('%:~:.')
  local bufnr = vim.fn.bufnr()

  pickers
    .new(opts, {
      prompt_title = 'Git Grep BCommits',
      results_title = 'Git Grep (' .. relative_file_name .. ')',
      finder = ags_finders.git_log_content(bufnr, { bufnr = bufnr }),
      previewer = ags_previewers.diff_content_previewer(),
      attach_mappings = function(_, map)
        ags_mappings.open_diff_view_current_file_selected_commit(map)
        ags_mappings.open_selected_commit_in_browser(map)
        ags_mappings.copy_commit_hash_to_clipboard(map)
        ags_mappings.show_entire_commit(map)
        return true
      end,
    })
    :find()
end

M.search_commits_file_summary = function()
  return 'search file content history'
end

return M
