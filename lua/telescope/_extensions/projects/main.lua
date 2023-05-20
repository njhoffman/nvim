local themes = require('telescope.themes')
local pickers = require('telescope.pickers')
local telescope_config = require('telescope.config').values

local finder = require('telescope._extensions.projects.finder')
local actions = require('telescope._extensions.projects.actions')
local projects = require('telescope._extensions.projects.projects')

local config = { workspaces = {}, theme = 'dropdown' }

local theme_opts = {}
local function setup(setup_config)
  config = vim.tbl_deep_extend('force', config, setup_config)
  if config.theme and config.theme ~= '' then
    theme_opts = themes['get_' .. config.theme]()
  end
  -- _git.update_git_repos(base_dirs)
end

local function get_projects(group)
  ---@param opts table
  return function(opts)
    opts = vim.tbl_deep_extend('force', theme_opts, opts or {})
    config.group_filter = group or ''
    local prompt_title = 'Projects'
    if config.group_filter ~= 'recent' then
      prompt_title = 'Recent Projects'
    elseif config.group_filter ~= '' then
      prompt_title = 'Projects: ' .. config.group_filter
    end
    local project_items = projects.get_project_items(config)
    pickers
      .new(opts, {
        prompt_title = prompt_title,
        finder = finder.create(project_items),
        previewer = false,
        sorter = telescope_config.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
          map('i', '<M-U>', actions.find_project_files)
          map('i', '<M-B>', actions.browse_project_files)
          map('i', '<M-d>', actions.delete_project)
          map('i', '<M-E>', actions.search_in_project_files)
          map('i', '<c-r>', actions.recent_project_files)
          map('i', '<c-w>', actions.change_working_directory)

          actions.replace_default(prompt_bufnr)
          return true
        end,
      })
      :find()
  end
end

return {
  all = get_projects(),
  recent = get_projects('recent'),
  nvim = get_projects('nvim'),
  setup = setup,
}
