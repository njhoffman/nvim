local history = require("project_nvim.utils.history")

local iter = require("plenary.iterators")
local path = require("plenary.path")
local scan = require("plenary.scandir")

local function time_ago(time)
  local function round(num)
    return math.floor(num + 0.5)
  end

  local now = os.time()
  local diff_seconds = os.difftime(now, time)

  if diff_seconds < 90 then
    return round(diff_seconds) .. " secs"
  end
  local diff_minutes = diff_seconds / 60
  if diff_minutes < 59.5 then
    return round(diff_minutes) .. " mins"
  end

  local diff_hours = diff_minutes / 60
  if diff_hours < 23.5 then
    return round(diff_hours) .. " hours"
  end

  local diff_days = diff_hours / 24
  if diff_days < 7.5 then
    return round(diff_days) .. " days"
  end

  local diff_weeks = diff_days / 7
  if diff_weeks < 4.5 then
    return round(diff_weeks) .. " weeks"
  end

  local diff_months = diff_days / 30
  if diff_months < 11.5 then
    return round(diff_months) .. " months"
  end

  local diff_years = diff_days / 365.25
  return round(diff_years) .. " years"
end

-- Reads tmp file, converting paths to projects
local function parse_git_repo_paths(name, repo_paths)
  return iter
    .iter(repo_paths)
    :map(function(repo_path)
      local parsed = {
        path = repo_path.filename,
        name = vim.fn.fnamemodify(repo_path.filename, ":t"),
        display_path = string.gsub(repo_path.filename, os.getenv("HOME") or "", "~"),
        display_group = name,
      }
      return parsed
    end)
    :tolist()
end

-- Recurses directories under base directories to find all git projects local function search_for_git_repos(base_dirs)
local function search_for_git_repos(base_dirs)
  return iter
    .iter(base_dirs)
    :map(function(base_dir)
      local git_dirs = scan.scan_dir(vim.fn.expand(base_dir.path), {
        depth = base_dir.max_depth,
        add_dirs = true,
        hidden = true,
        search_pattern = "%.git$",
      })
      return iter.iter(git_dirs):map(function(git_dir)
        return path:new(git_dir):parent()
      end)
    end)
    :flatten()
    :tolist()
end

local function parse_recent_items(results, metadata)
  local parsed_results = {}
  for _, result in ipairs(results) do
    local meta = metadata[result] or {}
    local parsed = {
      path = result,
      display_path = string.gsub(result, os.getenv("HOME") or "", "~"),
      group_highlight = "TelescopeProjectGroupRecent",
      recent = true,
      name = vim.fn.fnamemodify(result, ":t"),
    }
    if meta.last then
      parsed.display_group = time_ago(meta.last)
    else
      parsed.display_group = "now"
    end
    table.insert(parsed_results, parsed)
  end
  return parsed_results
end

local function get_project_items(config)
  -- Reverse results
  local parsed_results = {}
  local paths = {}
  if config.group_filter == "" or config.group_filter == "recent" then
    local results, metadata = history.get_recent_projects()
    for i = 1, math.floor(#results / 2) do
      if type(paths[results[i]]) == "nil" then
        results[i], results[#results - i + 1] = results[#results - i + 1], results[i]
        paths[results[i]] = true
      end
    end
    parsed_results = parse_recent_items(results, metadata)
  end

  for i, workspace in ipairs(config.workspaces) do
    if config.group_filter == "" or config.group_filter == workspace.name then
      local repo_paths = search_for_git_repos(workspace.base_dirs)
      local workspace_results = parse_git_repo_paths(workspace.name, repo_paths)
      local group_highlight = "TelescopeProjectGroup" .. (i % 3)
      for _, workspace_result in ipairs(workspace_results) do
        vim.dbglog(workspace_result)
        workspace_result.group_highlight = group_highlight
        -- paths[workplace_result.path] = true
        table.insert(parsed_results, workspace_result)
      end
    end
  end

  local display_items =
    { { width = 0 }, { width = 0, right_justify = true }, {
      width = 0,
      remaining = true,
    } }
  for _, result in ipairs(parsed_results) do
    local function update_width(idx, len)
      display_items[idx].width = len > display_items[idx].width and len or display_items[idx].width
    end
    update_width(1, #result.name)
    update_width(2, #result.display_group)
    update_width(3, #result.display_path)
  end
  return display_items, parsed_results
end

return {
  get_project_items = get_project_items,
}
