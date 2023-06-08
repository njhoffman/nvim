local previewers = require('telescope.previewers')
local git_utils = require('gitops.utils.git')

--- Shows a diff of the commit in the finder entry, filtered on the prompt string for the commit content
local diff_content_previewer = function()
  return previewers.new_termopen_previewer({
    title = 'Changes including prompt string',
    get_command = function(entry)
      local commit_hash = entry.opts.commit_hash
      local prompt = entry.opts.prompt
      local command = git_utils.git_diff_command({
        'git',
        'diff',
        string.format('%s~', commit_hash),
        commit_hash,
      })

      if prompt and prompt ~= '' then
        table.insert(command, '-G')
        table.insert(command, prompt)
      end

      return command
    end,
  })
end

return { diff_content_previewer = diff_content_previewer }
