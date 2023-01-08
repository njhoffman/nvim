-- telescope modules
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local themes = require("telescope.themes")
local telescope_config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local display = require("telescope._extensions.options.display")
local generate = require("telescope._extensions.options.generate")
local utils = require("telescope._extensions.options.utils")
local _previewer = require("telescope._extensions.options.previewer")

local M = {}
local default_opts = {
  omit_empty = true
}

M.setup = function(setup_config)
end

local attach_mappings = function()
  actions.select_default:replace(function()
    local selection = action_state.get_selected_entry()
    if selection == nil then
      utils.__warn_no_selection "variables"
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

M.all = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_opts, conf_opts or {})

  local parsed_table = generate.get_options('all', conf_opts)
  pickers.new(theme_opts, {
    prompt_title = "All Options",
    results_title = "Options",
    finder = finders.new_table({
      results = parsed_table,
      entry_maker = display.entry_maker
    }),
    previewer = _previewer.previewer.new(conf_opts),
    sorter = telescope_config.file_sorter(theme_opts),
    attach_mappings = attach_mappings
  }):find()
end


M.buffer = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})

  local parsed_table = generate.get_options('buf', conf_opts)
  pickers.new(theme_opts, {
    prompt_title = "Buffer Options",
    results_title = "Options",
    finder = finders.new_table({
      results = parsed_table,
      entry_maker = display.entry_maker
    }),
    previewer = _previewer.previewer.new(conf_opts),
    sorter = telescope_config.file_sorter(theme_opts),
    attach_mappings = attach_mappings
  }):find()
end

M.global = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_opts, conf_opts or {})

  local parsed_table = generate.get_options('global', conf_opts)
  pickers.new(theme_opts, {
    prompt_title = "Global Options",
    results_title = "Options",
    finder = finders.new_table({
      results = parsed_table,
      entry_maker = display.entry_maker
    }),
    previewer = _previewer.previewer.new(conf_opts),
    sorter = telescope_config.file_sorter(theme_opts),
    attach_mappings = attach_mappings
  }):find()
end


M.window = function(theme_opts, conf_opts)
  theme_opts = themes.get_dropdown(theme_opts)
  conf_opts = vim.tbl_deep_extend("force", default_opts, conf_opts or {})

  local parsed_table = generate.get_options('win', conf_opts)
  pickers.new(theme_opts, {
    prompt_title = "Window Options",
    results_title = "Options",
    finder = finders.new_table({
      results = parsed_table,
      entry_maker = display.entry_maker
    }),
    previewer = _previewer.previewer.new(conf_opts),
    sorter = telescope_config.file_sorter(theme_opts),
    attach_mappings = attach_mappings
  }):find()
end
return M
