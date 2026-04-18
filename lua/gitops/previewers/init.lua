return {
  diff_delta = require('gitops.previewers.diff_delta'),
  diff_commit_to_parent = require('gitops.previewers.diff_commit_to_parent'),
  diff_commit_to_head = require('gitops.previewers.diff_commit_to_head'),
  diff_commit_as_was = require('gitops.previewers.diff_commit_as_was'),
  branch_log = require('gitops.previewers.branch_log'),
  diff_stash = require('gitops.previewers.diff_stash'),
  commit_message = require('gitops.previewers.commit_message'),

  changed_files_on_current_branch = require('gitops.previewers.changed_files_on_current_branch'),
  diff_branch_file_previewer = require('gitops.previewers.diff_branch_file_previewer'),
  diff_content_previewer = require('gitops.previewers.diff_content_previewer'),
  diff_commit_file_previewer = require('gitops.previewers.diff_commit_file_previewer'),
}
