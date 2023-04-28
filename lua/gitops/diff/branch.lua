local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local ags_finders = require('gitops.finders')
local git_utils = require('gitops.utils.git')

local M = {}

--- Opens a Telescope window with all files changed on the current branch
--- Only committed changes will be displayed
M.diff_branch = function()
  pickers
    .new({
      results_title = 'Modified ' .. git_utils.base_branch() .. ' -> ' .. git_utils.current_branch(),
      sorter = sorters.get_fuzzy_file(),
      finder = ags_finders.changed_files_on_current_branch_finder(),
      -- previewer = ags_previewers.changed_files_on_current_branch_previewer(),
    }, {})
    :find()
end

M.diff_branch_summary = function(bufnr)
  return 'diff branch'
end

return M
