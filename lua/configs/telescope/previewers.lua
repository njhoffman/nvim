local builtin = require('telescope.builtin')
local previewers = require('telescope.previewers')

local M = {}

-- NOTE: go check if file is in specific git repo: dotbare ls-files --error-unmatch ~/.zlua

M.git_status = function(opts)
  opts = opts or {}
  opts.previewer = previewers.new_termopen_previewer({
    get_command = function(entry)
      if entry.status == 'D ' then
        return { 'git', 'show', 'HEAD:' .. entry.value }
      elseif entry.status == '??' then
        return { 'bat', '--style=plain', entry.value }
      end
      return {
        'git',
        '-c',
        'core.pager=delta',
        '-c',
        'delta.pager=less -R',
        'diff',
        entry.value,
      }
    end,
  })

  -- Use icons that resemble the `git status` command line.
  opts.git_icons = {
    added = 'A',
    changed = 'M',
    copied = 'C',
    deleted = '-',
    renamed = 'R',
    unmerged = 'U',
    untracked = '?',
  }

  builtin.git_status(opts)
end

M.git_bcommits = previewers.new_termopen_previewer({
  get_command = function(entry)
    return {
      'git',
      '-c',
      'core.pager=delta',
      -- "-c",
      -- "delta.pager=less -R",
      'show',
      entry.value,
    }
  end,
})

M.delta = previewers.new_termopen_previewer({
  get_command = function(entry)
    if entry.status == '??' or 'A ' then
      return { 'git', 'diff', entry.value }
    end
    return { 'git', 'diff', entry.value .. '^!' }
  end,
})

return M
