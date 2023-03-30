local globtopattern = require("project_nvim.utils.globtopattern")
local destruct = require("utils.destruct")
local config = require("project_nvim.config")

local uv = vim.loop

local function lsp_workspace_root(client, fname)
  local root_dir = false
  local workspace_folders = client.workspace_folders or client.workspaceFolders
  fname = vim.fn.fnamemodify(vim.fn.resolve(fname), ":p")
  local fname_parts = vim.split(fname, "/", { trimempty = true })
  vim.dbglog(destruct(client, { "name", "workspace_folders", "attached_buffers" }), client.config.root_dir)

  if workspace_folders then
    for _, schema in pairs(workspace_folders) do
      local matched = true
      local root = vim.loop.fs_realpath(schema.name)
      local root_parts = vim.split(root, "/", { trimempty = true })

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

local function find_lsp_root()
  -- Get lsp client for current buffer
  -- Returns nil or string
  local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
  local clients = vim.lsp.get_active_clients()
  local fname = vim.api.nvim_buf_get_name(0)

  if next(clients) == nil then
    return nil
  end

  for _, client in pairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.tbl_contains(filetypes, buf_ft) then
      vim.dbglog("ignore lsp", config.options)
      if not vim.tbl_contains(config.options.ignore_lsp, client.name) then
        local root_dir = lsp_workspace_root(client, fname) or client.config.root_dir
        return root_dir, client.name
      end
    end
  end

  return nil
end

local function find_pattern_root()
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
    local pattern = globtopattern(identifier)
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
    for _, pattern in ipairs(config.options.patterns) do
      local exclude = false
      if pattern:sub(1, 1) == "!" then
        exclude = true
        pattern = pattern:sub(2)
      end
      if match(search_dir, pattern) then
        if exclude then
          break
        else
          return search_dir, pattern
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

local function get_project_root()
  -- returns project root, as well as method

  vim.dbglog("---", config.options)
  for _, detection_method in ipairs(config.options.detection_methods or {}) do
    if detection_method == "lsp" then
      local root, lsp_name = find_lsp_root()
      local props = { method = "lsp", match = lsp_name }
      if root ~= nil then
        return root, props
      end
    elseif detection_method == "pattern" then
      local root, pattern = find_pattern_root()
      local props = { method = "pattern", match = pattern }
      if root ~= nil then
        return root, props
      end
    end
  end
end

return { get_project_root = get_project_root }
