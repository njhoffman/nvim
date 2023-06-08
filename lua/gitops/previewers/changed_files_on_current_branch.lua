local previewers = require('telescope.previewers')
local git_utils = require('gitops.utils.git')

--- Shows a diff of the file in the finder entry and the fork point of the current branch
local changed_files_on_current_branch_previewer = function()
  return previewers.new_termopen_previewer({
    title = 'Diff of selected file and fork point',
    get_command = function(entry)
      return git_utils.git_diff_command({
        'git',
        'diff',
        '--diff-filter=ACMR',
        '--cached',
        '--merge-base',
        git_utils.base_branch(),
        '--',
        entry.value,
      })
    end,
  })
end
return { changed_files_on_current_branch_previewer = changed_files_on_current_branch_previewer }
