local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local git_utils = require('gitops.utils.git')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

local M = {}
M.files = function(opts)
  opts = opts or {}
  if opts.is_bare then
    vim.notify('This operation must be run in a work tree', vim.log.levels.ERROR)
    return
  end

  local show_untracked = vim.nonnil(opts.show_untracked, false)
  local recurse_submodules = vim.nonnil(opts.recurse_submodules, false)

  if show_untracked and recurse_submodules then
    vim.notify('Git does not support both --others and --recurse-submodules', vim.log.levels.ERROR)
    return
  end

  opts.entry_maker = vim.nonnil(opts.entry_maker, make_entry.gen_from_file(opts))

  local bufnr = vim.fn.bufnr()
  local command = git_utils.init_git_command(bufnr, {
    '-c', 'core.quotepath=false', 'ls-files', '--exclude-standard', '--cached',
  })

  if show_untracked then
    table.insert(command, '--others')
  end
  if recurse_submodules then
    table.insert(command, '--recurse-submodules')
  end

  local git_command = opts.git_command or command

  pickers
    .new(opts, {
      prompt_title = 'Git Files',
      finder = finders.new_oneshot_job(git_command, opts),
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    })
    :find()
end

return M
