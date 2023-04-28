local search_func = require('gitops.search')
local diff_func = require('gitops.diff')
local core_func = require('gitops.core')
local config = require('gitops.utils.config')

return require('telescope').register_extension({
  setup = function(ext_config, _)
    config.setup(ext_config)
  end,
  -- stylua: ignore
  exports = {
    -- blame, checkout:branch, checkout:commit, checkout:file, checkout:tag,
    -- cherry:pick, cherry:pick:from:branch, clean, add
    diff_branch             = diff_func.diff_branch,
    diff_branch_file        = diff_func.diff_branch_file,
    diff_commit_file        = diff_func.diff_commit_file,
    diff_commit_line        = diff_func.diff_commit_line,
    search_log_content      = search_func.search_commit,
    search_log_content_file = search_func.search_commit_file,
    show_custom_functions   = search_func.show_custom_functions,
    checkout_reflog         = search_func.checkout_reflog,
    changed_on_branch       = search_func.changed_on_branch,
    files                   = core_func.files,
    stash                   = core_func.stash,
    status                  = core_func.status,
    commits                 = core_func.commits,
    bcommits                = core_func.bcommits,
    branches                = core_func.branches,
  },
})
