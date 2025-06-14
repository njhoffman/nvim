local setup_environment = function(bufnr)
  local gs = package.loaded.gitsigns

  -- git rev-parse --is-bare-repository
  local ok, gs_status = pcall(vim.api.nvim_buf_get_var, bufnr, "gitsigns_status_dict")
  if ok == true then
    gs_status.gitdir = gs_status.gitdir or vim.fn.getcwd()
    local check_bare_command =
      { "git", "--git-dir='" .. gs_status.gitdir .. "'", "rev-parse", "--is-bare-repository" }
    local is_bare = string.gsub(vim.fn.system(vim.fn.join(check_bare_command, " ")), "\n", "")
    gs_status.is_bare = is_bare == "true" and true or false
    -- vim.dbglog("bare", vim.fn.join(check_bare_command, " "), is_bare)
  else
    vim.dbglog("no gitsigns_status")
  end

  local missing = string
    .format(
      "%s %s",
      (vim.fn.isdirectory(gs_status.gitdir) == 0 and "gitdir: " .. gs_status.gitdir or ""),
      (vim.fn.isdirectory(gs_status.root) == 0 and "root: " .. gs_status.root or "")
    )
    :gsub("^%s+", "")

  local has_git = vim.fn.empty(gs_status.root) == 0 and missing == ""

  local error_msg = nil

  if #missing > 0 then
    error_msg = string.format(
      string.format("gitsigns: directory does not exist `%s`", missing),
      vim.log.levels.WARN
    )
  elseif gs_status.is_bare and not has_git then
    error_msg = string.format(
      "gitsigns: bare repo missing: `%s` for directory `%s`",
      vim.fn.empty(gs_status.root) == 1 and "root" or "",
      gs_status.gitdir
    )
  end

  if error_msg then
    vim.notify(error_msg, vim.log.levels.WARN)
    vim.api.nvim_buf_set_var(bufnr, "gitsigns_status_dict", nil)
    return false
  end

  -- -- For debugging purposes, we can log the environment variables
  vim.api.nvim_buf_set_var(bufnr, "gitsigns_status_dict", gs_status)
  -- vim.dbglog(
  --   "gitsigns_status_dict",
  --   gs_status,
  --   bufnr,
  --   vim.fn.getenv("GIT_WORK_TREE"),
  --   vim.fn.getenv("GIT_DIR")
  -- )

  -- if vim.fn.getenv("GIT_WORK_TREE") ~= env.root or vim.fn.getenv("GIT_DIR") ~= env.gitdir then
  --   vim.notify(
  --     string.format("gitsigns: GIT_WORK_TREE=%s, GIT_DIR=%s", env.root, env.gitdir),
  --     vim.log.levels.INFO
  --   )
  --   -- vim.fn.setenv("GIT_WORK_TREE", env.root)
  --   -- vim.fn.setenv("GIT_DIR", env.gitdir)
  -- else
  --   vim.notify(
  --     string.format("gitsigns attached to root `%s` with wok tree `%s`", env.root, env.gitdir),
  --     vim.log.levels.DEBUG
  --   )
  -- end
end

return setup_environment
