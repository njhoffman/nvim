local search_func = require('gitops.search')
local diff_func = require('gitops.diff')
local core_func = require('gitops.core')
local config = require('gitops.utils.config')

return require('telescope').register_extension({
  setup = function(ext_config, _)
    config.setup(ext_config)
  end,
  exports = {
    search_content        = search_func.search_commits,
    search_content_file   = search_func.search_commits_file,
    show_custom_functions = search_func.show_custom_functions,
    checkout_reflog       = search_func.checkout_reflog,
    commits               = core_func.commits,
    bcommits              = core_func.bcommits,
    files                 = core_func.files,
    stash                 = core_func.stash,
    status                = core_func.status,
    branches              = core_func.branches,
    diff_branch           = diff_func.diff_branch,
    diff_branch_file      = diff_func.diff_branch_file,
    diff_commit_file      = diff_func.diff_commit_file,
    diff_commit_line      = diff_func.diff_commit_line,
  },
})
