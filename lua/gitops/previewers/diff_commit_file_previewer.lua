local previewers = require('telescope.previewers')
local file = require('gitops.utils.file')
local git_utils = require('gitops.utils.git')

--- Shows a diff of the commit in the finder entry, filtered on the file of the current buffer
local diff_commit_file_previewer = function(bufnr)
  local filename_on_head = file.git_relative_path(bufnr)
  return previewers.new_termopen_previewer({
    title = 'Changes on selected commit for: ' .. file.file_name(bufnr),
    get_command = function(entry)
      local commit_hash = entry.opts.commit_hash

      local prev_commit = git_utils.previous_commit_hash(commit_hash, bufnr)

      local curr_name = git_utils.file_name_on_commit(commit_hash, filename_on_head, bufnr)
      local prev_name = git_utils.file_name_on_commit(prev_commit, filename_on_head, bufnr)

      if prev_name ~= nil then
        return git_utils.git_diff_command({
          'git',
          'diff',
          prev_commit .. ':' .. prev_name,
          commit_hash .. ':' .. curr_name,
        })
      else
        return git_utils.git_diff_command({
          'git',
          'diff',
          prev_commit,
          commit_hash,
          '--',
          file.git_relative_path_to_relative_path(curr_name, bufnr),
        })
      end
    end,
  })
end

return diff_commit_file_previewer
