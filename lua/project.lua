-- local options = require('utils.options')
local cmd = vim.api.nvim_create_user_command

local M = {}

local get_root = function()
  local path, method = require("project_nvim.project").get_project_root()
  vim.notify({ path }, "info", { title = method })
end

cmd("ProjectGetRoot", get_root, {
  nargs = 0,
  desc = "Get project root path and method"
})

local get_recent = function()
  local history = require("project_nvim.utils.history")
  vim.notify(history.get_recent_projects(), "inspect")
end

cmd("ProjectGetRecent", get_recent, {
  nargs = 0,
  desc = "Get recent projects list"
})

local prjutils = vim.import('utils.project')
prjutils.chdir_func = M.project_chdir

require("project_nvim").setup(prjutils.project_config)
