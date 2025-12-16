local glob = require("project_nvim.utils.globtopattern")
local uv = vim.loop

local M = {}

function M.lsp_workspace_root(client, fname)
  local root_dir = false
  local workspace_folders = client.workspace_folders or client.workspaceFolders
  local is_windows = vim.loop.os_uname().version:match("Windows")
  fname = vim.fn.fnamemodify(vim.fn.resolve(fname), ":p")
  local sep = is_windows and "\\" or "/"
  local fname_parts = vim.split(fname, sep, { trimempty = true })
  if workspace_folders then
    for _, schema in pairs(workspace_folders) do
      local matched = true
      local root = vim.loop.fs_realpath(schema.name)
      local root_parts = vim.split(root, sep, { trimempty = true })

      for i = 1, #root_parts do
        if root_parts[i] ~= fname_parts[i] then
          matched = false
          break
        end
      end

      if matched then
        root_dir = schema.name
        break
      end
    end
  end
  return root_dir
end

function M.find_lsp_root()
  -- Get lsp client for current buffer
  -- Returns nil or string
  local options = require("project_nvim.config").get()

  local original_bufnr = vim.api.nvim_get_current_buf()
  local buf_ft = vim.api.nvim_buf_get_option(original_bufnr, "filetype")
  local clients = vim.lsp.get_clients({ bufnr = original_bufnr })
  -- local clients = vim.lsp.get_active_clients()
  local fname = vim.api.nvim_buf_get_name(original_bufnr)
  -- local fname = vim.api.nvim_buf_get_name(0)
  local root_dir = nil

  if next(clients) == nil then
    return nil
  end

  for _, client in pairs(clients) do
    if not vim.tbl_contains(options.ignore_lsp, client.name) then
      local filetypes = client.filetypes
      local workspace_folders = client.workspace_folders
      fname = uv.fs_realpath(fname) or vim.fn.fnamemodify(vim.fn.resolve(fname), ":p")
      if workspace_folders then
        for _, schema in ipairs(workspace_folders) do
          local ws_dir = uv.fs_realpath(schema.name)
          if ws_dir and fname:sub(1, ws_dir:len()) == ws_dir then
            root_dir = schema.name
            return root_dir, client.name
          end
        end
      end
      if filetypes and vim.tbl_contains(filetypes, buf_ft) then
        if not vim.tbl_contains(options.ignore_lsp, client.name) then
          root_dir = M.lsp_workspace_root(client, fname) or client.root_dir
          return root_dir, client.name
        end
      end
    end
  end
  return nil
end

