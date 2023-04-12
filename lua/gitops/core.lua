local Path = require("plenary.path")
local strings = require("plenary.strings")
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local utils = require("telescope.utils")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")

local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local git_utils = require("gitops.utils.git")

local get_current_buf_line = function(winnr)
  local lnum = vim.api.nvim_win_get_cursor(winnr)[1]
  return vim.trim(vim.api.nvim_buf_get_lines(vim.api.nvim_win_get_buf(winnr), lnum - 1, lnum, false)[1])
end

local M = {}

M.files = function(opts)
  if opts.is_bare then
    vim.notify("This operation must be run in a work tree", 5)
    return
  end

  local show_untracked = vim.F.if_nil(opts.show_untracked, false)
  local recurse_submodules = vim.F.if_nil(opts.recurse_submodules, false)

  if show_untracked and recurse_submodules then
    vim.notify("Git does not support both --others and --recurse-submodules", 5)
    return
  end
  -- By creating the entry maker after the cwd options, we ensure the maker uses the cwd options when being created.
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_file(opts))

  local bufnr = vim.fn.bufnr()
  local command = { "git" }
  local repo = git_utils.get_repo(bufnr)
  if repo.gitdir then
    table.insert(command, "--git-dir=" .. repo.gitdir)
    table.insert(command, "--work-tree=" .. repo.worktree)
  end
  table.insert(command, "ls-files")
  table.insert(command, "--exclude-standard")
  table.insert(command, "--cached")
  local git_command = opts and opts.git_command or command

  local conf = require("telescope.config").values
  local cmd_str = vim.tbl_flatten({
    git_command,
    show_untracked and "--others" or nil,
    recurse_submodules and "--recurse-submodules" or nil,
  })
  pickers
    .new({
      prompt_title = "Git Files",
      finder = finders.new_oneshot_job(cmd_str, opts),
      previewer = conf.file_previewer(opts),
      sorter = conf.file_sorter(opts),
    }, {})
    :find()
end

M.files_summary = function()
  return "files summary"
end

