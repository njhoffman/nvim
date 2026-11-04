return {
  diff_delta = require("modules.gitops.previewers.diff_delta"),
  diff_commit_to_parent = require("modules.gitops.previewers.diff_commit_to_parent"),
  diff_commit_to_head = require("modules.gitops.previewers.diff_commit_to_head"),
  diff_commit_as_was = require("modules.gitops.previewers.diff_commit_as_was"),
  branch_log = require("modules.gitops.previewers.branch_log"),
  diff_stash = require("modules.gitops.previewers.diff_stash"),
  commit_message = require("modules.gitops.previewers.commit_message"),

  changed_files_on_current_branch = require(
    "modules.gitops.previewers.changed_files_on_current_branch"
  ),
  diff_branch_file_previewer = require("modules.gitops.previewers.diff_branch_file_previewer"),
  diff_content_previewer = require("modules.gitops.previewers.diff_content_previewer"),
  diff_commit_file_previewer = require("modules.gitops.previewers.diff_commit_file_previewer"),
}
