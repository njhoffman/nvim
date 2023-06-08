local previewers = require('telescope.previewers')
local file = require('gitops.utils.file')
local git_utils = require('gitops.utils.git')

--- Shows a diff of the branch in the finder entry relative to the passed filename
local git_diff_branch_file_previewer = function(bufnr)
  local filename = file.file_name(bufnr)
  return previewers.new_termopen_previewer({
    title = 'Diff of current buffer and selected branch for: ' .. filename,
    get_command = function(entry)
      local branch = entry.value
      local current_hash = git_utils.branch_hash('HEAD')

      local branch_filename =
        git_utils.file_name_on_commit(git_utils.branch_hash(branch), file.git_relative_path(bufnr))

      if branch_filename ~= nil then
        return git_utils.git_diff_command({
          'git',
          'diff',
          branch .. ':' .. branch_filename,
          current_hash .. ':' .. file.git_relative_path(bufnr),
        })
      else
        return git_utils.git_diff_command({
          'git',
          'diff',
          branch,
          current_hash,
          '--',
          file.relative_path(bufnr),
        })
      end
    end,
  })
end

return { diff_branch_file_previewer = git_diff_branch_file_previewer }
