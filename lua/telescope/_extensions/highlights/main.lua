local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local telescope_config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local display = require("telescope._extensions.highlights.display")
local generate = require("telescope._extensions.highlights.generate")

local M = {}

M.setup = function() end

local function open_in_editor(selections)
  local groups = {}
  for _, sel in ipairs(selections) do
    table.insert(groups, {
      name = sel.value.name,
      source = sel.value.source,
    })
  end

  if #groups > 0 then
    require("commands.colors.edit_buffer").open(groups)
  end
end

local function attach_mappings(prompt_bufnr, map)
  actions.select_default:replace(function()
    local picker = action_state.get_current_picker(prompt_bufnr)
    local selections = picker:get_multi_selection()

    if #selections == 0 then
      local entry = action_state.get_selected_entry()
      if entry then
        selections = { entry }
      end
    end

    actions.close(prompt_bufnr)
    open_in_editor(selections)
  end)

  return true
end

--- List all highlight groups.
function M.all(theme_opts)
  theme_opts = theme_opts or {}
  local results = generate.get_highlights()

  pickers
    .new(theme_opts, {
      prompt_title = "Highlight Groups",
      results_title = "Highlights",
      finder = finders.new_table({
        results = results,
        entry_maker = display.entry_maker,
      }),
      sorter = telescope_config.generic_sorter(theme_opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

--- List only highlights from colorscheme source files.
function M.colorscheme(theme_opts)
  theme_opts = theme_opts or {}
  local results = generate.get_colorscheme_highlights()

  pickers
    .new(theme_opts, {
      prompt_title = "Colorscheme Highlights",
      results_title = "Highlights",
      finder = finders.new_table({
        results = results,
        entry_maker = display.entry_maker,
      }),
      sorter = telescope_config.generic_sorter(theme_opts),
      attach_mappings = attach_mappings,
    })
    :find()
end

return M
