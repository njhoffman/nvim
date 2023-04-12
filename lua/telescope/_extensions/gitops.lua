local search_func = require("gitops.search")
local diff_func = require("gitops.diff")
local core_func = require("gitops.core")
local config = require("gitops.utils.config")

return require("telescope").register_extension({
  setup = function(ext_config, _)
    config.setup(ext_config)
  end,
  -- stylua: ignore
  exports = {
    diff_branch_file        = diff_func.diff_branch_file,
    diff_commit_file        = diff_func.diff_commit_file,
    diff_commit_line        = diff_func.diff_commit_line,
    checkout_reflog         = search_func.checkout_reflog,
    search_log_content      = search_func.search_log_content,
    search_log_content_file = search_func.search_log_content_file,
    show_custom_functions   = search_func.show_custom_functions,
    changed_on_branch       = search_func.changed_on_branch,
    git_files               = core_func.files,
    git_stash               = core_func.stash,
    git_status              = core_func.status,
    git_commits             = core_func.commits,
    git_bcommits            = core_func.bcommits,
    git_branches            = core_func.branches,
  },
})
