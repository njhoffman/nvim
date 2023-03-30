local setup = require("project_nvim.setup")
local history = require("project_nvim.utils.history")
local root = require("project_nvim.root")

return {
  setup = setup,
  get_root = root.get_project_root,
  get_projects = history.get_recent_projects,
}
