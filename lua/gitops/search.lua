local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local finders = require("telescope.finders")

local git_utils = require("gitops.utils.git")
local ags_finders = require("gitops.finders")
local ags_previewers = require("gitops.previewers")
local ags_mappings = require("gitops.mappings")

local M = {}

--- Opens a Telescope window with a list of previous commits.
--- Query is used to filter the results based on the content of the commit (added or removed text).
M.search_log_content = function(opts)
  -- git log -L741,751:'app/models/patients/patient.rb' \
  -- --format='%C(auto)%h \t %as \t %C(green)%an _ %Creset %s'
  local bufnr = vim.fn.bufnr()
  local count = git_utils.file_count(bufnr, opts.cwd or vim.fn.getcwd())
  pickers
    .new({
      prompt_title = "Git Grep Commits",
      results_title = "Git Grep All (" .. count .. " files)",
      finder = ags_finders.git_log_content_finder(bufnr, {}),
      previewer = ags_previewers.git_diff_content_previewer(),
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

M.search_log_content_summary = function(bufnr)
  local repo = git_utils.get_repo(bufnr)
  return repo.gitdir
end

local get_path = function(path)
  return (path or vim.fn.getcwd()):gsub(vim.fn.getenv("HOME"), "~")
end

--- Same as `search_log_content` but with respect to the current file
M.search_log_content_file = function()
  -- local file_name = vim.fn.expand("%")
  local relative_file_name = vim.fn.expand("%:~:.")
  local bufnr = vim.fn.bufnr()

  -- git log -L741,751:'app/models/patients/patient.rb' \
  -- --format='%C(auto)%h \t %as \t %C(green)%an _ %Creset %s'
  pickers
    .new({
      prompt_title = "Git Grep BCommits",
      results_title = "Git Grep (" .. relative_file_name .. ")",
      finder = ags_finders.git_log_content_finder(bufnr, {
        bufnr = bufnr,
      }),
      previewer = ags_previewers.git_diff_content_previewer(),
      -- sorter = sorters.highlighter_only(),
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

M.search_log_content_file_summary = function(bufnr)
  return "search_log_content_file_summary"
end

M.checkout_reflog = function()
  pickers
    .new({
      results_title = "Git Reflog, <CR> to checkout",
      finder = finders.new_oneshot_job({ "git", "reflog", "--date=iso" }, {}),
      sorter = sorters.get_fuzzy_file(),
      attach_mappings = function(_, map)
        ags_mappings.checkout_reflog_entry(map)
        return true
      end,
    }, {})
    :find()
end

M.checkout_reflog_summary = function(bufnr)
  return "checkout reflog"
end

return M
