local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugin requires nvim-telescope/telescope.nvim")
end

local main = require("telescope._extensions.fences.main")
local health = require("telescope._extensions.fences.health")
return telescope.register_extension {
  exports = {
    fences = main.find,
    health = health.check,
  }
}