function M.find_pattern_root()
  local options = require("project_nvim.config").get()
  local start_dir = vim.fn.expand("%:p:h", true)

  -- Cache for directory listings (persists across all searches)
  local dir_cache = {}
  -- Cache for compiled glob patterns
  local glob_cache = {}

  local function get_parent(path)
    local parent = path:match("^(.*)/")
    return (parent == "" or not parent) and "/" or parent
  end

  local function get_dir_name(path)
    return path:match("([^/]+)$")
  end

  local function get_files(dir)
    local cached = dir_cache[dir]
    if cached then
      return cached
    end

    local files = {}
    local handle = uv.fs_scandir(dir)
    if handle then
      local name = uv.fs_scandir_next(handle)
      while name do
        files[#files + 1] = name
        name = uv.fs_scandir_next(handle)
      end
    end
    dir_cache[dir] = files
    return files
  end

  local function get_glob_pattern(identifier)
    local cached = glob_cache[identifier]
    if cached then
      return cached
    end
    local pattern = glob.globtopattern(identifier)
    glob_cache[identifier] = pattern
    return pattern
  end

  -- Match functions for different pattern types
  local function is_dir_name(dir, identifier)
    return get_dir_name(dir) == identifier
  end

  local function is_subdir_of(dir, identifier)
    local path = get_parent(dir)
    while path and path ~= "/" do
      if get_dir_name(path) == identifier then
        return true
      end
      local parent = get_parent(path)
      if parent == path then
        break
      end
      path = parent
    end
    return get_dir_name("/") == identifier
  end

  local function is_child_of(dir, identifier)
    return get_dir_name(get_parent(dir)) == identifier
  end

  local function has_file(dir, identifier)
    local files = get_files(dir)
    local pattern = get_glob_pattern(identifier)
    for i = 1, #files do
      if files[i]:match(pattern) then
        return true
      end
    end
    return false
  end

  local function match_pattern(dir, pattern)
    local first_char = pattern:sub(1, 1)
    if first_char == "=" then
      return is_dir_name(dir, pattern:sub(2))
    elseif first_char == "^" then
      return is_subdir_of(dir, pattern:sub(2))
    elseif first_char == ">" then
      return is_child_of(dir, pattern:sub(2))
    else
      return has_file(dir, pattern)
    end
  end

  -- Search all parent directories for any pattern in the given list
  -- Patterns in a group are checked together at each directory level
  local function search_parents_for_group(patterns)
    local dir = start_dir

    while dir do
      for i = 1, #patterns do
        local pattern = patterns[i]

        -- Skip nil or non-string patterns
        if type(pattern) ~= "string" then
          goto continue
        end

        local exclude = false
        if pattern:sub(1, 1) == "!" then
          exclude = true
          pattern = pattern:sub(2)
        end

        if match_pattern(dir, pattern) then
          if exclude then
            -- Exclusion matched: skip this directory, continue to parent
            break
          else
            return dir, patterns[i]
          end
        end

        ::continue::
      end

      local parent = get_parent(dir)
      if parent == dir then
        break
      end
      dir = parent
    end

    return nil, nil
  end

  -- Process patterns/groups in order
  -- Groups (tables) search all parents for any pattern in the group before moving on
  -- Single patterns (strings) are treated as a group of one
  for _, entry in ipairs(options.patterns) do
    local patterns = type(entry) == "table" and entry or { entry }
    local result_dir, matched_pattern = search_parents_for_group(patterns)
    if result_dir then
      return result_dir, "pattern " .. matched_pattern
    end
  end

  return nil
end

function M.find_dotbare_root()
  -- toplevel = vim.env.HOME,
  -- gitdir = vim.env.HOME .. "/.cfg",
  local search_dir = vim.fn.expand("%:p:h", true)
  local dotbare_dir = "/home/nicholas/.cfg"
  local check_bare_command =
    { "git", "--git-dir='" .. dotbare_dir .. "'", "rev-parse", "--is-bare-repository" }
  -- git --git-dir=/home/nicholas/.cfg --work-tree=/home/nicholas ls-files ~/.config/picom/picom.conf
  -- git --git-dir=/home/nicholas/.cfg --work-tree=/home/nicholas ls-files .config/picom/picom.conf
  -- git ls-tree --full-tree --name-only -r HEAD
  -- git --git-dir=/home/nicholas/.cfg --work-tree=/home/nicholas ls-tree -r master --name-only
  local is_bare = string.gsub(vim.fn.system(vim.fn.join(check_bare_command, " ")), "\n", "")
end

function M.get_project_root()
  -- returns project root, as well as method

  local options = require("project_nvim.config").get()
  if type(options) ~= "table" or type(options.detection_methods) ~= "table" then
    return vim.notify("Bad config file ..." .. vim.inspect(options), 4)
  end
  for _, detection_method in ipairs(options.detection_methods) do
    if detection_method == "lsp" then
      local root, lsp_name = M.find_lsp_root()
      if root ~= nil then
        return root, 'lsp "' .. lsp_name .. '"'
      end
    elseif detection_method == "pattern" then
      local time_start = vim.loop.hrtime()
      local root, method = M.find_pattern_root()
      local time_end = vim.loop.hrtime()
      local time_ms = (time_end - time_start) / 1000000
      vim.dbglog("pattern time: " .. time_ms .. " ms", root, method)
      if root ~= nil then
        return root, method
      end
    end
  end
end

return M
