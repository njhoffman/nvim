local git_utils = require('gitops.utils.git')
local finders = require('telescope.finders')

local git_branches = function(bufnr, opts)
  local command = git_utils.init_git_command(bufnr)
  table.insert(command, 'branch')
  table.insert(command, '--format=%(refname:short)')
  return finders.new_oneshot_job(command, opts)
end

return git_branches
