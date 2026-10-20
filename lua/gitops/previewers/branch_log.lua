local putils = require('telescope.previewers.utils')
local ns_previewer = vim.api.nvim_create_namespace('telescope.previewers')
local git_utils = require('gitops.utils.git')

local branch_log = git_utils.defaulter(function(opts)
  local highlight_buffer = function(bufnr, content)
    for i = 1, #content do
      local line = content[i]
      local _, hstart = line:find('[%*%s|]*')
      if hstart then
        local hend = hstart + 7
        if hend < #line then
          pcall(
            require("utils.hl").add_highlight,
            bufnr,
            ns_previewer,
            'TelescopeResultsIdentifier',
            i - 1,
            hstart - 1,
            hend
          )
        end
      end
      local _, cstart = line:find('- %(')
      if cstart then
        local cend = string.find(line, '%) ')
        if cend then
          pcall(
            require("utils.hl").add_highlight,
            bufnr,
            ns_previewer,
            'TelescopeResultsConstant',
            i - 1,
            cstart - 1,
            cend
          )
        end
      end
      local dstart, _ = line:find(' %(%d')
      if dstart then
        pcall(
          require("utils.hl").add_highlight,
          bufnr,
          ns_previewer,
          'TelescopeResultsSpecialComment',
          i - 1,
          dstart,
          #line
        )
      end
    end
  end

  return git_utils.new_buffer_previewer({
    title = 'Git Branch Preview',
    get_buffer_by_name = function(_, entry)
      return entry.value
    end,

    define_preview = function(self, entry, status)
      local cmd = git_utils.init_git_command(opts.source_bufnr, {
        'log',
        '--graph',
        '--pretty=format:%h -%d %s (%cr)',
        '--abbrev-commit',
        '--date=relative',
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
          highlight_buffer(bufnr, content)
        end,
      })
    end,
  })
end, {})

return branch_log
