local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local ags_finders = require('gitops.finders')
local ags_previewers = require('gitops.previewers')
local ags_mappings = require('gitops.mappings')

local M = {}

M.diff_commit_line = function(opts)
  opts = opts or {}
  local bufnr = vim.fn.bufnr()
  local picker_opts = {
    bufnr = bufnr,
    s_start = opts.s_start or vim.fn.getpos("'<")[2],
    s_end = opts.s_end or vim.fn.getpos("'>")[2],
  }

  pickers
    .new(opts, {
      results_title = 'BCommits',
      prompt_title = 'Git Commits for Selected Lines',
      finder = ags_finders.git_log_location(bufnr, picker_opts),
      previewer = ags_previewers.diff_commit_file_previewer(bufnr),
      sorter = sorters.highlighter_only(),
      attach_mappings = function(_, map)
        ags_mappings.open_diff_view_current_file_selected_commit(map)
        ags_mappings.open_selected_commit_in_browser(map)
        ags_mappings.copy_commit_hash_to_clipboard(map)
        ags_mappings.show_entire_commit(map)
        return true
      end,
    })
    :find()
end

M.diff_commit_line_summary = function(bufnr, _opts)
  local opts = vim.tbl_deep_extend('force', {
    bufnr = bufnr,
    s_start = vim.fn.getpos("'<")[2],
    s_end = vim.fn.getpos("'>")[2],
  }, _opts or {})
  return tostring(ags_finders.git_log_location(bufnr, opts).results)
end

return M
