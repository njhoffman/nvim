local history = require('project_nvim.utils.history')
local root = require('project_nvim.root')

local setup = function(options)
  require('project_nvim.config').init(options)
  require('project_nvim.utils.path').init()
  require('project_nvim.project').init()
  require('project_nvim.session').init()
end

return {
  setup = setup,
  get_recent_projects = history.get_recent_projects,
  get_project_root = root.get_project_root,
}
