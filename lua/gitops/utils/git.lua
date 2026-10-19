local pfiletype = require("plenary.filetype")
local conf = require("telescope.config").values
local Previewer = require("telescope.previewers.previewer")
local tele_utils = require("telescope.utils")
local buf_delete = tele_utils.buf_delete

local file_util = require("gitops.utils.file")
local config = require("gitops.utils.config")
local command_util = require("gitops.utils.command")
local utils = require("gitops.utils")
local logger = require("gitops.utils.logger")

local M = {}

-- TODO: git grep foo $(git rev-list --all)
-- TODO: git grep --all-match -l -e "f[^\s]*\s" -e bar $(git rev-list --all)

local all_commit_hashes = function()
  local command = "git rev-list --all"
  local output = command_util.execute(command)

  return tele_utils.split_string(output, "\n")
end

local all_commit_hashes_touching_file = function(git_relative_file_path, source_bufnr)
  local gs_repo = utils.get_repo(source_bufnr) or {}
  -- local repo = file_util.git_dir() or (gs_repo and gs_repo.root) or ''
  local repo = file_util.git_dir()
  local command = "cd "
    .. repo
    .. " && git log --all --follow --pretty=format:'%H' -- "
    .. git_relative_file_path

  local output = command_util.execute(command)
  return tele_utils.split_string(output, "\n")
end

local git_diff_command = function(command, git_flags_ix, git_diff_flags_ix)
  local bufnr = vim.fn.bufnr(0)
  command = M.init_git_command(bufnr, command)
  git_flags_ix = git_flags_ix or 2
  git_diff_flags_ix = git_diff_flags_ix or 3

  local git_diff_flags = config.git_diff_flags()
  local git_flags = config.git_flags()

  if git_flags_ix > git_diff_flags_ix then
    vim.notify("git_flags must be inserted before git_diff_flags", vim.log.levels.ERROR)
  end

  if git_diff_flags ~= nil and #git_diff_flags > 0 then
    for i, flag in ipairs(git_diff_flags) do
      table.insert(command, git_diff_flags_ix + i - 1, flag)
    end
  end

  if git_flags ~= nil and #git_flags > 0 then
    for i, flag in ipairs(git_flags) do
      table.insert(command, git_flags_ix + i - 1, flag)
    end
  end

  return command
end

M.git_diff_command = git_diff_command

M.previous_commit_hash = function(commit_hash, source_bufnr)
  local command = { "git", "rev-parse" }
  local repo = utils.get_repo(source_bufnr) or {}
  if repo.gitdir then
    table.insert(command, "--git-dir=" .. repo.gitdir)
    table.insert(command, "--work-tree=" .. repo.worktree)
  end
  table.insert(command, commit_hash)
  table.insert(command, "~")
  local output = command_util.execute(vim.fn.join(command, " "))
  return string.gsub(output, "\n", "")
end

M.branch_hash = function(branch)
  local command = "git rev-parse " .. branch

  local output = command_util.execute(command)
  return string.gsub(output, "\n", "")
end

-- local is_file_renamed = function(git_relative_file_path)
--     local command = "cd "
--         .. file.git_dir()
--         .. " && git log --all --follow --diff-filter=R --pretty=format:'%H' -- "
--         .. git_relative_file_path
--
--     local output = command_util.execute(command)
--     output = utils.split_string(output, "\n")
--     return #output > 0
-- end

local file_exists_on_commit = function(commit_hash, git_relative_file_path, source_bufnr)
  local gs_repo = utils.get_repo(source_bufnr) or {}
  -- local repo = file_util.git_dir() or (gs_repo and gs_repo.gitdir) or ''
  local repo = file_util.git_dir()
  local command = "cd "
    .. repo
    .. " && git ls-tree --name-only "
    .. commit_hash
    .. " -- "
    .. (git_relative_file_path or "")

  local output = command_util.execute(command)

  output = string.gsub(output, "\n", "")
  return output ~= ""
end

M.file_exists_on_commit = file_exists_on_commit

