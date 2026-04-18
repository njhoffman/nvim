local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local git_utils = require('gitops.utils.git')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')
local conf = require('telescope.config').values

local M = {}

M.stash = function(opts)
  opts = opts or {}
  opts.show_branch = vim.F.if_nil(opts.show_branch, true)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_stash(opts))

  local bufnr = vim.fn.bufnr()
  local git_command = opts.git_command or git_utils.init_git_command(bufnr, {
    '--no-pager', 'stash', 'list',
  })

  pickers
    .new(opts, {
      prompt_title = 'Git Stash',
      finder = finders.new_oneshot_job(git_command, opts),
      previewer = previewers.git_stash_diff.new(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(actions.git_apply_stash)
        return true
      end,
    })
    :find()
end

return M
