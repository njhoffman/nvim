local pickers = require('telescope.pickers')
local ags_finders = require('gitops.finders')
local ags_previewers = require('gitops.previewers')
local git_utils = require('gitops.utils.git')

local ags_mappings = require('gitops.mappings')

local M = {}

--- Opens a Telescope window with a list of previous commits.
--- Query is used to filter the results based on the content of the commit (added or removed text).
M.search_commits = function(opts)
  -- git log -L741,751:'app/models/patients/patient.rb' \
  -- --format='%C(auto)%h \t %as \t %C(green)%an _ %Creset %s'
  local bufnr = vim.fn.bufnr()
  local count = git_utils.file_count(bufnr, opts.cwd or vim.fn.getcwd())
  pickers
    .new({
      prompt_title = 'Git Grep Commits',
      results_title = 'Git Grep All (' .. count .. ' files)',
      finder = ags_finders.git_log_content(bufnr, {}),
      previewer = ags_previewers.diff_content_previewer(),
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

M.search_commits_summary = function(bufnr)
  local repo = git_utils.get_repo(bufnr)
  return repo.gitdir
end

return M
