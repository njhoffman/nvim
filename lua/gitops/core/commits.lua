local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local conf = require('telescope.config').values
local Path = require('plenary.path')
local action_state = require('telescope.actions.state')
local utils = require('telescope.utils')

local git_utils = require('gitops.utils.git')
local make_entry = require('gitops.make_entry')
local previewers = require('gitops.previewers')
local logger = require('gitops.utils.logger')

local build_stats_command = function(method, bufnr)
  local cmd = git_utils.init_script_command(bufnr, '--method=' .. method)
  return string.gsub(vim.fn.system(vim.fn.join(cmd, ' ')), '\n', '')
end

local commits_stats = function(bufnr, methods)
  methods = methods or { 'range', 'count', 'hash_length', 'author_length', 'subject_length' }
  bufnr = bufnr or vim.fn.bufnr()

  local results = {}
  for _, method in ipairs(methods) do
    results[method] = build_stats_command(method, bufnr)
  end
  return results
end

local default_git_preview =
  { '-c', 'core.pager=delta', '-c', 'delta.diff-so-fancy=false', '-c', 'delta.navigate=false' }
-- '-c', 'delta.side-by-side=true',

local build_previewers = function(opts)
  local opts_parent = vim.tbl_deep_extend('force', opts, {
    git_cmd = 'diff',
    git_args = opts.git_args or default_git_preview,
    git_parent = true,
    preview_title = 'Diff to Parent',
  })

  local opts_head = vim.tbl_deep_extend('force', opts, {
    git_cmd = { 'diff', '--cached' },
    git_args = opts.git_args or default_git_preview,
    preview_title = 'Diff to HEAD',
  })

  local opts_as_was = vim.tbl_deep_extend('force', opts, {
    git_cmd = 'show',
    git_args = opts.git_args or default_git_preview,
    preview_title = 'Show to Parent',
  })
  return {
    previewers.diff_commit_to_delta(opts_parent),
    previewers.diff_commit_to_delta(opts_head),
    previewers.diff_commit_to_delta(opts_as_was),
  }
end

local transfrom_file = function(opts)
  return opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd) or ''
end

local get_buffer_of_orig = function(selection, opts)
  local value = selection.value .. ':' .. transfrom_file()
  local command = git_utils.init_git_command(opts.bufnr, {
    '--no-pager',
    'show',
    value,
  })

  local content = utils.get_os_command_output(command, opts.cwd)

  local _bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(_bufnr, 0, -1, false, content)
  vim.api.nvim_buf_set_name(_bufnr, 'Original')
  return _bufnr
end

local vimdiff = function(selection, cmd, opts)
  local ft = vim.bo.filetype
  vim.cmd('diffthis')

  local _bufnr = get_buffer_of_orig(selection)
  vim.cmd(string.format('%s %s', cmd, _bufnr))
  vim.bo.filetype = ft
  vim.cmd('diffthis')

  vim.api.nvim_create_autocmd('WinClosed', {
    buffer = opts.bufnr,
    nested = true,
    once = true,
    callback = function()
      vim.api.nvim_buf_delete(_bufnr, { force = true })
    end,
  })
end

local build_mappings = function(opts)
  return function(_, _) -- prompt_bufnr, map
    --   actions.select_default:replace(actions.git_checkout)
    --   map({ "i", "n" }, "<c-r>m", actions.git_reset_mixed)
    --   map({ "i", "n" }, "<c-r>s", actions.git_reset_soft)
    --   map({ "i", "n" }, "<c-r>h", actions.git_reset_hard)
    --- Checkout a specific file for a given sha
    ---@param prompt_bufnr number: The prompt bufnr
    local git_checkout_current_buffer = function(prompt_bufnr)
      local cwd = action_state.get_current_picker(prompt_bufnr).cwd
      local selection = action_state.get_selected_entry()
      if selection == nil then
        utils.__warn_no_selection('actions.git_checkout_current_buffer')
        return
      end
      actions.close(prompt_bufnr)
      local command = git_utils.init_git_command(opts.bufnr, {
        'checkout',
        selection.value.sha,
        '--',
        selection.current_file,
      })
      utils.get_os_command_output(command, cwd)
      logger.info('checkout (cwd ' .. cwd .. ')\n  ' .. vim.fn.join(command, '\n  '))
      vim.cmd('checktime')
    end

    actions.select_default:replace(git_checkout_current_buffer)

    actions.select_vertical:replace(function(prompt_bufnr)
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      vimdiff(selection, 'leftabove vert sbuffer', opts)
    end)

    actions.select_horizontal:replace(function(prompt_bufnr)
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      vimdiff(selection, 'belowright sbuffer', opts)
    end)

    actions.select_tab:replace(function(prompt_bufnr)
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      vim.cmd('tabedit ' .. transfrom_file(opts))
      vimdiff(selection, 'leftabove vert sbuffer', opts)
    end)
    return true
  end
end

local get_current_buf_line = function(winnr)
  local lnum = vim.api.nvim_win_get_cursor(winnr)[1]
  return vim.trim(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(winnr), lnum - 1, lnum, false)[1])
end

local commits = function(opts)
  local timing = { total = vim.fn.reltime(_, _) }
  opts = opts or {}

  -- local relative_file_name = vim.fn.expand('%:~:.')
  opts.bufnr = vim.fn.bufnr()
  opts.winnr = vim.fn.bufwinid(opts.bufnr)
  opts.current_line = (opts.current_file == nil) and get_current_buf_line(opts.winnr) or nil
  opts.current_file = vim.F.if_nil(opts.current_file, vim.api.nvim_buf_get_name(opts.bufnr))

  local stats = commits_stats(opts.bufnr)

  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts, stats))

  local script_command = git_utils.init_script_command(opts.bufnr)

  return pickers
    .new(opts, {
      prompt_title = 'Git Commits',
      finder = finders.new_oneshot_job(script_command, opts),
      previewer = build_previewers(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = build_mappings(opts),
      on_complete = {
        function(picker)
          -- processed, displayed, looped, previewed
          logger.timing(picker, timing, picker.stats.processed)
        end,
      },
    })
    :find()
end

return { commits = commits, commits_stats = commits_stats }
