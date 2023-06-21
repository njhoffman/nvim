local putils = require('telescope.previewers.utils')
local git_utils = require('gitops.utils.git')

local diff_commit_to_head = git_utils.defaulter(function(opts)
  return git_utils.new_buffer_previewer({
    title = 'Git Diff to Head Preview',
    teardown = git_utils.search_teardown,

    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      -- local cmd = { 'git', '--no-pager', 'diff', '--cached', entry.value }
      local cmd = git_utils.init_git_command(opts.bufnr, {
        'diff',
        '--cached',
        entry.value.sha,
      })
      if opts.current_file then
        table.insert(cmd, '--')
        table.insert(cmd, opts.current_file)
      end

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            git_utils.search_cb_jump(self, bufnr, opts.current_line)
            putils.regex_highlighter(bufnr, 'diff')
          end
        end,
      })
    end,
  })
end, {})

return diff_commit_to_head
