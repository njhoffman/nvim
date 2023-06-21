-- local strings = require('plenary.strings')
-- local Path = require('plenary.path')
-- local state = require('telescope.state')
-- local actions = require('telescope.actions')
-- local utils = require('telescope.utils')
-- local previewers = require('telescope.previewers')
-- local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local git_utils = require('gitops.utils.git')
local make_entry = require('gitops.make_entry')
local previewers = require('gitops.previewers')
local logger = require('gitops.utils.logger')

local default_git_args = {
  '-c',
  'core.pager=delta',
  '-c',
  'delta.diff-so-fancy=false',
  '-c',
  'delta.navigate=false',
  -- '-c',
  -- 'delta.side-by-side=true',
}

local M = {}

M.commits = function(opts)
  local timing = { total = vim.fn.reltime(_, _) }
  opts = opts or {}
  -- local relative_file_name = vim.fn.expand('%:~:.')
  opts.bufnr = vim.fn.bufnr()

  local script_command = git_utils.init_script_command(opts.bufnr)

  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))

  local opts_parent = vim.tbl_deep_extend('force', opts, {
    git_cmd = 'diff',
    git_args = opts.git_args or default_git_args,
    git_parent = true,
    preview_title = 'Diff to Parent',
  })

  local opts_head = vim.tbl_deep_extend('force', opts, {
    git_cmd = { 'diff', '--cached' },
    git_args = opts.git_args or default_git_args,
    preview_title = 'Diff to HEAD',
  })

  local opts_as_was = vim.tbl_deep_extend('force', opts, {
    git_cmd = 'show',
    git_args = opts.git_args or default_git_args,
    preview_title = 'Show to Parent',
  })

  return pickers
    .new(opts, {
      prompt_title = 'Git Commits',
      finder = finders.new_oneshot_job(script_command, opts),
      previewer = {
        -- previewers.commit_message.new(opts),
        previewers.diff_commit_to_parent.new(opts),
        previewers.diff_commit_to_delta(opts_parent),
        previewers.diff_commit_to_head.new(opts),
        previewers.diff_commit_to_delta(opts_head),
        previewers.diff_commit_as_was.new(opts),
        previewers.diff_commit_to_delta(opts_as_was),
      },
      sorter = conf.file_sorter(opts),
      on_complete = {
        function(picker)
          -- processed, displayed, looped, previewed
          logger.timing(picker, timing, picker.stats.processed)
        end,
      },
    })
    :find()
end

-- attach_mappings = function()
--   actions.select_default:replace(actions.git_checkout_current_buffer)
--   local transfrom_file = function()
--     return opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd) or ''
--   end
--
--   local get_buffer_of_orig = function(selection)
--     local value = selection.value .. ':' .. transfrom_file()
--     local _command = git_utils.init_git_command(source_bufnr, {
--       '--no-pager',
--       'show',
--       'value',
--     })
--     local content = utils.get_os__command_output(_command, opts.cwd)
--
--     local _bufnr = vim.api.nvim_create_buf(false, true)
--     vim.api.nvim_buf_set_lines(_bufnr, 0, -1, false, content)
--     vim.api.nvim_buf_set_name(_bufnr, 'Original')
--     return _bufnr
--   end
--
--   local vimdiff = function(selection, cmd)
--     local ft = vim.bo.filetype
--     vim.cmd('diffthis')
--
--     local _bufnr = get_buffer_of_orig(selection)
--     vim.cmd(string.format('%s %s', cmd, _bufnr))
--     vim.bo.filetype = ft
--     vim.cmd('diffthis')
--
--     vim.api.nvim_create_autocmd('WinClosed', {
--       buffer = source_bufnr,
--       nested = true,
--       once = true,
--       callback = function()
--         vim.api.nvim_buf_delete(_bufnr, { force = true })
--       end,
--     })
--   end
--
--   actions.select_vertical:replace(function(prompt_bufnr)
--     actions.close(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     vimdiff(selection, 'leftabove vert sbuffer')
--   end)
--
--   actions.select_horizontal:replace(function(prompt_bufnr)
--     actions.close(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     vimdiff(selection, 'belowright sbuffer')
--   end)
--
--   actions.select_tab:replace(function(prompt_bufnr)
--     actions.close(prompt_bufnr)
--     local selection = action_state.get_selected_entry()
--     vim.cmd('tabedit ' .. transfrom_file())
--     vimdiff(selection, 'leftabove vert sbuffer')
--   end)
--   return true
-- end,

M.commits_stats = function(bufnr)
  bufnr = bufnr or vim.fn.bufnr()
  local range_cmd = git_utils.init_script_command(bufnr, '--method=range')
  local count_cmd = git_utils.init_script_command(bufnr, '--method=count')
  return {
    range = string.gsub(vim.fn.system(vim.fn.join(range_cmd, ' ')), '\n', ''),
    count = string.gsub(vim.fn.system(vim.fn.join(count_cmd, ' ')), '\n', ''),
  }
end

return M
