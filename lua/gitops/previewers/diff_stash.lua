local putils = require('telescope.previewers.utils')
local git_utils = require('gitops.utils.git')

local diff_stash = git_utils.defaulter(function(opts)
  return git_utils.new_buffer_previewer({
    title = 'Git Stash Preview',
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, _)
      local cmd = git_utils.init_git_command(opts.source_bufnr, {
        'stash',
        'show',
        '-p',
        entry.value.sha,
      })

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr)
          if vim.api.nvim_buf_is_valid(bufnr) then
            putils.regex_highlighter(bufnr, 'diff')
          end
        end,
      })
    end,
  })
end, {})

return diff_stash
