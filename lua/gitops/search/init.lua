-- stylua: ignore
return {
  search_commits           = require('gitops.search.search_commits').search_commits,
  search_commits_file      = require('gitops.search.search_commits_file').search_commits_file,
  -- show_custom_functions = require('gitops.search.show_custom_functions').show_custom_functions,
  checkout_reflog          = require('gitops.search.checkout_reflog').checkout_reflog,
}
