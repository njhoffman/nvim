-- stylua: ignore
return {
  diff_commit_line = require('gitops.diff.commit_line').diff_commit_line,
  diff_commit_file = require('gitops.diff.commit_file').diff_commit_file,
  diff_branch      = require('gitops.diff.branch').diff_branch,
  diff_branch_file = require('gitops.diff.branch_file').diff_branch_file,
}
