local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local git_utils = require('gitops.utils.git')
local make_entry = require('gitops.make_entry')
local mappings = require('gitops.mappings')
local previewers = require('gitops.previewers')
local logger = require('gitops.utils.logger')

local get_current_buf_line = function(winnr)
  local lnum = vim.api.nvim_win_get_cursor(winnr)[1]
  return vim.trim(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(winnr), lnum - 1, lnum, false)[1])
end

local build_stats_command = function(method, bufnr)
  local cmd = git_utils.init_script_command(bufnr, '--method=' .. method)
  return string.gsub(vim.fn.system(vim.fn.join(cmd, ' ')), '\n', '')
end

local bcommits_stats = function(bufnr, methods)
  methods = methods or { 'range', 'count', 'hash_length', 'author_length', 'subject_length' }
  bufnr = bufnr or vim.fn.bufnr()

  local results = {}
  for _, method in ipairs(methods) do
    results[method] = build_stats_command(method, bufnr)
  end
  return results
end

local bcommits = function(opts)
  local timing = { total = vim.fn.reltime(_, _) }
  opts = opts or {}

  local relative_file_name = vim.fn.expand('%:~:.')
  opts.bufnr = vim.fn.bufnr()
  opts.winnr = vim.fn.bufwinid(opts.bufnr)
  opts.current_line = (opts.current_file == nil) and get_current_buf_line(opts.winnr) or nil
  opts.current_file = vim.F.if_nil(opts.current_file, vim.api.nvim_buf_get_name(opts.bufnr))

  local stats = bcommits_stats(opts.bufnr)

  opts.preview_side_width = opts.preview_side_width or 100
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts, stats))

  local script_command = git_utils.init_script_command(opts.bufnr, opts.current_file)

  return pickers
    .new(opts, {
      prompt_title = 'Git BCommits (' .. relative_file_name .. ')',
      finder = finders.new_oneshot_job(script_command, opts),
      previewer = {
        previewers.diff_delta(vim.tbl_deep_extend('force', opts, {
          git_cmd = { 'show', '--stat', '-p' },
          preview_title = 'Diff to Parent',
        })),
        previewers.diff_delta(vim.tbl_deep_extend('force', opts, {
          git_cmd = { 'diff', '--cached', '--stat', '-p' },
          preview_title = 'Diff to Head',
        })),
      },
      sorter = conf.file_sorter(opts),
      attach_mappings = mappings.build_mappings(opts),
      on_complete = {
        function(picker)
          -- processed, displayed, looped, previewed
          logger.timing(picker, timing, picker.stats.processed)
        end,
      },
    })
    :find()
end
return { bcommits = bcommits, stats = bcommits_stats }
