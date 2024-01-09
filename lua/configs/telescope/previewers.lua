local from_entry = require('telescope.from_entry')
local conf = require('telescope.config').values
local builtin = require('telescope.builtin')
local previewers = require('telescope.previewers')
local Path = require('plenary.path')

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

M.buffer_cat = function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.loop.cwd()
  return previewers.new_buffer_previewer({
    title = 'File Preview',
    dyn_title = function(_, entry)
      return Path:new(from_entry.path(entry, false, false)):normalize(cwd)
    end,

    get_buffer_by_name = function(_, entry)
      return from_entry.path(entry, false)
    end,

    define_preview = function(self, entry)
      local markdown_cb = function(bufnr)
        vim.schedule(function()
          vim.api.nvim_set_option_value('syntax', 'pandoc', { buf = self.state.bufnr })
          -- local winid = vim.fn.bufwinid(bufnr)
          -- vim.api.nvim_set_option_value('conceallevel', 3, { win = winid })
          -- vim.filetype.add({ extension = { md = 'pandoc' },
          -- vim.api.nvim_set_option_value('conceallevel', 3, { win = winid })
          -- local winid = vim.fn.bufwinid(bufnr)
        end)
      end

      local p = from_entry.path(entry, true)
      if p == nil or p == '' then
        return
      end
      local preview_opts = {
        bufname = self.state.bufname,
        winid = self.state.winid,
        preview = opts.preview,
        file_encoding = opts.file_encoding,
      }

      local extension = vim.fn.fnamemodify(p, ':e')
      if extension == 'md' then
        preview_opts.callback = markdown_cb
      end
      conf.buffer_previewer_maker(p, self.state.bufnr, preview_opts)
    end,
  })
end

return M