--- Returns the file name of a file on a specific commit
local file_name_on_commit = function(commit_hash, git_relative_file_path, source_bufnr)
  if file_exists_on_commit(commit_hash, git_relative_file_path, source_bufnr) then
    return git_relative_file_path
  end
  -- first find index in all_commit_hashes
  local all_hashes = all_commit_hashes()
  if all_hashes == nil then
    return nil
  end

  local index = 0
  for i, hash in ipairs(all_hashes) do
    -- compare on first 7 chars
    if string.sub(hash, 1, 7) == string.sub(commit_hash, 1, 7) then
      index = i
      break
    end
  end

  -- then find the first commit that has a different file name
  local touched_hashes = all_commit_hashes_touching_file(git_relative_file_path, source_bufnr)
  if touched_hashes == nil then
    return nil
  end

  local last_touched_hash = nil
  for i = index, #all_hashes do
    local hash = all_hashes[i]
    -- search the hash in touched_hashes
    for _, touched_hash in ipairs(touched_hashes) do
      if string.sub(touched_hash, 1, 7) == string.sub(hash, 1, 7) then
        last_touched_hash = touched_hash
        break
      end
    end

    -- print("searching next")
    if last_touched_hash ~= nil then
      break
    end
  end

  if last_touched_hash == nil then
    return nil
  end

  local command = { "cd", "file.git_dir()", "&&", "git" }
  -- local repo = utils.get_repo(source_bufnr)
  -- if repo.gitdir then
  --   table.insert(command, '--git-dir=' .. repo.gitdir)
  --   table.insert(command, '--work-tree=' .. repo.worktree)
  -- end
  --
  table.insert(command, "--no-pager log -M --follow --pretty=format:'%H' --name-only")
  table.insert(command, last_touched_hash)
  table.insert(command, "~.. -- ")
  table.insert(command, git_relative_file_path)
  table.insert(command, " | tail -1")

  local output = command_util.execute(vim.fn.join(command, " "))
  output = string.gsub(output, "\n", "")

  if file_exists_on_commit(commit_hash, output, source_bufnr) then
    return output
  else
    return nil
  end
end

M.file_name_on_commit = file_name_on_commit

--- returns the base branch of a branch (where fork_point is)
M.base_branch = function()
  local command = [[git show-branch |\
      sed "s/].*//" |\
      grep "*" |\
      grep -v "$(git rev-parse --abbrev-ref HEAD)" |\
      head -n1 |\
      sed "s/^.*\\[//"]]

  local output = command_util.execute(command)

  return string.gsub(output, "\n", "")
end

M.current_branch = function()
  local command = "git branch --show-current"

  local output = command_util.execute(command)

  return string.gsub(output, "\n", "")
end

M.init_command = function(command, bufnr, args)
  args = type(args) ~= "table" and { args } or args
  local repo = utils.get_repo(bufnr)
  if repo and repo.gitdir then
    table.insert(command, "--git-dir=" .. repo.gitdir)
    table.insert(command, "--work-tree=" .. repo.worktree)
  end
  for _, arg in ipairs(args) do
    table.insert(command, arg)
  end
  local gitdir = repo and type(repo.gitdir) == "string" and (repo.gitdir .. "\n") or ""
  logger.trace(gitdir .. vim.fn.join(command, " "))
  return command
end

M.init_git_command = function(bufnr, args)
  args = args or {}
  return M.init_command({ "git" }, bufnr, args)
end

M.init_script_command = function(bufnr, args)
  args = args or {}
  local script = vim.fn.stdpath("config") .. "/lua/gitops/scripts/commits.sh"
  return M.init_command({ script }, bufnr, args)
end

-- git files count
M.file_count = function(bufnr, cwd)
  local cmd = M.init_git_command(bufnr, { "ls-files" })
  table.insert(cmd, cwd or vim.fn.getcwd() or vim.fn.getenv("HOME"))
  local output = vim.fn.system(cmd)
  local lines = vim.tbl_filter(function(line)
    return #line > 0
  end, vim.split(output, "\n"))
  return #lines
end

M.defaulter = function(f, default_opts)
  default_opts = default_opts or {}
  return {
    new = function(opts)
      if conf.preview == false and not opts.preview then
        return false
      end
      opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
      if type(conf.preview) == "table" then
        for k, v in pairs(conf.preview) do
          opts.preview[k] = vim.nonnil(opts.preview[k], v)
        end
      end
      return f(opts)
    end,
    __call = function()
      local ok, err = pcall(f(default_opts))
      if not ok then
        error(debug.traceback(err))
      end
    end,
  }
end

M.search_cb_jump = function(self, bufnr, query)
  if not query then
    return
  end
  vim.api.nvim_buf_call(bufnr, function()
    pcall(vim.fn.matchdelete, self.state.hl_id, self.state.winid)
    vim.cmd("norm! gg")
    vim.fn.search(query, "W")
    vim.cmd("norm! zz")

    self.state.hl_id = vim.fn.matchadd("TelescopePreviewMatch", query)
  end)
end