M.status = function(opts)
  if opts.is_bare then
    vim.notify("This operation must be run in a work tree", 5)
    return
  end

  local conf = require("telescope.config").values

  local gen_new_finder = function()
    local expand_dir = vim.F.if_nil(opts.expand_dir, true)

    local bufnr = vim.fn.bufnr()
    local command = { "git" }
    local repo = git_utils.get_repo(bufnr)
    if repo.gitdir then
      table.insert(command, "--git-dir=" .. repo.gitdir)
      table.insert(command, "--work-tree=" .. repo.worktree)
    end

    table.insert(command, "status")
    table.insert(command, "-z")
    table.insert(command, "--")
    table.insert(command, ".")
    if expand_dir then
      table.insert(command, #command - 1, "-u")
    end

    local git_command = opts and opts.git_command or command
    local output = utils.get_os_command_output(git_command, opts.cwd)

    if #output == 0 then
      vim.notify("No changes found", 4)
      return
    end

    return finders.new_table({
      results = vim.split(output[1], " ", { trimempty = true }),
      entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_status(opts)),
    })
  end
  M.status_summary = function()
    return "status summary"
  end

  local initial_finder = gen_new_finder()
  if not initial_finder then
    return
  end

  pickers
    .new(opts, {
      prompt_title = "Git Status",
      finder = initial_finder,
      previewer = previewers.git_file_diff.new(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.git_staging_toggle:enhance({
          post = function()
            local picker = action_state.get_current_picker(prompt_bufnr)

            -- temporarily register a callback which keeps selection on refresh
            local selection = picker:get_selection_row()
            local callbacks = { unpack(picker._completion_callbacks) } -- shallow copy
            picker:register_completion_callback(function(self)
              self:set_selection(selection)
              self._completion_callbacks = callbacks
            end)

            -- refresh
            picker:refresh(gen_new_finder(), { reset_prompt = false })
          end,
        })

        map({ "i", "n" }, "<tab>", actions.git_staging_toggle)
        return true
      end,
    })
    :find()
end

M.status_summary = function(bufnr)
  return "status summary"
end

M.commits = function(bufnr)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))

  local command = git_utils.init_git_command(bufnr)
  table.insert(command, "log")
  table.insert(command, "--pretty=oneline")
  table.insert(command, "--abbrev-commit")
  table.insert(command, "--")
  table.insert(command, ".")

  local git_command = opts and opts.git_command or command
  local conf = require("telescope.config").values

  pickers
    .new(opts, {
      prompt_title = "Git Commits",
      finder = finders.new_oneshot_job(git_command, opts),
      previewer = {
        previewers.git_commit_diff_to_parent.new(opts),
        previewers.git_commit_diff_to_head.new(opts),
        previewers.git_commit_diff_as_was.new(opts),
        previewers.git_commit_message.new(opts),
      },
      sorter = conf.file_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(actions.git_checkout_current_buffer)
        local transfrom_file = function()
          return opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd) or ""
        end

        local get_buffer_of_orig = function(selection)
          local value = selection.value .. ":" .. transfrom_file()

          local _command = git_utils.init_git_command(bufnr)
          table.insert(_command, "--no-pager")
          table.insert(_command, "show")
          table.insert(_command, "value")
          local content = utils.get_os__command_output(_command, opts.cwd)

          local _bufnr = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(_bufnr, 0, -1, false, content)
          vim.api.nvim_buf_set_name(_bufnr, "Original")
          return bufnr
        end

        local vimdiff = function(selection, cmd)
          local ft = vim.bo.filetype
          vim.cmd("diffthis")

          local _bufnr = get_buffer_of_orig(selection)
          vim.cmd(string.format("%s %s", cmd, _bufnr))
          vim.bo.filetype = ft
          vim.cmd("diffthis")

          vim.api.nvim_create_autocmd("WinClosed", {
            buffer = bufnr,
            nested = true,
            once = true,
            callback = function()
              vim.api.nvim_buf_delete(_bufnr, { force = true })
            end,
          })
        end

        actions.select_vertical:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vimdiff(selection, "leftabove vert sbuffer")
        end)

        actions.select_horizontal:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vimdiff(selection, "belowright sbuffer")
        end)

        actions.select_tab:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd("tabedit " .. transfrom_file())
          vimdiff(selection, "leftabove vert sbuffer")
        end)
        return true
      end,
    })
    :find()
end

