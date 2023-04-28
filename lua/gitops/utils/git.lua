local utils = require('gitops.utils')
local file_util = require('gitops.utils.file')
local config = require('gitops.utils.config')
local command_util = require('gitops.utils.command')

local M = {}

-- TODO: git grep foo $(git rev-list --all)
-- TODO: git grep --all-match -l -e "f[^\s]*\s" -e bar $(git rev-list --all)

local all_commit_hashes = function()
  local command = 'git rev-list --all'
  local output = command_util.execute(command)

  return utils.split_string(output, '\n')
end

local all_commit_hashes_touching_file = function(git_relative_file_path, source_bufnr)
  local gs_repo = utils.get_repo(source_bufnr) or {}
  -- local repo = file_util.git_dir() or (gs_repo and gs_repo.root) or ''
  local repo = file_util.git_dir()
  local command = 'cd ' .. repo .. " && git log --all --follow --pretty=format:'%H' -- " .. git_relative_file_path

  local output = command_util.execute(command)
  return utils.split_string(output, '\n')
end

local git_diff_command = function(command, git_flags_ix, git_diff_flags_ix)
  git_flags_ix = git_flags_ix or 2
  git_diff_flags_ix = git_diff_flags_ix or 3

  local git_diff_flags = config.git_diff_flags()
  local git_flags = config.git_flags()

  if git_flags_ix > git_diff_flags_ix then
    vim.notify('git_flags must be inserted before git_diff_flags', vim.log.levels.ERROR)
  end

  if git_diff_flags ~= nil and #git_diff_flags > 0 then
    for i, flag in ipairs(git_diff_flags) do
      table.insert(command, git_diff_flags_ix + i - 1, flag)
    end
  end

  if git_flags ~= nil and #git_flags > 0 then
    for i, flag in ipairs(git_flags) do
      table.insert(command, git_flags_ix + i - 1, flag)
    end
  end

  return command
end

M.git_diff_command = git_diff_command

M.previous_commit_hash = function(commit_hash, source_bufnr)
  local command = { 'git', 'rev-parse' }
  local repo = utils.get_repo(source_bufnr) or {}
  if repo.gitdir then
    table.insert(command, '--git-dir=' .. repo.gitdir)
    table.insert(command, '--work-tree=' .. repo.worktree)
  end
  table.insert(command, commit_hash)
  table.insert(command, '~')
  local output = command_util.execute(vim.fn.join(command, ' '))
  return string.gsub(output, '\n', '')
end

M.branch_hash = function(branch)
  local command = 'git rev-parse ' .. branch

  local output = command_util.execute(command)
  return string.gsub(output, '\n', '')
end

-- local is_file_renamed = function(git_relative_file_path)
--     local command = "cd "
--         .. file.git_dir()
--         .. " && git log --all --follow --diff-filter=R --pretty=format:'%H' -- "
--         .. git_relative_file_path
--
--     local output = command_util.execute(command)
--     output = utils.split_string(output, "\n")
--     return #output > 0
-- end

local file_exists_on_commit = function(commit_hash, git_relative_file_path, source_bufnr)
  local gs_repo = utils.get_repo(source_bufnr) or {}
  -- local repo = file_util.git_dir() or (gs_repo and gs_repo.gitdir) or ''
  local repo = file_util.git_dir()
  local command = 'cd ' .. repo .. ' && git ls-tree --name-only ' .. commit_hash .. ' -- ' .. (git_relative_file_path or '')

  local output = command_util.execute(command)

  output = string.gsub(output, '\n', '')
  vim.dbglog('FILE EXISTS ON COMMIT', output, command)
  return output ~= ''
end

M.file_exists_on_commit = file_exists_on_commit

--- Returns the file name of a file on a specific commit
local file_name_on_commit = function(commit_hash, git_relative_file_path, source_bufnr)
  if file_exists_on_commit(commit_hash, git_relative_file_path, source_bufnr) then
    return git_relative_file_path
  end
  -- first find index in all_commit_hashes
  local all_hashes = all_commit_hashes()
  if all_hashes == nil then
    return nil
  end

  local index = 0
  for i, hash in ipairs(all_hashes) do
    -- compare on first 7 chars
    if string.sub(hash, 1, 7) == string.sub(commit_hash, 1, 7) then
      index = i
      break
    end
  end

  -- then find the first commit that has a different file name
  local touched_hashes = all_commit_hashes_touching_file(git_relative_file_path, source_bufnr)
  if touched_hashes == nil then
    return nil
  end

  local last_touched_hash = nil
  for i = index, #all_hashes do
    local hash = all_hashes[i]
    -- search the hash in touched_hashes
    for _, touched_hash in ipairs(touched_hashes) do
      if string.sub(touched_hash, 1, 7) == string.sub(hash, 1, 7) then
        last_touched_hash = touched_hash
        break
      end
    end

    -- print("searching next")
    if last_touched_hash ~= nil then
      break
    end
  end

  if last_touched_hash == nil then
    return nil
  end

  local command = { 'cd', 'file.git_dir()', '&&', 'git' }
  -- local repo = utils.get_repo(source_bufnr)
  -- if repo.gitdir then
  --   table.insert(command, '--git-dir=' .. repo.gitdir)
  --   table.insert(command, '--work-tree=' .. repo.worktree)
  -- end
  --
  table.insert(command, "--no-pager log -M --follow --pretty=format:'%H' --name-only")
  table.insert(command, last_touched_hash)
  table.insert(command, '~.. -- ')
  table.insert(command, git_relative_file_path)
  table.insert(command, ' | tail -1')

  local output = command_util.execute(vim.fn.join(command, ' '))
  output = string.gsub(output, '\n', '')

  if file_exists_on_commit(commit_hash, output, source_bufnr) then
    return output
  else
    return nil
  end
end

M.file_name_on_commit = file_name_on_commit

--- returns the base branch of a branch (where fork_point is)
M.base_branch = function()
  local command = [[git show-branch |\
      sed "s/].*//" |\
      grep "*" |\
      grep -v "$(git rev-parse --abbrev-ref HEAD)" |\
      head -n1 |\
      sed "s/^.*\\[//"]]

  local output = command_util.execute(command)

  return string.gsub(output, '\n', '')
end

M.current_branch = function()
  local command = 'git branch --show-current'

  local output = command_util.execute(command)

  return string.gsub(output, '\n', '')
end

M.init_git_command = function(bufnr)
  local command = { 'git' }
  local repo = utils.get_repo(bufnr)
  if repo.gitdir then
    table.insert(command, '--git-dir=' .. repo.gitdir)
    table.insert(command, '--work-tree=' .. repo.worktree)
  end
  return command
end

-- git files count
M.file_count = function(bufnr, cwd)
  -- local commands = require("plugs.config.telescope.commands")
  -- local cmd = vim.fn.copy(commands.rg) or { "rg" }
  local cmd = { 'git' }
  -- local repo = utils.get_repo(bufnr)
  -- if repo.gitdir then
  --   table.insert(cmd, '--git-dir=' .. repo.gitdir)
  --   table.insert(cmd, '--work-tree=' .. repo.worktree)
  -- end
  table.insert(cmd, 'ls-files')
  table.insert(cmd, cwd or vim.fn.getcwd() or vim.fn.getenv('HOME'))
  local output = vim.fn.system(cmd)
  local lines = vim.tbl_filter(function(line)
    return #line > 0
  end, vim.split(output, '\n'))
  return #lines
end

return M
