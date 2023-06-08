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
local previewers = require('gitops.previewers.commit')

local M = {}

local log_timing = function(opts, timing, num)
  -- command finishes here if async job
  if type(timing.command ~= 'string') then
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    timing.command = vim.fn.reltimestr(vim.fn.reltime(timing.total))
  end

  if type(timing.total) ~= 'string' then
    ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
    timing.total = vim.fn.reltimestr(vim.fn.reltime(timing.total))
    timing.average = timing.total * 10000 / num
    vim.dbglog(
      opts.prompt_title .. ':',
      timing.average,
      '(' .. num .. ') ',
      -- opts.finder_type,
      -- '\n',
      -- timing.command,
      -- timing.first_entry,
      timing.total
    )
  end
end

M.commits = function(opts)
  ---@diagnostic disable-next-line: missing-parameter
  local timing = { total = vim.fn.reltime() }
  opts = opts or {}
  -- local relative_file_name = vim.fn.expand('%:~:.')
  opts.source_bufnr = vim.fn.bufnr()
  local script_command = git_utils.init_script_command(opts.source_bufnr)
  -- opts.entry_maker = require('telescope.make_entry').gen_from_string(opts)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))

  return pickers
    .new(opts, {
      prompt_title = 'Git Commits',
      finder = finders.new_oneshot_job(script_command, opts),
      -- previewer = conf.file_previewer(opts),
      previewer = {
        previewers.diff_commit_to_parent.new(opts),
        previewers.diff_commit_to_head.new(opts),
        previewers.diff_commit_as_was.new(opts),
        previewers.commit_message.new(opts),
      },
      sorter = conf.file_sorter(opts),
      on_complete = {
        function(picker)
          -- processed, displayed, looped, previewed
          log_timing(picker, timing, picker.stats.processed)
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
