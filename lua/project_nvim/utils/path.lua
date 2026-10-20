local uv = vim.uv
local M = {}

M.historyfile = nil
M.sessionspath = nil
M.homedir = nil
M.dir_pretty = nil -- directory of current project (respects user defined symlinks in config)

function M.init()
  local options = require("project_nvim.config").get()
  M.historyfile = options.paths.history or vim.fn.stpath("data") .. "/project_history"
  M.sessionspath = options.paths.sessions or vim.fn.stdpath("data") .. "/project_sessions"
  M.homedir = vim.fn.expand("~")
end

M.dir_matches_project = function(dir)
  local dir_resolved = dir or M.resolve(M.cwd())
  -- Check if current working directory mathch project patterns
  local projects = M.get_all_projects()
  for _, path in ipairs(projects) do
    if M.resolve(path) == dir_resolved then
      M.dir_pretty = M.short_path(path) -- store path with user defined symlinks
      return true
    end
  end
  return false
end

M.get_all_projects = function()
  -- Get all existing projects from patterns
  local projects = {}
  local patterns = require("project_nvim.config").get().projects
  for _, pattern in ipairs(patterns) do
    local tbl = vim.fn.glob(pattern, true, true, true)
    for _, path in ipairs(tbl) do
      if vim.fn.isdirectory(path) == 1 then
        table.insert(projects, M.short_path(path))
      end
    end
  end
  return projects
end

M.short_path = function(path)
  -- Reduce file name to be relative to the home directory, if possible.
  path = M.resolve(path)
  return vim.fn.fnamemodify(path, ":~")
end

M.cwd = function()
  -- Get current working directory in short form
  return M.short_path(uv.cwd())
end

M.resolve = function(filename)
  -- Replace symlink with real path
  filename = vim.fn.expand(filename)
  return vim.fn.resolve(filename)
end

M.delete_duplicates = function(tbl)
  -- Remove duplicates from table, preserving order
  local cache_dict = {}
  for _, v in ipairs(tbl) do
    if cache_dict[v] == nil then
      cache_dict[v] = 1
    else
      cache_dict[v] = cache_dict[v] + 1
    end
  end

  local res = {}
  for _, v in ipairs(tbl) do
    if cache_dict[v] == 1 then
      table.insert(res, v)
    else
      cache_dict[v] = cache_dict[v] - 1
    end
  end
  return res
end

M.fix_symlinks_for_history = function(dirs)
  -- Replace paths with paths from `projects` option
  local projects = M.get_all_projects()
  for i, dir in ipairs(dirs) do
    for _, path in ipairs(projects) do
      if M.resolve(path) == M.resolve(dir) then
        dirs[i] = path
        break
      end
    end
  end
  -- remove duplicates
  return M.delete_duplicates(dirs)
end

function M.is_file()
  local buf_type = vim.api.nvim_get_option_value("buftype", { buf = 0 })

  local whitelisted_buf_type = { "", "acwrite" }
  local is_in_whitelist = false
  for _, wtype in ipairs(whitelisted_buf_type) do
    if buf_type == wtype then
      is_in_whitelist = true
      break
    end
  end
  if not is_in_whitelist then
    return false
  end

  return true
end

function M.create_scaffolding(callback)
  vim.defer_fn(function()
    vim.fn.mkdir(M.sessionspath, "p")
    vim.fn.mkdir(vim.fs.dirname(M.historyfile), "p")
    if callback ~= nil then -- async
      uv.fs_mkdir(vim.fs.dirname(M.historyfile), 448, callback)
      -- uv.fs_mkdir(M.projectpath, 448, callback)
      -- else -- sync
      -- uv.fs_mkdir(vim.fs.dirname(M.historyfile), 448, callback)
    end
  end, 0)
end

function M.is_excluded(dir)
  local options = require("project_nvim.config").get()
  for _, dir_pattern in ipairs(options.exclude_dirs or {}) do
    if dir:match(dir_pattern) ~= nil then
      return true
    end
  end

  return false
end

function M.home_path(dir)
  return dir.gsub(dir, os.getenv("HOME") or "", "~")
end

return M
