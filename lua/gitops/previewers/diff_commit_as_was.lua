local pfiletype = require('plenary.filetype')
local Path = require('plenary.path')
local putils = require('telescope.previewers.utils')
local git_utils = require('gitops.utils.git')

local commit_diff_as_was = git_utils.defaulter(function(opts)
  return git_utils.new_buffer_previewer({
    title = 'Git Show Preview',
    teardown = git_utils.search_teardown,

    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      -- local cmd = { 'git', '--no-pager', 'show' }
      local cf = opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd)
      local value = cf and (entry.value.sha .. ':' .. cf) or entry.value.sha
      local ft = cf and pfiletype.detect(value) or 'diff'
      local cmd = git_utils.init_git_command(opts.bufnr, {
        'show',
        value,
      })

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            git_utils.search_cb_jump(self, bufnr, opts.current_line)
            putils.regex_highlighter(bufnr, ft)
          end
        end,
      })
    end,
  })
end, {})

return commit_diff_as_was
