local finders = require('telescope.finders')
local git_utils = require('gitops.utils.git')
local file = require('gitops.utils.file')
local finder_utils = require('gitops.finders.utils')

--- Returns all commits that changed the file of the passed buffer
local git_log_file = function(bufnr, opts)
  opts = opts or {}

  local entry_maker = opts.entry_maker or finder_utils.git_log_entry_maker
  local filename = file.relative_path(bufnr)

  return finders.new_job(function(query)
    local command = git_utils.init_git_command(bufnr)
    table.insert(command, 'log')
    table.insert(command, '--format=%C(blue)%h|%C(green)(%ar)%Creset|%s|%C(dim white)%an')
    local prompt, author = finder_utils.split_query_from_author(query)

    if author and author ~= '' then
      table.insert(command, '--author=' .. author)
    end

    if prompt and prompt ~= '' then
      table.insert(command, '-s')
      table.insert(command, '-i')
      table.insert(command, '--grep=' .. prompt)
    end

    table.insert(command, '--follow')
    table.insert(command, filename)

    finder_utils.set_last_prompt(prompt)
    return command
  end, entry_maker)
end

return git_log_file
