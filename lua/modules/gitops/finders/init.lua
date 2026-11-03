-- stylua: ignore
return {
  git_branches            = require('modules.gitops.finders.git_branches'),
  git_log_location        = require('modules.gitops.finders.git_log_location'),
  git_log_content         = require('modules.gitops.finders.git_log_content'),
  git_log_file            = require('modules.gitops.finders.git_log_file'),
  changed_files_on_branch = require('modules.gitops.finders.changed_files_on_branch'),
}
