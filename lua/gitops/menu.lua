local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local ags_mappings = require("gitops.mappings")
local search_func = require("gitops.search")
local diff_func = require("gitops.diff")
local core_func = require("gitops.core")
local git_utils = require("gitops.utils.git")

local is_git_repo = function(bufnr)
  -- bufnr = bufnr or vim.api.nvim_get_current_buf()
  local repo = git_utils.get_repo(bufnr)
  vim.dbglog("REPO", repo, bufnr)
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
    func = diff_func.checkout_reflog,
    value = diff_func.checkout_reflog_summary,
  },
}

local function map_item(git_pickers_table, f)
  local t = {}
  for k, v in pairs(git_pickers_table) do
    t[k] = f(v)
  end
  return t
end

local function execute_git_function(value)
  for _, v in pairs(git_pickers) do
    if v["func"] == value then
      v["func"]()
      return
    end
  end
end

local M = {}

--- Opens all a selector for all advanced git search functions
M.show_menu = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = {}
  for _, git_picker in ipairs(git_pickers) do
    vim.dbglog("gp", git_picker)
    local is_enabled = git_picker.enabled(bufnr)
    vim.dbglog("is_enabled", is_enabled)
    if is_enabled then
      vim.dbglog("INSRTING")
      table.insert(enabled, git_picker)
    end
  end

  vim.dbglog("ENBLED", enabled)
  pickers
    .new({
      results_title = "Git Pickers",
      finder = finders.new_table(map_item(enabled, function(item)
        return item.name .. " " .. item.value
      end)),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(_, map)
        ags_mappings.omnimap(map, "<CR>", function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          execute_git_function(selection.value)
        end)
        return true
      end,
    }, {})
    :find()
end

M.show_menu()

-- return M
