local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local ags_finders = require('gitops.finders')
local ags_previewers = require('gitops.previewers')
local git_utils = require('gitops.utils.git')

local M = {}

M.diff_branch = function(opts)
  opts = opts or {}
  local bufnr = vim.fn.bufnr()
  pickers
    .new(opts, {
      results_title = 'Modified ' .. git_utils.base_branch() .. ' -> ' .. git_utils.current_branch(),
      sorter = sorters.get_fuzzy_file(),
      finder = ags_finders.changed_files_on_branch(bufnr),
      previewer = ags_previewers.changed_files_on_current_branch(),
    })
    :find()
end

M.diff_branch_summary = function()
  return 'diff branch'
end

return M
