-- telescope modules
local pickers = require('telescope.pickers')
local themes = require('telescope.themes')
local telescope_config = require('telescope.config').values

local actions = require('telescope._extensions.find_pickers.actions')
local finders = require('telescope._extensions.find_pickers.finders')
local M = {}

local conf_opts = {
  extensions = true,
  builtins = true,
  exclude = {
    'neoclip_a',
    'neoclip_b',
    'neoclip_c',
    'neoclip_d',
    'neoclip_e',
    'neoclip_f',
    'neoclip_g',
    'neoclip_h',
    'neoclip_i',
    'neoclip_j',
    'neoclip_k',
    'neoclip_l',
    'neoclip_m',
    'neoclip_n',
    'neoclip_o',
    'neoclip_p',
    'neoclip_q',
    'neoclip_r',
    'neoclip_s',
    'neoclip_t',
    'neoclip_u',
    'neoclip_v',
    'neoclip_w',
    'neoclip_x',
    'neoclip_y',
    'neoclip_z',
    'neoclip_1',
    'neoclip_2',
    'neoclip_3',
    'neoclip_4',
    'neoclip_5',
    'neoclip_6',
    'neoclip_7',
    'neoclip_8',
    'neoclip_9',
  },
  include_only = {},
  override = {
    gitops_commits = {
      title = function()
        local stats = require('gitops.core.commits').stats()
        return stats.count
          .. ' commits over '
          .. stats.duration
          .. (stats.bare_repo and ' for bare repo: ' or ' for repo: ')
          .. stats.repo_root
      end,
    },
  },
  additional = {
    ghn_notifications = {
      extension = 'ghn',
      command = 'notifications',
      title = 'GitHub Notifications',
    },
  },
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

M.find_pickers = function(theme_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  -- conf_opts = vim.tbl_deep_extend('force', default_conf_opts, conf_opts or {})

  pickers
    .new(theme_opts, {
      prompt_title = 'Find Pickers',
      results_title = 'Picker',
      cache_picker = {
        disabled = true,
      },
      finder = finders.get_finder(conf_opts),
      attach_mappings = actions.attach_mappings,
      sorter = telescope_config.file_sorter(theme_opts),
    })
    :find()
end

return M