M.commits_summary = function(bufnr, opts)
  opts = opts or {}
  local command = git_utils.init_git_command(bufnr)
  table.insert(command, "log")
  table.insert(command, "--pretty=oneline")
  table.insert(command, "--abbrev-commit")
  table.insert(command, "--")
  table.insert(command, ".")
  -- local git_command = opts and opts.git_command or vim.fn.join(command, " ")

  -- local async_oneshot_finder = require("telescope.finders.async_oneshot_finder")
  local git_command = opts and opts.git_command or command
  -- local data = finders.new_oneshot_job(git_command, opts)
  -- local data = finders.new_oneshot_job({ "ls", "-1" }, opts)
  local data = vim.fn.execute({ "!ls", "-1" })

  vim.dbglog("DATA", data)
  return data

  -- opts.cwd = vim.fn.getcwd()
  -- return async_oneshot_finder {
  --   entry_maker = opts.entry_maker or make_entry.gen_from_string(opts),
  --
  --   cwd = opts.cwd,
  --   maximum_results = opts.maximum_results,
  --
  --   fn_command = function()
  --     return {
  --       command = command,
  --       args = command_list,
  --     }
  --   end,
  -- return finders.new_oneshot_job(git_command, opts)
end

M.bcommits = function(opts)
  opts.current_line = (opts.current_file == nil) and get_current_buf_line(opts.winnr) or nil
  opts.current_file = vim.F.if_nil(opts.current_file, vim.api.nvim_buf_get_name(opts.bufnr))
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_commits(opts))

  local bufnr = vim.fn.bufnr()
  local command = { "git" }
  local repo = git_utils.get_repo(bufnr)
  if repo.gitdir then
    table.insert(command, "--git-dir=" .. repo.gitdir)
    table.insert(command, "--work-tree=" .. repo.worktree)
  end
  table.insert(command, "log")
  table.insert(command, "--pretty=oneline")
  table.insert(command, "--abbrev-commit")
  table.insert(command, "--follow")
  local git_command = opts and opts.git_command or command

  local conf = require("telescope.config").values
  pickers
    .new(opts, {
      prompt_title = "Git BCommits",
      finder = finders.new_oneshot_job(vim.tbl_flatten({ git_command, opts.current_file }), opts),
      previewer = {
        previewers.git_commit_diff_to_parent.new(opts),
        previewers.git_commit_diff_to_head.new(opts),
        previewers.git_commit_diff_as_was.new(opts),
        previewers.git_commit_message.new(opts),
      },
      sorter = conf.file_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(actions.git_checkout_current_buffer)
        local transfrom_file = function()
          return opts.current_file and Path:new(opts.current_file):make_relative(opts.cwd) or ""
        end

        local get_buffer_of_orig = function(selection)
          local value = selection.value .. ":" .. transfrom_file()
          local content = utils.get_os_command_output({ "git", "--no-pager", "show", value }, opts.cwd)

          local _bufnr = vim.api.nvim_create_buf(false, true)
          vim.api.nvim_buf_set_lines(_bufnr, 0, -1, false, content)
          vim.api.nvim_buf_set_name(_bufnr, "Original")
          return bufnr
        end

        local vimdiff = function(selection, cmd)
          local ft = vim.bo.filetype
          vim.cmd("diffthis")

          local _bufnr = get_buffer_of_orig(selection)
          vim.cmd(string.format("%s %s", cmd, _bufnr))
          vim.bo.filetype = ft
          vim.cmd("diffthis")

          vim.api.nvim_create_autocmd("WinClosed", {
            buffer = bufnr,
            nested = true,
            once = true,
            callback = function()
              vim.api.nvim_buf_delete(_bufnr, { force = true })
            end,
          })
        end

        actions.select_vertical:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vimdiff(selection, "leftabove vert sbuffer")
        end)

        actions.select_horizontal:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vimdiff(selection, "belowright sbuffer")
        end)

        actions.select_tab:replace(function(prompt_bufnr)
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          vim.cmd("tabedit " .. transfrom_file())
          vimdiff(selection, "leftabove vert sbuffer")
        end)
        return true
      end,
    })
    :find()
end

M.bcommits_summary = function()
  return "bcommits summary"
end

