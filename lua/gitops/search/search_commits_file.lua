local pickers = require('telescope.pickers')
local ags_finders = require('gitops.finders')

local ags_mappings = require('gitops.mappings')

local M = {}
--- Same as `search_log_content` but with respect to the current file
M.search_commits_file = function()
  -- local file_name = vim.fn.expand("%")
  local relative_file_name = vim.fn.expand('%:~:.')
  local bufnr = vim.fn.bufnr()

  -- git log -L741,751:'app/models/patients/patient.rb' \
  -- --format='%C(auto)%h \t %as \t %C(green)%an _ %Creset %s'
  pickers
    .new({
      prompt_title = 'Git Grep BCommits',
      results_title = 'Git Grep (' .. relative_file_name .. ')',
      finder = ags_finders.git_log_content_finder(bufnr, {
        bufnr = bufnr,
      }),
      -- previewer = ags_previewers.git_diff_content_previewer(),
      -- sorter = sorters.highlighter_only(),
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

M.search_commits_file_summary = function(bufnr)
  return 'search_log_content_file_summary'
end
return M
