local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local ags_finders = require('gitops.finders')
local ags_mappings = require('gitops.mappings')
local git_utils = require('gitops.utils.git')
local M = {}

--- Opens a Telescope window with a list of local branches
M.diff_branch_file = function(opts)
  -- local previewers = require('telescope.previewers')
  local current_branch = git_utils.current_branch()
  local bufnr = vim.fn.bufnr()

  local count = 0
  opts.entry_maker = function(arg1, arg2, arg3)
    count = count + 1
    vim.dbglog('ENTRY MAKER', count, arg1, arg2, arg3)
  end
  pickers
    .new({
      results_title = 'Local branches :: *' .. current_branch,
      prompt_title = 'Branch name',
      finder = ags_finders.git_branches_finder(),
      sorter = sorters.get_fuzzy_file(),
      -- previewer = ags_previewers.git_diff_branch_file_previewer(bufnr),
      attach_mappings = function(_, map)
        ags_mappings.open_diff_view_current_file_selected_branch(map)
        return true
      end,
    }, {})
    :find()
end

M.diff_branch_file_summary = function(bufnr, _opts)
  local count = 0
  local opts = _opts or {}
  vim.dbglog('GIT BRANCH SUMMARY', bufnr, count)
  opts.entry_maker = function(arg1, arg2, arg3)
    count = count + 1
    vim.dbglog('ENTRY MAKER', count, arg1, arg2, arg3)
  end
  return ags_finders.git_branches_finder(bufnr, opts)
end

return M
