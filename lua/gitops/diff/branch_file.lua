local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local ags_finders = require('gitops.finders')
local ags_previewers = require('gitops.previewers')
local ags_mappings = require('gitops.mappings')
local git_utils = require('gitops.utils.git')

local M = {}

M.diff_branch_file = function(opts)
  opts = opts or {}
  local current_branch = git_utils.current_branch()
  local bufnr = vim.fn.bufnr()

  pickers
    .new(opts, {
      results_title = 'Local branches :: *' .. current_branch,
      prompt_title = 'Branch name',
      finder = ags_finders.git_branches(bufnr),
      sorter = sorters.get_fuzzy_file(),
      previewer = ags_previewers.diff_branch_file_previewer(bufnr),
      attach_mappings = function(_, map)
        ags_mappings.open_diff_view_current_file_selected_branch(map)
        return true
      end,
    })
    :find()
end

M.diff_branch_file_summary = function(bufnr, opts)
  opts = opts or {}
  return ags_finders.git_branches(bufnr, opts)
end

return M
