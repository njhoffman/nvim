local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local git_utils = require('gitops.utils.git')
local finders = require('telescope.finders')

local M = {}
M.files = function(opts)
  if opts.is_bare then
    vim.notify('This operation must be run in a work tree', 5)
    return
  end

  local show_untracked = vim.F.if_nil(opts.show_untracked, false)
  local recurse_submodules = vim.F.if_nil(opts.recurse_submodules, false)

  if show_untracked and recurse_submodules then
    vim.notify('Git does not support both --others and --recurse-submodules', 5)
    return
  end
  -- By creating the entry maker after the cwd options, we ensure the maker uses the cwd options when being created.
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_file(opts))

  local bufnr = vim.fn.bufnr()
  local command = { 'git' }
  local repo = git_utils.get_repo(bufnr)
  if repo.gitdir then
    table.insert(command, '--git-dir=' .. repo.gitdir)
    table.insert(command, '--work-tree=' .. repo.worktree)
  end
  table.insert(command, 'ls-files')
  table.insert(command, '--exclude-standard')
  table.insert(command, '--cached')
  local git_command = opts and opts.git_command or command

  local conf = require('telescope.config').values
  local cmd_str = vim.tbl_flatten({
    git_command,
    show_untracked and '--others' or nil,
    recurse_submodules and '--recurse-submodules' or nil,
  })
  pickers
    .new({
      prompt_title = 'Git Files',
      finder = finders.new_oneshot_job(cmd_str, opts),
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    }, {})
    :find()
end

M.files_summary = function()
  return 'files summary'
end

return M
