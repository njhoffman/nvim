local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local M = {}
local ags_finders = require("gitops.finders")
local ags_mappings = require("gitops.mappings")
local ags_previewers = require("gitops.previewers")
local git_utils = require("gitops.utils.git")

-- Opens a Telescope window with a list of git commits which changed the current file (renames included)
M.diff_commit_file = function()
  local bufnr = vim.fn.bufnr()
  pickers
    .new({
      results_title = "BCommits ",
      prompt_title = "Git Commits for File",
      finder = ags_finders.git_log_file_finder(bufnr, { bufnr = bufnr }),
      previewer = ags_previewers.git_diff_commit_file_previewer(bufnr),
      sorter = sorters.highlighter_only(),
      attach_mappings = function(_, map)
        ags_mappings.open_diff_view_current_file_selected_commit(map)
        ags_mappings.show_entire_commit(map)
        ags_mappings.open_selected_commit_in_browser(map)
        ags_mappings.copy_commit_hash_to_clipboard(map)

        return true
      end,
    }, {})
    :find()
end

M.diff_commit_file_summary = function()
  return "diff commit file"
end

--- Opens a Telescope window with all files changed on the current branch
--- Only committed changes will be displayed
M.diff_branch = function()
  pickers
    .new({
      results_title = "Modified " .. git_utils.base_branch() .. " -> " .. git_utils.current_branch(),
      sorter = sorters.get_fuzzy_file(),
      finder = ags_finders.changed_files_on_current_branch_finder(),
      previewer = ags_previewers.changed_files_on_current_branch_previewer(),
    }, {})
    :find()
end
M.diff_branch_summary = function()
  return "diff branch"
end

--- Opens a Telescope window with a list of local branches
M.diff_branch_file = function()
  -- local previewers = require('telescope.previewers')
  local current_branch = git_utils.current_branch()
  local bufnr = vim.fn.bufnr()

  pickers
    .new({
      results_title = "Local branches :: *" .. current_branch,
      prompt_title = "Branch name",
      finder = ags_finders.git_branches_finder(),
      sorter = sorters.get_fuzzy_file(),
      previewer = ags_previewers.git_diff_branch_file_previewer(bufnr),
      attach_mappings = function(_, map)
        ags_mappings.open_diff_view_current_file_selected_branch(map)
        return true
      end,
    }, {})
    :find()
end
M.diff_branch_file_summary = function()
  return "diff branch file summary"
end

--- Opens a Telescope window with a list of previous commit logs with respect to selected lines
M.diff_commit_line = function()
  local bufnr = vim.fn.bufnr()
  local opts = {
    bufnr = bufnr,
    s_start = vim.fn.getpos("'<")[2],
    s_end = vim.fn.getpos("'>")[2],
  }

  -- git log -L741,751:'app/models/patients/patient.rb'\
  -- --format='%C(auto)%h \t %as \t %C(green)%an _ %Creset %s'
  pickers
    .new({
      results_title = "BCommits",
      prompt_title = "Git Commits for Selected Lines",
      finder = ags_finders.git_log_location_finder(bufnr, opts),
      previewer = ags_previewers.git_diff_commit_file_previewer(bufnr),
      sorter = sorters.highlighter_only(),
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

M.diff_commit_line_summary = function()
  return "diff commit line summary"
end

return M
