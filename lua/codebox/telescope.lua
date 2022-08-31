local has_telescope = pcall(require, "telescope")

local telescope = { has_telescope = has_telescope }

local function init_telescope()
  telescope.pickers = require("telescope.pickers")
  telescope.make_entry = require("telescope.make_entry")
  telescope.conf = require("telescope.config").values
  telescope.finders = require("telescope.finders")
  telescope.actions = require("telescope.actions")
  telescope.action_state = require("telescope.actions.state")
  telescope.themes = require("telescope.themes")
end

if has_telescope then
  init_telescope()
end

return telescope
