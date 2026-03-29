--- Project name component.
--- Shows the current project name from project_nvim, cached by cwd.
---@module "bars.components.project"


local M = {}

---@class bars.components.project.state
---@field path string?
---@field name string?
---@field cwd string?
local state = { path = nil, name = nil, cwd = nil }

--- Refreshes the cached project path and name when cwd changes.
local function refresh_project_path()
  ---|fS

  local cwd = vim.fn.getcwd()

  if cwd == state.cwd then
    return
  end

  state.path = nil
  state.name = nil
  state.cwd = cwd

  local ok, project_nvim = pcall(require, "project_nvim")

  if ok and type(project_nvim.get_root) == "function" then
    state.path = project_nvim.get_root()
  end

  if state.path == nil then
    state.path = cwd
  end

  state.path = string.gsub(state.path, os.getenv("HOME") or "", "~")

  if state.path then
    local dir, name = string.match(state.path, "(.*)%/(.*)")
    state.path = dir
    state.name = name
  end

  ---|fE
end

--- Returns the project name for the statusline.
---@param buffer integer
---@param window integer
---@return string
M.value = function(buffer, window)
  ---|fS

  refresh_project_path()

  local name = state.name

  if not name or name == "" then
    return ""
  end

  return " " .. name

  ---|fE
end

return M
