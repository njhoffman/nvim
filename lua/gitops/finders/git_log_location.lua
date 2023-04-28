local finders = require('telescope.finders')
local git_utils = require('gitops.utils.git')
local file = require('gitops.utils.file')
local finder_utils = require('gitops.finders.utils')

--- Returns all commits that changed the visual selection in the buffer
local git_log_location = function(bufnr, opts)
  opts = opts or {}
  local entry_maker = opts.entry_maker or finder_utils.git_log_entry_maker
  local start_line = opts.s_start
  local end_line = opts.s_end
  local filename = file.relative_path(bufnr)
  local location = string.format('-L%d,%d:%s', start_line, end_line, filename)

  return finders.new_job(function(query)
    local command = git_utils.init_git_command(bufnr)
    table.insert(command, 'log')
    table.insert(command, location)
    table.insert(command, '--no-patch')
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

    finder_utils.set_last_prompt(prompt)

    return vim.tbl_flatten(command)
  end, entry_maker)
end

return git_log_location
