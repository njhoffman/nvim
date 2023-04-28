local Path = require('plenary.path')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local utils = require('telescope.utils')
local previewers = require('telescope.previewers')
local action_state = require('telescope.actions.state')
local git_utils = require('gitops.utils.git')
local make_entry = require('gitops.make_entry')

local M = {}

M.commits = function(opts)
  opts = opts or {}
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))

  local source_bufnr = vim.fn.bufnr()
  local git_command = git_utils.init_git_command(source_bufnr, {
    'log',
    '--pretty=oneline',
    '--abbrev-commit',
    '--',
    '.',
  })

  local conf = require('telescope.config').values

  pickers
    .new(opts, {
      prompt_title = 'Git Commits',
      finder = finders.new_oneshot_job(git_command, opts),
      previewer = {
        previewers.git_commit_diff_to_parent.new(opts),
        previewers.git_commit_diff_to_head.new(opts),
        previewers.git_commit_diff_as_was.new(opts),
        previewers.git_commit_message.new(opts),
      },
      sorter = conf.file_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(actions.git_checkout_current_buffer)
        local transfrom_file = function()
          return opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd) or ''
        end

        local get_buffer_of_orig = function(selection)
          local value = selection.value .. ':' .. transfrom_file()
          local _command = git_utils.init_git_command(source_bufnr, {
            '--no-pager',
            'show',
            'value',
          })
          local content = utils.get_os__command_output(_command, opts.cwd)

          local _bufnr = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(_bufnr, 0, -1, false, content)
          vim.api.nvim_buf_set_name(_bufnr, 'Original')
          return _bufnr
        end

        local vimdiff = function(selection, cmd)
          local ft = vim.bo.filetype
          vim.cmd('diffthis')

          local _bufnr = get_buffer_of_orig(selection)
          vim.cmd(string.format('%s %s', cmd, _bufnr))
          vim.bo.filetype = ft
          vim.cmd('diffthis')

          vim.api.nvim_create_autocmd('WinClosed', {
            buffer = source_bufnr,
            nested = true,
            once = true,
            callback = function()
              vim.api.nvim_buf_delete(_bufnr, { force = true })
            end,
          })
        end

        actions.select_vertical:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vimdiff(selection, 'leftabove vert sbuffer')
        end)

        actions.select_horizontal:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vimdiff(selection, 'belowright sbuffer')
        end)

        actions.select_tab:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd('tabedit ' .. transfrom_file())
          vimdiff(selection, 'leftabove vert sbuffer')
        end)
        return true
      end,
    })
    :find()
end

M.commits_summary = function(bufnr, opts)
  return 'commits summary'

  -- opts.cwd = vim.fn.getcwd()
  -- return async_oneshot_finder {
  --   entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),
  --
  --   cwd = opts.cwd,
  --   maximum_results = opts.maximum_results,
  --
  --   fn_command = function()
  --     return {
  --       command = command,
  --       args = command_list,
  --     }
  --   end,
  -- return finders.new_oneshot_job(git_command, opts)
end

return M
