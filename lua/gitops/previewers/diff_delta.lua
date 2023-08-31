local git_utils = require('gitops.utils.git')
local previewers = require('telescope.previewers')

--blame-format <FMT>  Format string for git blame commit metadata [default: "{timestamp:<15} {author:<15.14} {commit:<8}"]
--blame-separator-format <FMT> Separator between the blame format and the code section of a git blame line [default: │{n:^4}│]
--blame-timestamp-format <FMT> Format of `git blame` timestamp in raw git output received by delta [default: "%Y-%m-%d %H:%M:%S %z"]
-- -wrap-max-lines, --wrap-left-symbol, --wrap-right-symbol, --wrap-right-percent, --wrap-right-prefix-symbol, --inline-hint-style

local default_git_args = {
  '-c',
  'core.pager=delta',
  '-c',
  'delta.diff-so-fancy=false',
  '-c',
  'delta.navigate=false',
  '-c',
  'delta.pager=less -R',
}

local diff_delta = function(opts)
  opts = opts or {}
  return previewers.new_termopen_previewer({
    title = opts.preview_title or 'Diff Delta',
    get_command = function(entry)
      local winwidth = vim.api.nvim_win_get_width(0)
      local git_args = vim.fn.deepcopy(opts.git_args or default_git_args)
      if opts.preview_side_width > 0 and opts.preview_side_width < winwidth then
        table.insert(git_args, '-c')
        table.insert(git_args, 'delta.side-by-side=true')
      end

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

return diff_delta
