-- telescope modules
local actions = require("telescope.actions")
local previewers = require("telescope.previewers")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local themes = require("telescope.themes")
local telescope_config = require("telescope.config").values

local hintsbox = require("telescope._extensions.devhints.hintsbox")
local display = require("telescope._extensions.devhints.display")
local generate = require("telescope._extensions.devhints.generate")
local default_conf_opts = {}

local M = {}

M.setup = function(setup_config) end

local select_devhints_topic = function(prompt_bufnr)
  -- local selection = action_state.get_selected_entry()
  local picker = action_state.get_current_picker(prompt_bufnr)
  local multi_targets = picker:get_multi_selection()
  hintsbox.init(multi_targets)
end

M.topic = function(category)
  return function(theme_opts, conf_opts)
    conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})
    theme_opts = themes.get_dropdown(theme_opts)

    local topics, widths = generate.get_topics(category .. ".md")

    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })

    pickers
      .new(theme_opts, {
        prompt_title = "Devhints",
        results_title = "Topics",
        finder = finders.new_table({
          results = topics,
          entry_maker = display.topics_entry_maker(widths),
        }),
        sorter = telescope_config.file_sorter(theme_opts),
        previewer = previewers.new_buffer_previewer({
          define_preview = display.preview_topic(filetype),
        }),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(select_devhints_topic)
          return true
        end,
      })
      :find()
  end
end

M.all = function(theme_opts, conf_opts)
  conf_opts = vim.tbl_deep_extend("force", default_conf_opts, conf_opts or {})
  local categories = generate.get_categories()

  local select_devhints_category = function()
    local selection = action_state.get_selected_entry()
    vim.dbglog({ "selected:", selection.value })
  end

  pickers
    .new(theme_opts, {
      prompt_title = "Devhints",
      results_title = "Categories",
      finder = finders.new_table({
        results = categories,
        entry_maker = display.categories_entry_maker,
      }),
      sorter = telescope_config.file_sorter(theme_opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(select_devhints_category)
        return true
      end,
    })
    :find()
end

return M
