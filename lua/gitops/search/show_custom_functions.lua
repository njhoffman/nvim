local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

local ags_mappings = require('gitops.mappings')

local git_functions = {
  { value = 'Find in repo log content', func = require('gitops.search').search_commits },
  { value = 'Find in file log content', func = require('gitops.search').search_commits_file },
  { value = 'Changed on current branch', func = require('gitops.diff').diff_branch },
  { value = 'Diff file with branch', func = require('gitops.diff').diff_branch_file },
  { value = 'Diff file with previous commit', func = require('gitops.diff').diff_commit_line },
  {
    value = 'Diff file with selected line history',
    func = M.diff_commit_line,
  },
  { value = 'Checkout from reflog', require('gitops.search.checkout_reflog').checkout_reflog },
}

local function execute_git_function(value)
  for _, v in pairs(git_functions) do
    if v['value'] == value then
      v['func']()
      return
    end
  end
end

local function map_item(git_functions_table, f)
  local t = {}
  for k, v in pairs(git_functions_table) do
    t[k] = f(v)
  end
  return t
end

local M = {}
--- Opens all a selector for all advanced git search functions
M.show_custom_functions = function()
  pickers
    .new({
      results_title = 'Git action',
      finder = finders.new_table(map_item(git_functions, function(item)
        return item['value']
      end)),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(_, map)
        ags_mappings.omnimap(map, '<CR>', function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          execute_git_function(selection.value)
        end)

        return true
      end,
    }, {})
    :find()
end

return M