M.search_teardown = function(self)
  if self.state and self.state.hl_id then
    pcall(vim.fn.matchdelete, self.state.hl_id, self.state.hl_win)
    self.state.hl_id = nil
  end
end

M.scroll_fn = function(self, direction)
  if not self.state then
    return
  end

  local input = direction > 0 and [[]] or [[]]
  local count = math.abs(direction)

  vim.api.nvim_win_call(self.state.winid, function()
    vim.cmd([[normal! ]] .. count .. input)
  end)
end

M.new_buffer_previewer = function(opts)
  opts = opts or {}

  assert(opts.define_preview, "define_preview is a required function")
  assert(not opts.preview_fn, "preview_fn not allowed")

  local opt_setup = opts.setup
  local opt_teardown = opts.teardown

  local old_bufs = {}
  local bufname_table = {}

  local global_state = require("telescope.state")
  local preview_window_id

  local function get_bufnr(self)
    if not self.state then
      return nil
    end
    return self.state.bufnr
  end

  local function set_bufnr(self, value)
    if self.state then
      self.state.bufnr = value
      table.insert(old_bufs, value)
    end
  end

  local function get_bufnr_by_bufname(self, value)
    if not self.state then
      return nil
    end
    return bufname_table[value]
  end

  local function set_bufname(self, value)
    if self.state then
      self.state.bufname = value
      if value then
        bufname_table[value] = get_bufnr(self)
      end
    end
  end

  function opts.setup(self)
    local state = {}
    if opt_setup then
      vim.tbl_deep_extend("force", state, opt_setup(self))
    end
    return state
  end

  function opts.teardown(self)
    if opt_teardown then
      opt_teardown(self)
    end

    local last_nr
    if opts.keep_last_buf then
      last_nr = global_state.get_global_key("last_preview_bufnr")
      -- Push in another buffer so the last one will not be cleaned up
      if preview_window_id then
        local bufnr = vim.api.nvim_create_buf(false, true)
        tele_utils.win_set_buf_noautocmd(preview_window_id, bufnr)
      end
    end

    set_bufnr(self, nil)
    set_bufname(self, nil)

    for _, bufnr in ipairs(old_bufs) do
      if bufnr ~= last_nr then
        buf_delete(bufnr)
      end
    end
    -- enable resuming picker with existing previewer to avoid lookup of deleted bufs
    bufname_table = {}
  end

  function opts.preview_fn(self, entry, status)
    if get_bufnr(self) == nil then
      set_bufnr(self, vim.api.nvim_win_get_buf(status.preview_win))
      preview_window_id = status.preview_win
    end

    if
      opts.get_buffer_by_name and get_bufnr_by_bufname(self, opts.get_buffer_by_name(self, entry))
    then
      self.state.bufname = opts.get_buffer_by_name(self, entry)
      self.state.bufnr = get_bufnr_by_bufname(self, self.state.bufname)
      tele_utils.win_set_buf_noautocmd(status.preview_win, self.state.bufnr)
    else
      local bufnr = vim.api.nvim_create_buf(false, true)
      set_bufnr(self, bufnr)

      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          tele_utils.win_set_buf_noautocmd(status.preview_win, bufnr)
        end
      end)

      vim.wo[status.preview_win].winhl = "Normal:TelescopePreviewNormal"
      vim.wo[status.preview_win].signcolumn = "no"
      vim.wo[status.preview_win].foldlevel = 100
      vim.wo[status.preview_win].wrap = false
      vim.wo[status.preview_win].scrollbind = false

      self.state.winid = status.preview_win
      self.state.bufname = nil
    end

    if opts.keep_last_buf then
      global_state.set_global_key("last_preview_bufnr", self.state.bufnr)
    end

    opts.define_preview(self, entry, status)

    vim.schedule(function()
      if not self or not self.state or not self.state.bufnr then
        return
      end

      if vim.api.nvim_buf_is_valid(self.state.bufnr) then
        vim.api.nvim_buf_call(self.state.bufnr, function()
          vim.api.nvim_exec_autocmds("User", {
            pattern = "TelescopePreviewerLoaded",
            data = {
              title = entry.preview_title,
              bufname = self.state.bufname,
              filetype = pfiletype.detect(self.state.bufname or ""),
            },
          })
        end)
      end
    end)

    if opts.get_buffer_by_name then
      set_bufname(self, opts.get_buffer_by_name(self, entry))
    end
  end

  if not opts.scroll_fn then
    opts.scroll_fn = M.scroll_fn
  end

  return Previewer:new(opts)
end

return M
