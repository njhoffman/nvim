local themes = require("telescope.themes")
local pickers = require("telescope.pickers")
local telescope_config = require("telescope.config").values

local finder = require("telescope._extensions.projects.finder")
local actions = require("telescope._extensions.projects.actions")
local utils = require("telescope._extensions.projects.utils")

local config = { workspaces = {}, theme = "" }

local theme_opts = {}
local function setup(setup_config)
  if setup_config.theme and setup_config.theme ~= "" then
    theme_opts = themes["get_" .. setup_config.theme]()
  end
  config = vim.tbl_deep_extend("force", config, setup_config)

  vim.api.nvim_set_hl(0, "TelescopeProjectPath", { default = true, link = "Comment" })
  vim.api.nvim_set_hl(0, "TelescopeProjectName", { default = true, link = "@keyword" })
  vim.api.nvim_set_hl(0, "TelescopeProjectGroupRecent", { default = true, fg = "#990000", italic = true })
  vim.api.nvim_set_hl(0, "TelescopeProjectGroup1", { default = true, fg = "#00aaaa" })
  vim.api.nvim_set_hl(0, "TelescopeProjectGroup2", { default = true, fg = "#0066aa" })
  vim.api.nvim_set_hl(0, "TelescopeProjectGroup3", { default = true, fg = "#7755aa" })
  -- _git.update_git_repos(base_dirs)
end

local function get_projects(group)
  ---@param opts table
  return function(opts)
    opts = vim.tbl_deep_extend("force", theme_opts, opts or {})
    config.group_filter = group or ""
    local prompt_title = "Projects"
    if config.group_filter ~= "recent" then
      prompt_title = "Recent Projects"
    elseif config.group_filter ~= "" then
      prompt_title = "Projects: " .. config.group_filter
    end

    local display_items, parsed_results = utils.get_project_items(config)
    pickers
      .new(opts, {
        prompt_title = prompt_title,
        finder = finder.create(display_items, parsed_results),
        previewer = false,
        sorter = telescope_config.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          map("i", "<M-f>", actions.find_project_files)
          map("i", "<M-b>", actions.browse_project_files)
          map("i", "<M-d>", actions.delete_project)
          map("i", "<c-s>", actions.search_in_project_files)
          map("i", "<c-r>", actions.recent_project_files)
          map("i", "<c-w>", actions.change_working_directory)

          actions.replace_default(prompt_bufnr)
          return true
        end,
      })
      :find()
  end
end

return {
  all = get_projects(),
  recent = get_projects("recent"),
  nvim = get_projects("nvim"),
  setup = setup,
}
