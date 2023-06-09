-- M.git_status = function(opts)
--   opts = opts or {}
--   opts.previewer = previewers.new_termopen_previewer({
--     get_command = function(entry)
--       if entry.status == "D " then
--         return { "git", "show", "HEAD:" .. entry.value }
--       elseif entry.status == "??" then
--         return { "bat", "--style=plain", entry.value }
--       end
--       return {
--         "git",
--         "-c",
--         "core.pager=delta",
--         "-c",
--         "delta.pager=less -R",
--         "diff",
--         entry.value,
--       }
--     end,
--   })
--
--   -- Use icons that resemble the `git status` command line.
--   opts.git_icons = {
--     added = "A",
--     changed = "M",
--     copied = "C",
--     deleted = "-",
--     renamed = "R",
--     unmerged = "U",
--     untracked = "?",
--   }
--
--   builtin.git_status(opts)
-- end
--
-- M.git_bcommits = previewers.new_termopen_previewer({
--   get_command = function(entry)
--     return {
--       "git",
--       "-c",
--       "core.pager=delta",
--       -- "-c",
--       -- "delta.pager=less -R",
--       "show",
--       entry.value,
--     }
--   end,
-- })
--
-- M.delta = previewers.new_termopen_previewer({
--   get_command = function(entry)
--     if entry.status == "??" or "A " then
--       return { "git", "diff", entry.value }
--     end
--     return { "git", "diff", entry.value .. "^!" }
--   end,
-- })
--
return {
  branch_log = require('gitops.previewers.branch_log'),
  diff_stash = require('gitops.previewers.diff_stash'),
  diff_commit_to_parent = require('gitops.previewers.diff_commit_to_parent'),
  diff_commit_to_head = require('gitops.previewers.diff_commit_to_head'),
  diff_commit_as_was = require('gitops.previewers.diff_commit_as_was'),
  commit_message = require('gitops.previewers.commit_message'),

  changed_files_on_current_branch = require('gitops.previewers.changed_files_on_current_branch'),
  diff_branch_file_previewer = require('gitops.previewers.diff_branch_file_previewer'),
  diff_content_previewer = require('gitops.previewers.diff_content_previewer'),
  diff_commit_file_previewer = require('gitops.previewers.diff_commit_file_previewer'),
}
