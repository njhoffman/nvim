local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local git_utils = require('gitops.utils.git')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')

local M = {}

M.stash = function(opts)
  opts.show_branch = vim.F.if_nil(opts.show_branch, true)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_stash(opts))

  local bufnr = vim.fn.bufnr()
  local command = { 'git' }
  local repo = git_utils.get_repo(bufnr)
  if repo.gitdir then
    table.insert(command, '--git-dir=' .. repo.gitdir)
    table.insert(command, '--work-tree=' .. repo.worktree)
  end
  table.insert(command, '--no-pager')
  table.insert(command, 'stash')
  table.insert(command, 'list')

  local git_command = opts and opts.git_command or command
  local conf = require('telescope.config').values

  pickers
    .new(opts, {
      prompt_title = 'Git Stash',
      finder = finders.new_oneshot_job(vim.tbl_flatten(git_command), opts),
      previewer = previewers.git_stash_diff.new(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(actions.git_apply_stash)
        return true
      end,
    })
    :find()
end

M.stash_summary = function()
  return 'stash summary'
end
return M
