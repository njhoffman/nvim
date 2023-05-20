-- telescope modules
local pickers = require('telescope.pickers')
local themes = require('telescope.themes')
local telescope_config = require('telescope.config').values

local actions = require('telescope._extensions.find_pickers.actions')
local finders = require('telescope._extensions.find_pickers.finders')
local M = {}

local default_conf_opts = {
  extensions = true,
  builtins = true,
  pickers = {
    planets = {
      hidden = true,
    },
    neoclip_a = { hidden = true },
    neoclip_b = { hidden = true },
    neoclip_c = { hidden = true },
    neoclip_d = { hidden = true },
    neoclip_e = { hidden = true },
    neoclip_f = { hidden = true },
    neoclip_g = { hidden = true },
    neoclip_h = { hidden = true },
    neoclip_i = { hidden = true },
    neoclip_j = { hidden = true },
    neoclip_k = { hidden = true },
    neoclip_l = { hidden = true },
    neoclip_m = { hidden = true },
    neoclip_n = { hidden = true },
    neoclip_o = { hidden = true },
    neoclip_p = { hidden = true },
    neoclip_q = { hidden = true },
    neoclip_r = { hidden = true },
    neoclip_s = { hidden = true },
    neoclip_t = { hidden = true },
    neoclip_u = { hidden = true },
    neoclip_v = { hidden = true },
    neoclip_w = { hidden = true },
    neoclip_x = { hidden = true },
    neoclip_y = { hidden = true },
    neoclip_z = { hidden = true },
    neoclip_1 = { hidden = true },
    neoclip_2 = { hidden = true },
    neoclip_3 = { hidden = true },
    neoclip_4 = { hidden = true },
    neoclip_5 = { hidden = true },
    neoclip_6 = { hidden = true },
    neoclip_7 = { hidden = true },
    neoclip_8 = { hidden = true },
    neoclip_9 = { hidden = true },
    -- custom_picker_name = {
    --   cache_autocmd = "BufEnter", cache_timer  = 5000
    -- }
  },
  new_pickers = {
    ghn_notifications = {
      extension = 'ghn',
      command = 'notifications',
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

M.find_pickers = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend('force', default_conf_opts, conf_opts or {})

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