M.stash = function(opts)
  opts.show_branch = vim.F.if_nil(opts.show_branch, true)
  opts.entry_maker = vim.F.if_nil(opts.entry_maker, make_entry.gen_from_git_stash(opts))

  local bufnr = vim.fn.bufnr()
  local command = { "git" }
  local repo = git_utils.get_repo(bufnr)
  if repo.gitdir then
    table.insert(command, "--git-dir=" .. repo.gitdir)
    table.insert(command, "--work-tree=" .. repo.worktree)
  end
  table.insert(command, "--no-pager")
  table.insert(command, "stash")
  table.insert(command, "list")

  local git_command = opts and opts.git_command or command
  local conf = require("telescope.config").values

  pickers
    .new(opts, {
      prompt_title = "Git Stash",
      finder = finders.new_oneshot_job(vim.tbl_flatten(git_command), opts),
      previewer = previewers.git_stash_diff.new(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function()
        actions.select_default:replace(actions.git_apply_stash)
        return true
      end,
    })
    :find()
end

M.stash_summary = function()
  return "stash summary"
end
M.branches = function(opts)
  local command = { "git" }
  local repo = git_utils.get_repo(bufnr)
  if repo.gitdir then
    table.insert(command, "--git-dir=" .. repo.gitdir)
    table.insert(command, "--work-tree=" .. repo.worktree)
  end
  table.insert(command, "for-each-ref")
  table.insert(command, "--perl")
  table.insert(command, "--format")
  table.insert(
    command,
    "%(HEAD)"
      .. "%(refname)"
      .. "%(authorname)"
      .. "%(upstream:lstrip=2)"
      .. "%(committerdate:format-local:%Y/%m/%d %H:%M:%S)"
  )
  table.insert(command, "--sort")
  table.insert(command, "-authordate")
  table.insert(command, opts.pattern)
  local git_command = opts and opts.git_command or command
  local output = utils.get_os_command_output(git_command, opts.cwd)
  local show_remote_tracking_branches = vim.F.if_nil(opts.show_remote_tracking_branches, true)

  local results = {}

  local widths = {
    name = 0,
    authorname = 0,
    upstream = 0,
    committerdate = 0,
  }
  local unescape_single_quote = function(v)
    return string.gsub(v, "\\([\\'])", "%1")
  end
  local parse_line = function(line)
    local fields = vim.fn.split(string.sub(line, 2, -2), "''", true)
    local entry = {
      head = fields[1],
      refname = unescape_single_quote(fields[2]),
      authorname = unescape_single_quote(fields[3]),
      upstream = unescape_single_quote(fields[4]),
      committerdate = fields[5],
    }
    local prefix
    if vim.startswith(entry.refname, "refs/remotes/") then
      if show_remote_tracking_branches then
        prefix = "refs/remotes/"
      else
        return
      end
    elseif vim.startswith(entry.refname, "refs/heads/") then
      prefix = "refs/heads/"
    else
      return
    end
    local index = 1
    if entry.head ~= "*" then
      index = #results + 1
    end

    entry.name = string.sub(entry.refname, string.len(prefix) + 1)
    for key, value in pairs(widths) do
      widths[key] = math.max(value, strings.strdisplaywidth(entry[key] or ""))
    end
    if string.len(entry.upstream) > 0 then
      widths.upstream_indicator = 2
    end
    table.insert(results, index, entry)
  end
  for _, line in ipairs(output) do
    parse_line(line)
  end
  if #results == 0 then
    return
  end

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 1 },
      { width = widths.name },
      { width = widths.authorname },
      { width = widths.upstream_indicator },
      { width = widths.upstream },
      { width = widths.committerdate },
    },
  })

  local make_display = function(entry)
    return displayer({
      { entry.head },
      { entry.name, "TelescopeResultsIdentifier" },
      { entry.authorname },
      { string.len(entry.upstream) > 0 and "=>" or "" },
      { entry.upstream, "TelescopeResultsIdentifier" },
      { entry.committerdate },
    })
  end

  local conf = require("telescope.config").values

  pickers
    .new(opts, {
      prompt_title = "Git Branches",
      finder = finders.new_table({
        results = results,
        entry_maker = function(entry)
          entry.value = entry.name
          entry.ordinal = entry.name
          entry.display = make_display
          return make_entry.set_default_entry_mt(entry, opts)
        end,
      }),
      previewer = previewers.git_branch_log.new(opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(_, map)
        actions.select_default:replace(actions.git_checkout)
        map({ "i", "n" }, "<c-t>", actions.git_track_branch)
        map({ "i", "n" }, "<c-r>", actions.git_rebase_branch)
        map({ "i", "n" }, "<c-a>", actions.git_create_branch)
        map({ "i", "n" }, "<c-s>", actions.git_switch_branch)
        map({ "i", "n" }, "<c-d>", actions.git_delete_branch)
        map({ "i", "n" }, "<c-y>", actions.git_merge_branch)
        return true
      end,
    })
    :find()
end

M.branch_summary = function()
  return "branch summary"
end

return M
