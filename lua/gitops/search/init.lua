-- stylua: ignore
-- git --git-dir=/home/nicholas/.cfg --work-tree=/home/nicholas/.cfg grep "JABS" $(git --git-dir=/home/nicholas/.cfg --work-tree=/home/nicholas/.cfg rev-list --all)
-- git grep "buffer" $(git rev-list --all) --all looks in all branches
-- # Limit your search to only specific files in a specific directory
-- git log -S "something specific" -p -- **/models/user*.py
-- # Search for a regex instead of a string (note the -G instead of -S)
-- git log -G '^alias \w+=".*"$' -p
-- git log -S "buffer" --all --oneline --graph

return {
  search_commits           = require('gitops.search.search_commits').search_commits,
  search_commits_file      = require('gitops.search.search_commits_file').search_commits_file,
  -- show_custom_functions = require('gitops.search.show_custom_functions').show_custom_functions,
  checkout_reflog          = require('gitops.search.checkout_reflog').checkout_reflog,
}
