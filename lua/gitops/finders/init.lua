-- stylua: ignore
return {
  git_branches            = require('gitops.finders.git_branches'),
  git_log_location        = require('gitops.finders.git_log_location'),
  git_log_content         = require('gitops.finders.git_log_content'),
  git_log_file            = require('gitops.finders.git_log_file'),
  changed_files_on_branch = require('gitops.finders.changed_files_on_branch'),
}
