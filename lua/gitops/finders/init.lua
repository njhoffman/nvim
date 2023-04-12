local finders = require("telescope.finders")
local file = require("gitops.utils.file")
local finder_utils = require("gitops.finders.utils")
local git_utils = require("gitops.utils.git")

local M = {}

M.git_branches_finder = function()
  return finders.new_oneshot_job({ "git", "branch", "--format=%(refname:short)" }, {})
end

--- Returns all commits that changed the visual selection in the buffer
M.git_log_location_finder = function(bufnr, opts)
  opts = opts or {}
  local entry_maker = opts.entry_maker or finder_utils.git_log_entry_maker
  local start_line = opts.s_start
  local end_line = opts.s_end
  local filename = file.relative_path(bufnr)
  local location = string.format("-L%d,%d:%s", start_line, end_line, filename)

  return finders.new_job(function(query)
    local command = git_utils.init_git_command(bufnr)
    table.insert(command, "log")
    table.insert(command, location)
    table.insert(command, "--no-patch")
    table.insert(command, "--format=%C(blue)%h|%C(green)(%ar)%Creset|%s|%C(dim white)%an")
    local prompt, author = finder_utils.split_query_from_author(query)

    if author and author ~= "" then
      table.insert(command, "--author=" .. author)
    end

    if prompt and prompt ~= "" then
      table.insert(command, "-s")
      table.insert(command, "-i")
      table.insert(command, "--grep=" .. prompt)
    end

    finder_utils.set_last_prompt(prompt)

    return vim.tbl_flatten(command)
  end, entry_maker)
end

--- Returns all commits that contains the prompt string in the commit content
--- @param opts table with optional key `bufnr` to filter on the file of the buffer
M.git_log_content_finder = function(bufnr, opts)
  opts = opts or {}
  local entry_maker = opts.entry_maker or finder_utils.git_log_entry_maker

  local filename = file.relative_path(bufnr)

  return finders.new_job(function(query)
    local command = git_utils.init_git_command(bufnr)
    table.insert(command, "log")
    table.insert(command, "--format=%C(blue)%h|%C(green)(%ar)%Creset|%s|%C(dim white)%an")
    local prompt, author = finder_utils.split_query_from_author(query)

    if author and author ~= "" then
      table.insert(command, "--author=" .. author)
    end

    if prompt and prompt ~= "" then
      table.insert(command, "-G" .. prompt)
      table.insert(command, "--pickaxe-all")
    end

    if opts.bufnr then
      table.insert(command, "--follow")
      filename = file.relative_path(opts.bufnr)
      table.insert(command, filename)
    end

    finder_utils.set_last_prompt(prompt)
    return vim.tbl_flatten(command)
  end, entry_maker)
end

--- Returns all commits that changed the file of the passed buffer
M.git_log_file_finder = function(bufnr, opts)
  opts = opts or {}

  local entry_maker = opts.entry_maker or finder_utils.git_log_entry_maker
  local filename = file.relative_path(bufnr)

  return finders.new_job(function(query)
    local command = git_utils.init_git_command(bufnr)
    table.insert(command, "log")
    table.insert(command, "--format=%C(blue)%h|%C(green)(%ar)%Creset|%s|%C(dim white)%an")
    local prompt, author = finder_utils.split_query_from_author(query)

    if author and author ~= "" then
      table.insert(command, "--author=" .. author)
    end

    if prompt and prompt ~= "" then
      table.insert(command, "-s")
      table.insert(command, "-i")
      table.insert(command, "--grep=" .. prompt)
    end

    table.insert(command, "--follow")
    table.insert(command, filename)

    finder_utils.set_last_prompt(prompt)
    return vim.tbl_flatten(command)
  end, entry_maker)
end

M.changed_files_on_current_branch_finder = function(bufnr, opts)
  opts = opts or {}

  local command = git_utils.init_git_command(bufnr)
  table.insert(command, "--no-pager")
  table.insert(command, "diff")
  table.insert(command, "--name-only")
  table.insert(command, "--cached")
  table.insert(command, "--diff-filter=ACMR")
  table.insert(command, "--merge-base")
  table.insert(command, git_utils.base_branch())
  table.insert(command, "--relative")
  return finders.new_oneshot_job(vim.tbl_flatten(command))
end

return M
