local path = require("project_nvim.utils.path")
local state = require("project_nvim.state")

local uv = vim.uv

local function open_history(mode, callback)
  if callback ~= nil then -- async
    path.create_scaffolding(function(_, _)
      uv.fs_open(path.historyfile, mode, 438, callback)
    end)
  else -- sync
    path.create_scaffolding()
    return uv.fs_open(path.historyfile, mode, 438)
  end
end

local function dir_exists(dir)
  local stat = uv.fs_stat(dir)
  if stat ~= nil and stat.type == "directory" then
    return true
  end
  return false
end

local function normalise_path(path_to_normalise)
  local normalised_path = path_to_normalise:gsub("\\", "/"):gsub("//", "/")
  return normalised_path
end

local function delete_duplicates(tbl)
  local cache_dict = {}
  for _, v in ipairs(tbl) do
    local normalised_path = normalise_path(v)
    if cache_dict[normalised_path] == nil then
      cache_dict[normalised_path] = 1
    else
      cache_dict[normalised_path] = cache_dict[normalised_path] + 1
    end
  end

  local res = {}
  for _, v in ipairs(tbl) do
    local v_path = v:match("[^|]+")
    local normalised_path = normalise_path(v_path)
    if cache_dict[normalised_path] == 1 then
      table.insert(res, v)
    else
      cache_dict[normalised_path] = cache_dict[normalised_path] - 1
    end
  end
  return res
end

local function delete_project(project)
  for k, v in ipairs(state.recent_projects) do
    if v == project.value then
      state.recent_projects[k] = nil
    end
  end
end

local parse_args = function(args)
  local args_obj = {}
  if args ~= nil then
    for arg in args:gmatch("[^,]+") do
      local key = vim.split(arg, "=")[1]
      local val = vim.split(arg, "=")[2]
      args_obj[key] = val
    end
  end
  return args_obj
end

local function deserialize_history(history_data)
  -- split data to table
  local projects = {}
  local meta = {}
  for s in history_data:gmatch("[^\r\n]+") do
    local parts = vim.split(s, "|")
    local dir = parts[1]
    local args = parse_args(parts[2])
    if not path.is_excluded(dir) and dir_exists(dir) then
      table.insert(projects, dir)
      meta[dir] = args
    end
  end

  projects = delete_duplicates(projects)

  state.projects_meta = meta
  state.recent_projects = projects
end

local read_projects = function(fd)
  if fd ~= nil then
    uv.fs_fstat(fd, function(_, stat)
      if stat ~= nil then
        uv.fs_read(fd, stat.size, -1, function(_, data)
          uv.fs_close(fd, function(_, _) end)
          deserialize_history(data)
        end)
      end
    end)
  end
end

local function setup_watch()
  if state.has_watch_setup == false then
    state.has_watch_setup = true
    local event = uv.new_fs_event()
    if event == nil then
      return
    end
    event:start(vim.fs.dirname(path.historyfile), {}, function(err, _, events)
      if err ~= nil then
        return
      end
      if events["change"] then
        state.recent_projects = nil
        open_history("r", function(_, fd)
          read_projects(fd)
        end)
      end
    end)
  end
end

local sanitize_table = function()
  local tbl = {}
  if state.recent_projects ~= nil then
    vim.list_extend(tbl, state.recent_projects)
    vim.list_extend(tbl, state.session_projects)
  else
    tbl = state.session_projects
  end

  tbl = delete_duplicates(tbl)

  local real_tbl = {}
  for _, line in ipairs(tbl) do
    local dir = line:match("[^|]+")
    if dir_exists(dir) then
      table.insert(real_tbl, line)
    end
  end

  return real_tbl
end

local apply_metadata = function(projects, skip_number)
  local tbl = {}
  for _, project in ipairs(projects) do
    local meta = state.projects_meta[project] or {}
    local in_session = false
    for _, session in ipairs(state.session_projects) do
      if project == session then
        in_session = true
      end
    end
    if in_session and skip_number ~= true then
      if type(meta.num) == "string" then
        meta.num = tonumber(meta.num) + 1
      else
        meta.num = 1
      end
    end
    if type(meta) == "table" then
      local arg_str = "|"
      for key, val in pairs(meta) do
        arg_str = arg_str .. key .. "=" .. val .. ","
      end
      table.insert(tbl, project .. arg_str)
    else
      table.insert(tbl, project)
    end
  end
  return tbl
end

local add_session_project = function(name, method)
  table.insert(state.session_projects, name)
  if type(method) == "string" then
    local meta = state.projects_meta[name] or {}
    local lsp = string.match(method or "", 'lsp "([^%s]+)"')
    if type(lsp == "string") and lsp ~= "" then
      meta.method = "lsp"
      meta.method_type = meta.method_type or lsp
    else
      meta.method = method
    end
    meta.last = os.time()
    state.projects_meta[name] = meta
  end
  state.session_projects = delete_duplicates(state.session_projects)
end

local function read_projects_from_history()
  open_history("r", function(_, fd)
    setup_watch()
    read_projects(fd)
  end)
end

local function write_projects_to_history(skip_number)
  -- Unlike read projects, write projects is synchronous because it runs when vim ends
  local mode = "w"
  if state.recent_projects == nil then
    mode = "a"
  end
  local file = open_history(mode)

  if file ~= nil then
    local save_projects = sanitize_table()
    local res = apply_metadata(save_projects, skip_number)

    -- Trim table to last 100 entries
    local len_res = #res
    local tbl_out
    if #res > 1000 then
      tbl_out = vim.list_slice(res, len_res - 1000, len_res)
    else
      tbl_out = res
    end

    -- Transform table to string
    local out = ""
    for _, v in ipairs(tbl_out) do
      out = out .. v .. "\n"
    end

    -- Write string out to file and close
    uv.fs_write(file, out, -1)
    uv.fs_close(file)
  end
end

local function get_recent_projects()
  local tbl = sanitize_table()
  return tbl, state.projects_meta
end

return {
  read_projects_from_history = read_projects_from_history,
  write_projects_to_history = write_projects_to_history,
  add_session_project = add_session_project,
  get_recent_projects = get_recent_projects,
  delete_project = delete_project,
}
