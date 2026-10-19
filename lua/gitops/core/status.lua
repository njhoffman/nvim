local make_entry = require('telescope.make_entry')
local pickers = require('telescope.pickers')
local git_utils = require('gitops.utils.git')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local utils = require('telescope.utils')
local previewers = require('telescope.previewers')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values

local M = {}

M.status = function(opts)
  opts = opts or {}
  if opts.is_bare then
    vim.notify('This operation must be run in a work tree', vim.log.levels.ERROR)
    return
  end

  local gen_new_finder = function()
    local expand_dir = vim.nonnil(opts.expand_dir, true)

    local bufnr = vim.fn.bufnr()
    local args = { 'status', '-z', '--', '.' }
    if expand_dir then
      table.insert(args, #args, '-uall')
    end
    local git_command = opts.git_command or git_utils.init_git_command(bufnr, args)

    opts.entry_maker = vim.nonnil(opts.entry_maker, make_entry.gen_from_git_status(opts))
    opts.split_char = '\0'
    return finders.new_oneshot_job(git_command, opts)
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
      on_complete = {
        function(self)
          local count = 0
          for _, entry in pairs(self.finder.results) do
            if entry and entry.valid ~= false then
              count = count + 1
            end
          end
          if count == 0 and action_state.get_current_line() == '' then
            vim.notify('No changes found', vim.log.levels.INFO)
          end
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.git_staging_toggle:enhance({
          post = function()
            local picker = action_state.get_current_picker(prompt_bufnr)
            local selection = picker:get_selection_row()
            local callbacks = { unpack(picker._completion_callbacks) }
            picker:register_completion_callback(function(self)
              self:set_selection(selection)
              self._completion_callbacks = callbacks
            end)
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
  return 'status'
end

return M
