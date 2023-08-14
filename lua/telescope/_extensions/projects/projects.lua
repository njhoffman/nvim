local iter = require('plenary.iterators')
local path = require('plenary.path')
local scan = require('plenary.scandir')
local history = require('project_nvim.utils.history')
local display = require('project_nvim.display')

local utils = require('telescope._extensions.projects.utils')

-- Reads tmp file, converting paths to projects
local function parse_git_repo_paths(name, repo_paths)
  return iter
    .iter(repo_paths)
    :map(function(repo_path)
      local display_path = string.gsub(repo_path.filename, os.getenv('HOME') or '', '~')
      local parsed = {
        path = repo_path.filename,
        name = vim.fn.fnamemodify(repo_path.filename, ':t'),
        display_path = display_path,
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
        search_pattern = '%.git$',
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
    local display_path = string.gsub(result, os.getenv('HOME') or '', '~')
    local parsed = {
      path = result,
      display_path = display_path,
      group_highlight = 'TelescopeProjectGroupRecent',
      icon = { display.get_icon(meta.method, meta.method_type) },
      method = meta.method,
      method_type = meta.method_type,
      recent = true,
      name = vim.fn.fnamemodify(result, ':t'),
    }
    if meta.last then
      parsed.display_group = utils.time_ago(meta.last)
    else
      parsed.display_group = 'now'
    end
    table.insert(parsed_results, parsed)
  end
  return parsed_results
end

local function get_project_items(config)
  -- Reverse results
  local projects = {}
  local paths = {}
  if config.group_filter == '' or config.group_filter == 'recent' then
    local results, metadata = history.get_recent_projects()
    for i = 1, math.floor(#results / 2) do
      if type(paths[results[i]]) == 'nil' then
        results[i], results[#results - i + 1] = results[#results - i + 1], results[i]
        paths[results[i]] = true
      end
    end
    projects = parse_recent_items(results, metadata)
  end

  for i, workspace in ipairs(config.workspaces) do
    if config.group_filter == '' or config.group_filter == workspace.name then
      local repo_paths = search_for_git_repos(workspace.base_dirs)
      local results = parse_git_repo_paths(workspace.name, repo_paths)
      local group_highlight = 'TelescopeProjectGroup' .. (i % 3)
      for _, result in ipairs(results) do
        if type(paths[result.path]) == 'nil' then
          result.group_highlight = group_highlight
          result.icon = { ' ', group_highlight }
          paths[result.path] = true
          table.insert(projects, result)
        end
      end
    end
  end

  return projects
end

return {
  get_project_items = get_project_items,
}
