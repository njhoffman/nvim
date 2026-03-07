local autocmds = require("project_nvim.session.autocmds")
local actions = require("project_nvim.session.actions")

local init = function()
  actions.setup()
  autocmds.setup()
end

return { init = init }
