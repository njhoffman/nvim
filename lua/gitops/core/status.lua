local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local git_utils = require('gitops.utils.git')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local utils = require('telescope.utils')
local previewers = require('telescope.previewers')
local action_state = require('telescope.actions.state')

local M = {}

M.status = function(opts)
  if opts.is_bare then
    vim.notify('This operation must be run in a work tree', 5)
    return
  end

  local conf = require('telescope.config').values

  local gen_new_finder = function()
    local expand_dir = vim.F.if_nil(opts.expand_dir, true)

    local bufnr = vim.fn.bufnr()
    local command = { 'git' }
    local repo = git_utils.get_repo(bufnr)
    if repo.gitdir then
      table.insert(command, '--git-dir=' .. repo.gitdir)
      table.insert(command, '--work-tree=' .. repo.worktree)
    end

    table.insert(command, 'status')
    table.insert(command, '-z')
    table.insert(command, '--')
    table.insert(command, '.')
    if expand_dir then
      table.insert(command, #command - 1, '-u')
    end

    local git_command = opts and opts.git_command or command
    local output = utils.get_os_command_output(git_command, opts.cwd)

    if #output == 0 then
      vim.notify('No changes found', 4)
      return
    end

    return finders.new_table({
      results = vim.split(output[1], ' ', { trimempty = true }),
      entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_status(opts)),
    })
  end
  M.status_summary = function()
    return 'status summary'
  end

  local initial_finder = gen_new_finder()
  if not initial_finder then
    return
  end

  pickers
    .new(opts, {
      prompt_title = 'Git Status',
      finder = initial_finder,
      previewer = previewers.git_file_diff.new(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.git_staging_toggle:enhance({
          post = function()
            local picker = action_state.get_current_picker(prompt_bufnr)

            -- temporarily register a callback which keeps selection on refresh
            local selection = picker:get_selection_row()
            local callbacks = { unpack(picker._completion_callbacks) } -- shallow copy
            picker:register_completion_callback(function(self)
              self:set_selection(selection)
              self._completion_callbacks = callbacks
            end)

            -- refresh
            picker:refresh(gen_new_finder(), { reset_prompt = false })
          end,
        })

        map({ 'i', 'n' }, '<tab>', actions.git_staging_toggle)
        return true
      end,
    })
    :find()
end
M.status_summary = function(bufnr)
  return 'status summary'
end

return M
