local putils = require('telescope.previewers.utils')
local ns_previewer = vim.api.nvim_create_namespace('telescope.previewers')
local git_utils = require('gitops.utils.git')

local commit_message = git_utils.defaulter(function(opts)
  local hl_map = {
    'TelescopeResultsIdentifier',
    'TelescopePreviewUser',
    'TelescopePreviewDate',
  }

  return git_utils.new_buffer_previewer({
    title = 'Git Message',
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      -- local cmd = { 'git', '--no-pager' }
      local cmd = git_utils.init_git_command(opts.source_bufnr, {
        'log',
        '-n 1',
        entry.value.sha,
      })

      putils.job_maker(cmd, self.state.bufnr, {
        value = entry.value,
        bufname = self.state.bufname,
        cwd = opts.cwd,
        callback = function(bufnr, content)
          if not content then
            return
          end
          for k, v in ipairs(hl_map) do
            local _, s = content[k]:find('%s')
            if s then
              vim.api.nvim_buf_add_highlight(bufnr, ns_previewer, v, k - 1, s, #content[k])
            end
          end
        end,
      })
    end,
  })
end, {})

return { commit_message = commit_message }
