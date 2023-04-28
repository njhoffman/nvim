local finders = require('telescope.finders')
local git_utils = require('gitops.utils.git')

local changed_files_on_branch = function(bufnr, opts)
  opts = opts or {}

  local command = git_utils.init_git_command(bufnr)
  table.insert(command, '--no-pager')
  table.insert(command, 'diff')
  table.insert(command, '--name-only')
  table.insert(command, '--cached')
  table.insert(command, '--diff-filter=ACMR')
  table.insert(command, '--merge-base')
  table.insert(command, git_utils.base_branch())
  table.insert(command, '--relative')
  return finders.new_oneshot_job(vim.tbl_flatten(command))
end

return changed_files_on_branch
