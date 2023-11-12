local config = require('project_nvim.config')
local history = require('project_nvim.utils.history')
local root = require('project_nvim.root')
local M = {}

M.setup = config.setup
M.get_recent_projects = history.get_recent_projects
M.get_project_root = root.get_project_root

return M
