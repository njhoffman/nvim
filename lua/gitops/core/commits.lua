local strings = require('plenary.strings')
local Path = require('plenary.path')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local utils = require('telescope.utils')
local previewers = require('telescope.previewers')
local action_state = require('telescope.actions.state')
local git_utils = require('gitops.utils.git')
local make_entry = require('gitops.make_entry')
local ops_utils = require('gitops.utils')

local M = {}

local parse_author = function(author)
  -- local date = string.gsub(time_ago, '[)(]+', '')
  -- if short_level == 1 then
  --   date = string.gsub(date, ' ago', '')
  --   if string.match(date, 'years?,') then
  --     date = string.gsub(date, ' years?,? ?', 'yr ')
  --     date = string.gsub(date, ' months? ?', 'mo')
  --   end
  -- elseif short_level == 2 then
  --   date = string.gsub(date, ' ago', '')
  --   date = string.gsub(date, ' ?hours?', 'h')
  --   date = string.gsub(date, ' ?weeks?', 'w')
  --   date = string.gsub(date, ' ?days?', 'd')
  --   if string.match(date, 'years?, ') then
  --     date = string.gsub(date, ' years?,? ?', 'y.')
  --     date = string.gsub(date, ' ?months? ?', 'm')
  --   end
  --   date = string.gsub(date, ' years?', 'y')
  --   date = string.gsub(date, ' months?', 'm')
  -- end
  -- local width = short_level == 2 and 8 or short_level == 1 and 12 or 24
  -- return ops_utils.align_text(date, 'center', width, ' ')
  return author
end

local parse_date = function(time_ago, short_level)
  --    a:6         b:10                c:24
  --    13h      13 hours       1 year, 11 months ago
  --   6d.3h      6 days
  --   2w.4d      2 weeks
  --    12m      12 months
  --    1y        1 year
  --  1y.11m     1 yr 11 mo
  --    2y        2 years

  local date = string.gsub(time_ago, '[)(]+', '')
  if short_level == 1 then
    date = string.gsub(date, ' ago', '')
    if string.match(date, 'years?,') then
      date = string.gsub(date, ' years?,? ?', 'yr ')
      date = string.gsub(date, ' months? ?', 'mo')
    end
  elseif short_level == 2 then
    date = string.gsub(date, ' ago', '')
    date = string.gsub(date, ' ?hours?', 'h')
    date = string.gsub(date, ' ?weeks?', 'w')
    date = string.gsub(date, ' ?days?', 'd')
    if string.match(date, 'years?, ') then
      date = string.gsub(date, ' years?,? ?', 'y.')
      date = string.gsub(date, ' ?months? ?', 'm')
    end
    date = string.gsub(date, ' years?', 'y')
    date = string.gsub(date, ' months?', 'm')
  end
  local width = short_level == 2 and 8 or short_level == 1 and 12 or 24
  return ops_utils.align_text(date, 'center', width, ' ')
  -- return date
end

local parse_log_line = function(line)
  local parts = vim.fn.split(line, ' ')
  if type(parts) ~= 'table' or vim.tbl_count(parts) > 5 then
    vim.notify('Bad response: ' .. vim.inspect(parts), 4)
    return { sha = '--', date = '--', message = '--', author = '--', stat_files = '--', stat_insert = '--', stat_delete = '--' }
  end
  return {
    sha = parts[1],
    date = parse_date(parts[2], 2),
    message = parts[3] or '<empty commit>',
    author = parse_author(parts[4]),
    stat_files = parts[5] and (string.match(parts[5], '(%d+) files? changed') or '0') or '--',
    stat_insert = parts[5] and (string.match(parts[5], '(%d+) insertions?') or '0') or '--',
    stat_delete = parts[5] and (string.match(parts[5], '(%d+) deletions?') or '0') or '--',
  }
end

local static_finder = function(opts, timing)
  local source_bufnr = vim.fn.bufnr()
  local git_command = git_utils.init_git_command(source_bufnr, {
    'log',
    "--format=' @@%<(12,trunc)%H (%ar) %s %an '",
    '--shortstat',
    '--',
    '.',
    "| sed '/^$/d'",
    "| sed 's_\\.\\. _ _g'",
    "| tr '\n' ' '",
    "| sed 's_ @@_\\n_g'",
    "| sed 's_^@@__g'",
  })
  local git_command_str = vim.fn.join(git_command, ' ')
  local output = vim.fn.split(vim.fn.system(git_command_str) or '', '\n')
  -- local output = utils.get_os_command_output(git_command, opts.cwd)
  -- local output = os.execute(vim.fn.join(git_command, ' '))

  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  timing.command = vim.fn.reltimestr(vim.fn.reltime(timing.total))
  local parsed = vim.tbl_map(parse_log_line, output)
  local widths = ops_utils.get_widths(parsed)
  return finders.new_table({
    results = parsed,
    entry_maker = opts.entry_maker(widths, timing),
  })
end

local dynamic_finder = function(opts, timing)
  local source_bufnr = vim.fn.bufnr()
  local script_command = git_utils.init_script_command(source_bufnr)
  ---@diagnostic disable-next-line: missing-parameter, param-type-mismatch
  vim.dbglog('executing: ', script_command)
  return finders.new_oneshot_job(script_command, { entry_maker = opts.entry_maker({}, timing) })
end

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
    vim.dbglog(opts.prompt_title .. ':', timing.average, '(' .. num .. ') ', opts.finder_type, '\n', timing.command, timing.first_entry, timing.total)
  end
end

M.commits = function(opts)
  ---@diagnostic disable-next-line: missing-parameter
  local timing = { total = vim.fn.reltime() }
  opts = opts or {}
  opts.finder_type = opts.finder_type or 'dynamic'
  opts.prompt_title = opts.prompt_title or 'Git Commits'
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))
  -- local relative_file_name = vim.fn.expand('%:~:.')
  local finder = opts.finder_type == 'static' and static_finder or dynamic_finder

  pickers
    .new(opts, {
      prompt_title = opts.prompt_title,
      finder = finder(opts, timing),
      on_complete = {
        function(res)
          -- processed, displayed, looped, previewed
          log_timing(opts, timing, res.stats.processed)
        end,
      },
      -- previewer = {
      --   previewers.git_commit_diff_to_parent.new(opts),
      --   previewers.git_commit_diff_to_head.new(opts),
      --   previewers.git_commit_diff_as_was.new(opts),
      --   previewers.git_commit_message.new(opts),
      -- },
      sorter = conf.file_sorter(opts),
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
