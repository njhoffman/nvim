local history = require('project_nvim.utils.history')
local root = require('project_nvim.root')
local commands = require('project_nvim.commands')

local init = function()
  commands.setup_au()
  commands.setup_user()
  history.read_projects_from_history()

  local options = require('project_nvim.config').get()
end

return {
  init = init,
  get_project_root = root.get_project_root,
  set_pwd = commands.set_pwd,
}
