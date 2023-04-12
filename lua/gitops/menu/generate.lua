local search_func = require("gitops.search")
local diff_func = require("gitops.diff")
local core_func = require("gitops.core")
local git_utils = require("gitops.utils.git")
local utils = require("gitops.utils")

local is_git_repo = function(bufnr)
  -- bufnr = bufnr or vim.api.nvim_get_current_buf()
  local repo = git_utils.get_repo(bufnr)
  return repo.gitdir
end

local git_pickers = {
  {
    desc = "Find in repo log content",
    enabled = is_git_repo,
    name = "search_log_content",
    func = search_func.search_log_content,
    value = search_func.search_log_content_summary,
  },
  {
    desc = "Find in file log content",
    enabled = is_git_repo,
    name = "search_log_content_file",
    func = search_func.search_log_content_file,
    value = search_func.search_log_content_file_summary,
  },
  {
    desc = "All changes on branch",
    enabled = is_git_repo,
    name = "diff_branch",
    func = diff_func.diff_branch,
    value = diff_func.diff_branch_summary,
  },
  {
    desc = "Diff file with branch",
    enabled = is_git_repo,
    name = "diff_branch_file",
    func = diff_func.diff_branch_file,
    value = diff_func.diff_branch_file_summary,
  },
  {
    desc = "Diff file with previous commit",
    enabled = is_git_repo,
    name = "diff_commit_file",
    func = diff_func.diff_commit_file,
    value = diff_func.diff_commit_file_summary,
  },
  {
    desc = "Diff file with selected line history",
    enabled = is_git_repo,
    name = "diff_commit_line",
    func = diff_func.diff_commit_line,
    value = diff_func.diff_commit_line_summary,
  },
  {
    desc = "Checkout from reflog",
    enabled = is_git_repo,
    name = "checkout_reflog",
    func = search_func.checkout_reflog,
    value = search_func.checkout_reflog_summary,
  },
}

local get_git_pickers = function(bufnr)
  local entries = {}
  for _, git_picker in ipairs(git_pickers) do
    local is_enabled = git_picker.enabled(bufnr)
    vim.dbglog("ENABLED", is_enabled)
    if is_enabled then
      table.insert(entries, {
        (git_picker.value() or ""),
        (git_picker.name or ""),
        (git_picker.desc or ""),
      })
    end
  end

  local widths = utils.get_widths(entries)

  vim.dbglog("WIDTHS", widths)
  return entries, widths
end

return { get_git_pickers = get_git_pickers }
