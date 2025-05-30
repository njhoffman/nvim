local git_utils = require("gitops.utils.git")
local previewers = require("telescope.previewers")

--blame-format <FMT>  Format string for git blame commit metadata [default: "{timestamp:<15} {author:<15.14} {commit:<8}"]
--blame-separator-format <FMT> Separator between the blame format and the code section of a git blame line [default: │{n:^4}│]
--blame-timestamp-format <FMT> Format of `git blame` timestamp in raw git output received by delta [default: "%Y-%m-%d %H:%M:%S %z"]
-- -wrap-max-lines, --wrap-left-symbol, --wrap-right-symbol, --wrap-right-percent, --wrap-right-prefix-symbol, --inline-hint-style
--       ["nv.LESS"] = "-RS",
-- 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!', '--', entry.current_file

local default_git_args = {
  "-c",
  "core.pager=delta-dynamic",
  "-c",
  "delta.diff-so-fancy=false",
  "-c",
  "delta.navigate=false",

  -- "delta.pager=less -R",
  -- "-c",
  -- "delta.pager=bat",
  -- "core.side-by-side=false",
  -- entry.value .. "^!",
}

local diff_delta = function(opts)
  opts = opts or {}
  return previewers.new_termopen_previewer({
    title = opts.preview_title or "Diff Delta",
    get_command = function(entry)
      local winwidth = vim.api.nvim_win_get_width(0)
      local git_args = vim.fn.deepcopy(opts.git_args or default_git_args)
      if opts.preview_side_width > 0 and opts.preview_side_width < winwidth then
        table.insert(git_args, "-c")
        table.insert(git_args, "delta.side-by-side=true")
      end

      local git_cmd = vim.fn.deepcopy(opts.git_cmd) or {}
      git_cmd = type(git_cmd) == "string" and { git_cmd } or git_cmd

      for _, arg in ipairs(git_cmd) do
        table.insert(git_args, arg)
      end

      if opts.git_parent then
        table.insert(git_args, entry.value.sha .. "^!")
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
        table.insert(git_args, "--")
        table.insert(git_args, opts.current_file)
      end

      return git_utils.init_git_command(opts.bufnr, git_args)
    end,
  })
end

-- local delta = previewers.new_termopen_previewer({
--   get_command = function(entry)
--     print(vim.inspect(entry))
--     -- this is for status
--     -- You can get the AM things in entry.status. So we are displaying file if entry.status == '??' or 'A '
--     -- just do an if and return a different command
--     if entry.status == "??" or "A " then
--       return {
--         "git",
--         "-c",
--         "core.pager=delta",
--         "-c",
--         "delta.side-by-side=false",
--         "diff",
--         entry.value,
--       }
--     end
--     -- note we can't use pipes
--     -- this command is for git_commits and git_bcommits
--     return {
--       "git",
--       "-c",
--       "core.pager=delta",
--       "-c",
--       "delta.side-by-side=false",
--       "diff",
--       entry.value .. "^!",
--     }
--   end,
-- })
-- require("telescope.builtin").git_commits({ previewer = { delta } })

-- local previewers = require("telescope.previewers")
-- local builtin = require("telescope.builtin")
--
-- local delta_bcommits = previewers.new_termopen_previewer({
-- 	get_command = function(entry)
-- 		return {
-- 			"git",
-- 			"-c",
-- 			"core.pager=delta",
-- 			"-c",
-- 			"delta.side-by-side=false",
-- 			"diff",
-- 			entry.value .. "^!",
-- 			"--",
-- 			entry.current_file,
-- 		}
-- 	end,
-- })
--
-- local delta = previewers.new_termopen_previewer({
-- 	get_command = function(entry)
-- 		return { "git", "-c", "core.pager=delta", "-c", "delta.side-by-side=false", "diff", entry.value .. "^!" }
-- 	end,
-- })
--
-- Delta_git_commits = function(opts)
-- 	opts = opts or {}
-- 	opts.previewer = {
-- 		delta,
-- 		previewers.git_commit_message.new(opts),
-- 		previewers.git_commit_diff_as_was.new(opts),
-- 	}
-- 	builtin.git_commits(opts)
-- end
--
-- Delta_git_bcommits = function(opts)
-- 	opts = opts or {}
-- 	opts.previewer = {
-- 		delta_bcommits,
-- 		previewers.git_commit_message.new(opts),
-- 		previewers.git_commit_diff_as_was.new(opts),
-- 	}
-- 	builtin.git_bcommits(opts)
-- end
--
-- vim.api.nvim_set_keymap("n", "<F5>", "<cmd>lua Delta_git_commits()<CR>", default_opts)
-- vim.api.nvim_set_keymap("n", "<F6>", "<cmd>lua Delta_git_bcommits()<CR>", default_opts)
return diff_delta
