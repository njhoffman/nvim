-- telescope modules
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local themes = require("telescope.themes")
local telescope_config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local display = require("telescope._extensions.variables.display")
local generate = require("telescope._extensions.variables.generate")
local utils = require("telescope._extensions.variables.utils")
local _previewer = require("telescope._extensions.variables.previewer")

local default_conf_opts = {}

local attach_mappings = function()
  actions.select_default:replace(function()
    local selection = action_state.get_selected_entry()
    if selection == nil then
      utils.__warn_no_selection("variables")
      return
    end
    -- local esc = ""
    -- if vim.fn.mode() == "i" then
    --   esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
    -- end

    -- vim.api.nvim_feedkeys(
    --   string.format("%s:set %s=%s", esc, selection.value.name, selection.value.value),
    --   "m",
    --   true
    -- )
  end)
  return true
end

local M = {}

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

M.all = function(theme_opts, conf_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})

  local parsed_table = generate.get_variables()
  pickers
    .new(theme_opts, {
      prompt_title = "All Variables",
      results_title = "Variables",
      finder = finders.new_table({
        results = parsed_table,
        entry_maker = display.entry_maker,
      }),
      previewer = _previewer.previewer.new(conf_opts),
      sorter = telescope_config.file_sorter(theme_opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

M.buffer = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})

  local parsed_table = generate.get_variables("buffer")
  pickers
    .new(theme_opts, {
      prompt_title = "Buffer Variables",
      results_title = "Variables",
      finder = finders.new_table({
        results = parsed_table,
        entry_maker = display.entry_maker,
      }),
      previewer = _previewer.previewer.new(conf_opts),
      sorter = telescope_config.file_sorter(theme_opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

M.predef = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})

  local parsed_table = generate.get_variables("predef")
  pickers
    .new(theme_opts, {
      prompt_title = "Predef Variables",
      results_title = "Variables",
      finder = finders.new_table({
        results = parsed_table,
        entry_maker = display.entry_maker,
      }),
      previewer = _previewer.previewer.new(conf_opts),
      sorter = telescope_config.file_sorter(theme_opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

M.window = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})

  local parsed_table = generate.get_variables("window")
  pickers
    .new(theme_opts, {
      prompt_title = "Window Variables",
      results_title = "Variables",
      finder = finders.new_table({
        results = parsed_table,
        entry_maker = display.entry_maker,
      }),
      previewer = _previewer.previewer.new(conf_opts),
      sorter = telescope_config.file_sorter(theme_opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

M.global = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})

  local parsed_table = generate.get_variables("global")
  pickers
    .new(theme_opts, {
      prompt_title = "Global Variables",
      results_title = "Variables",
      finder = finders.new_table({
        results = parsed_table,
        entry_maker = display.entry_maker,
      }),
      previewer = _previewer.previewer.new(conf_opts),
      sorter = telescope_config.file_sorter(theme_opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

return M
