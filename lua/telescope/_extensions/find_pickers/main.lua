-- telescope modules
local pickers = require("telescope.pickers")
local themes = require("telescope.themes")
local telescope_config = require("telescope.config").values

local actions = require("telescope._extensions.find_pickers.actions")
local finders = require("telescope._extensions.find_pickers.finders")
local M = {}

local default_conf_opts = {
  extensions = true,
  builtins = true,
  pickers = {
    planets = {
      hidden = true
    },
    -- custom_picker_name = {
    --   cache_autocmd = "BufEnter", cache_timer  = 5000
    -- }
  },
  new_pickers = {
    ghn_notifications = {
      extension = "ghn",
      command = "notifications"
    }
  }
}

M.setup = function(setup_config)
  -- if setup_config.base_dir then
  --   error("'base_dir' is no longer a valid value for setup. See 'base_dirs'")
  -- end

  -- if setup_config.theme and setup_config.theme ~= "" then
  --   theme_opts = themes["get_" .. setup_config.theme]()
  -- end

  -- base_dirs = setup_config.base_dirs or nil
  -- hidden_files = setup_config.hidden_files or false
  -- _git.update_git_repos(base_dirs)
end

M.find_pickers = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})

  pickers.new(theme_opts, {
    prompt_title    = "Find Pickers",
    results_title   = "Picker",
    finder          = finders.get_finder(conf_opts),
    attach_mappings = actions.attach_mappings,
    sorter          = telescope_config.file_sorter(theme_opts),
  }):find()
end

return M
