local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local entry_display = require('telescope.pickers.entry_display')

local ags_mappings = require('gitops.mappings')

local git_functions = {
  {
    id = 'commits',
    value = function()
      local stats = require('gitops.core.commits').stats()
      return 'Commits:  Search ' .. stats.count .. ' commits over ' .. stats.range
    end,
    func = require('gitops.core.commits').commits,
  },
  {
    id = 'bcommits',
    value = function()
      local stats = require('gitops.core.bcommits').stats()
      return 'BCommits: Search ' .. stats.count .. ' commits over ' .. stats.range .. ' for file: ' .. stats.file
    end,
    func = require('gitops.core.bcommits').bcommits,
  },
  {
    id = 'files',
    value = 'Git files',
    func = require('gitops.core.files').files,
  },
  {
    id = 'stash',
    value = 'Git stash',
    func = require('gitops.core.stash').stash,
  },
  {
    id = 'status',
    value = 'Git status',
    func = require('gitops.core.status').status,
  },
  {
    id = 'branches',
    value = 'Git branches',
    func = require('gitops.core.branches').branches,
  },
  {
    id = 'search_commits',
    value = 'Search:   Search in content history',
    func = require('gitops.search.search_commits').search_commits,
  },
  {
    id = 'search_commits_file',
    value = 'BSearch:  Search in file content history',
    func = require('gitops.search.search_commits_file').search_commits_file,
  },
  {
    id = 'diff_branch',
    value = 'Changed files on current branch',
    func = require('gitops.diff').diff_branch,
  },
  {
    id = 'diff_branch_file',
    value = 'Diff file with branch',
    func = require('gitops.diff').diff_branch_file,
  },
  {
    id = 'diff_commit_file',
    value = 'Diff file with previous commit',
    func = require('gitops.diff').diff_commit_file,
  },
  {
    id = 'diff_commit_line',
    value = 'Diff file selected line history',
    func = require('gitops.diff').diff_commit_line,
  },
  {
    id = 'checkout_reflog',
    value = 'Checkout from reflog',
    func = require('gitops.search.checkout_reflog').checkout_reflog,
  },
}

local function execute_git_function(id)
  for _, v in pairs(git_functions) do
    if v['id'] == id then
      v['func']()
      return
    end
  end
end

local M = {}

M.show_custom_functions = function()
  pickers
    .new({}, {
      results_title = 'Git action',
      finder = finders.new_table({
        results = vim.tbl_map(function(item)
          if type(item['value']) == 'function' then
            return { item['id'], item['value']() }
          else
            return { item['id'], item['value'] }
          end
        end, git_functions),
        entry_maker = function(entry)
          local displayer = entry_display.create({
            items = {
              { remaining = true },
            },
          })
          local function make_display()
            return displayer({
              { entry[2], 'TelescopeResults' },
            })
          end

          return {
            value = entry,
            display = make_display,
            ordinal = string.format('%s %s', entry[1], entry[2]),
          }
        end,
      }),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(_, map)
        ags_mappings.omnimap(map, '<CR>', function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          execute_git_function(selection.value[1])
        end)
        return true
      end,
    })
    :find()
end

return M
