-- stylua: ignore
-- git --git-dir=/home/nicholas/.cfg --work-tree=/home/nicholas/.cfg grep "JABS" $(git --git-dir=/home/nicholas/.cfg --work-tree=/home/nicholas/.cfg rev-list --all)
return {
  search_commits           = require('gitops.search.search_commits').search_commits,
  search_commits_file      = require('gitops.search.search_commits_file').search_commits_file,
  -- show_custom_functions = require('gitops.search.show_custom_functions').show_custom_functions,
  checkout_reflog          = require('gitops.search.checkout_reflog').checkout_reflog,
}
