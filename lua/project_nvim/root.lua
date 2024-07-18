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

  local search_dir = vim.fn.expand("%:p:h", true)

  local last_dir_cache = ""
  local curr_dir_cache = {}

  local function get_parent(_path)
    _path = _path:match("^(.*)/")
    if _path == "" then
      _path = "/"
    end
    return _path
  end

  local function get_files(file_dir)
    last_dir_cache = file_dir
    curr_dir_cache = {}

    local dir = uv.fs_scandir(file_dir)
    if dir == nil then
      return
    end

    while true do
      local file = uv.fs_scandir_next(dir)
      if file == nil then
        return
      end

      table.insert(curr_dir_cache, file)
    end
  end

  local function is(dir, identifier)
    dir = dir:match(".*/(.*)")
    return dir == identifier
  end

  local function sub(dir, identifier)
    local _path = get_parent(dir)
    while true do
      if is(_path, identifier) then
        return true
      end
      local current = _path
      _path = get_parent(_path)
      if current == _path then
        return false
      end
    end
  end

  local function child(dir, identifier)
    local _path = get_parent(dir)
    return is(_path, identifier)
  end

  local function has(dir, identifier)
    if last_dir_cache ~= dir then
      get_files(dir)
    end
    local pattern = glob.globtopattern(identifier)
    for _, file in ipairs(curr_dir_cache) do
      if file:match(pattern) ~= nil then
        return true
      end
    end
    return false
  end

  local function match(dir, pattern)
    local first_char = pattern:sub(1, 1)
    if first_char == "=" then
      return is(dir, pattern:sub(2))
    elseif first_char == "^" then
      return sub(dir, pattern:sub(2))
    elseif first_char == ">" then
      return child(dir, pattern:sub(2))
    else
      return has(dir, pattern)
    end
  end

  -- breadth-first search
  while true do
    for _, pattern in ipairs(options.patterns) do
      local exclude = false
      if pattern:sub(1, 1) == "!" then
        exclude = true
        pattern = pattern:sub(2)
      end
      if match(search_dir, pattern) then
        if exclude then
          break
        else
          return search_dir, "pattern " .. pattern
        end
      end
    end

    local parent = get_parent(search_dir)
    if parent == search_dir or parent == nil then
      return nil
    end

    search_dir = parent
  end
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
      local root, method = M.find_pattern_root()
      if root ~= nil then
        return root, method
      end
    end
  end
end

return M
