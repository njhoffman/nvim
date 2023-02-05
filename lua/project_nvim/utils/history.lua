local path = require("project_nvim.utils.path")
local uv = vim.loop
local M = {}
local is_windows = vim.fn.has("win32") or vim.fn.has("wsl")

M.recent_projects = nil -- projects from previous neovim sessions
M.session_projects = {} -- projects from current neovim session
M.projects_meta = {}
M.has_watch_setup = false

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

  if is_windows then
    normalised_path = normalised_path:sub(1, 1):lower() .. normalised_path:sub(2)
  end

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

function M.delete_project(project)
  for k, v in ipairs(M.recent_projects) do
    if v == project.value then
      M.recent_projects[k] = nil
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

  M.projects_meta = meta
  M.recent_projects = projects
end

local function setup_watch()
  -- Only runs once
  if M.has_watch_setup == false then
    M.has_watch_setup = true
    local event = uv.new_fs_event()
    if event == nil then
      return
    end
    event:start(path.projectpath, {}, function(err, _, events)
      if err ~= nil then
        return
      end
      if events["change"] then
        M.recent_projects = nil
        M.read_projects_from_history()
      end
    end)
  end
end

function M.read_projects_from_history()
  open_history("r", function(_, fd)
    setup_watch()
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
  end)
end

local sanitize_table = function()
  local tbl = {}
  if M.recent_projects ~= nil then
    vim.list_extend(tbl, M.recent_projects)
    vim.list_extend(tbl, M.session_projects)
  else
    tbl = M.session_projects
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

function M.get_recent_projects()
  local tbl = sanitize_table()
  return tbl, M.projects_meta
end

local apply_metadata = function(projects)
  local tbl = {}
  for _, project in ipairs(projects) do
    local meta = M.projects_meta[project] or {}
    local in_session = false
    for _, session in ipairs(M.session_projects) do
      if project == session then
        in_session = true
      end
    end
    if in_session then
      if type(meta.num) == "string" then
        meta.num = tonumber(meta.num) + 1
      else
        meta.num = 1
      end
      meta.last = os.time()
      -- os.time(os.date("!*t"))
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

function M.add_session(name)
  table.insert(M.session_projects, name)
  M.session_projects = delete_duplicates(M.session_projects)
end

function M.write_projects_to_history()
  -- Unlike read projects, write projects is synchronous because it runs when vim ends
  local mode = "w"
  if M.recent_projects == nil then
    mode = "a"
  end
  local file = open_history(mode)

  if file ~= nil then
    local save_projects = sanitize_table()
    local res = apply_metadata(save_projects)

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

return M
