local search_func = require('gitops.search')
local diff_func = require('gitops.diff')
local core_func = require('gitops.core')
local git_utils = require('gitops.utils.git')
local utils = require('gitops.utils')

local is_git_repo = function(bufnr)
  local repo = git_utils.get_repo(bufnr)
  return repo.gitdir
end

local git_pickers = {
  {
    desc = 'Git commits',
    enabled = is_git_repo,
    name = 'commits',
    func = core_func.commits,
    summary = core_func.commits_stats,
  },
  {
    desc = 'Git bcommits (file)',
    enabled = is_git_repo,
    name = 'bcommits',
    func = core_func.bcommits,
    summary = core_func.bcommits_stats,
  },
  {
    desc = 'Find in repo log content',
    enabled = is_git_repo,
    name = 'search_content',
    func = search_func.search_commits,
    summary = function() return 'search' end,
  },
  {
    desc = 'Find in file log content',
    enabled = is_git_repo,
    name = 'search_content_file',
    func = search_func.search_commits_file,
    summary = function() return 'search file' end,
  },
  {
    desc = 'All changes on branch',
    enabled = is_git_repo,
    name = 'diff_branch',
    func = diff_func.diff_branch,
    summary = function() return 'diff' end,
  },
  {
    desc = 'Diff file with branch',
    enabled = is_git_repo,
    name = 'diff_branch_file',
    func = diff_func.diff_branch_file,
    summary = function() return 'diff' end,
  },
  {
    desc = 'Diff file with previous commit',
    enabled = is_git_repo,
    name = 'diff_commit_file',
    func = diff_func.diff_commit_file,
    summary = function() return 'diff' end,
  },
  {
    desc = 'Diff file with selected line history',
    enabled = is_git_repo,
    name = 'diff_commit_line',
    func = diff_func.diff_commit_line,
    summary = function() return 'diff' end,
  },
  {
    desc = 'Checkout from reflog',
    enabled = is_git_repo,
    name = 'checkout_reflog',
    func = search_func.checkout_reflog,
    summary = function() return 'reflog' end,
  },
}

local get_git_pickers = function(bufnr)
  local entries = {}
  for _, git_picker in ipairs(git_pickers) do
    local is_enabled = git_picker.enabled(bufnr)
    if is_enabled then
      local summary = git_picker.summary(bufnr) or { ' ' }
      if type(summary) == 'table' then
        summary = vim.fn.join({ summary.count or '', summary.range or '' }, ' ')
      end
      table.insert(entries, {
        tostring(summary),
        (git_picker.name or ''),
        (git_picker.desc or ''),
      })
    end
  end
  local widths = utils.get_widths(entries)
  return entries, widths
end

return { get_git_pickers = get_git_pickers }
