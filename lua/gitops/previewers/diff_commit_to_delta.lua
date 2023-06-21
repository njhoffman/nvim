local git_utils = require('gitops.utils.git')
local previewers = require('telescope.previewers')

-- [delta]
--   navigate = true    # use n and N to move between diff sections
--   light = false      # set to true if you're in a terminal w/ a light background color (e.g. the default macOS terminal)
--   diff-so-fancy = false
--   diff-highlight = false
--   features = chamelon #  decorations
--   file-decoration-style = none
--   line-numbers = true
--blame-format <FMT>  Format string for git blame commit metadata [default: "{timestamp:<15} {author:<15.14} {commit:<8}"]
--blame-separator-format <FMT> Separator between the blame format and the code section of a git blame line [default: │{n:^4}│]
--blame-timestamp-format <FMT> Format of `git blame` timestamp in raw git output received by delta [default: "%Y-%m-%d %H:%M:%S %z"]

local diff_commit_to_delta = function(opts)
  return previewers.new_termopen_previewer({
    title = opts.preview_title or 'Diff to Delta',
    get_command = function(entry)
      local git_args = vim.fn.deepcopy(opts.git_args) or {}
      local git_cmd = vim.fn.deepcopy(opts.git_cmd) or {}
      git_cmd = type(git_cmd) == 'string' and { git_cmd } or git_cmd

      for _, arg in ipairs(git_cmd) do
        table.insert(git_args, arg)
      end

      if opts.git_parent then
        table.insert(git_args, entry.value.sha .. '^!')
      else
        table.insert(git_args, entry.value.sha)
      end

      -- if entry.value.status == '??' or 'A ' then
      --   table.insert(git_args, entry.value.sha)
      -- else
      --   table.insert(git_args, entry.value.sha .. '^!')
      -- end
      --
      if opts.current_file then
        table.insert(git_args, opts.current_file)
      end

      return git_utils.init_git_command(opts.bufnr, git_args)
    end,
  })
end

return diff_commit_to_delta
