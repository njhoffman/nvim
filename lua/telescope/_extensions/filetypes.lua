local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local sorters = require "telescope.sorters"
local pickers = require "telescope.pickers"
local previewers = require "telescope.previewers"

local attach_mappings = function(prompt_bufnr)
  actions.select_default:replace(function()
    local selection = action_state.get_selected_entry()
    if selection == nil then
      vim.notify("[telescope] Nothing currently selected", vim.log.levels.WARN)
      return
    end

    actions.close(prompt_bufnr)
    vim.cmd("setfiletype " .. selection[1])
  end)
  return true
end

local show_filetypes = function(opts)
  local filetypes = vim.fn.getcompletion("", "filetype")
  pickers
    .new(opts, {
      prompt_title = "Filetypes",
      finder = finders.new_table { results = filetypes },
      sorter = sorters.get_fzy_sorter(),
      attach_mappings = attach_mappings
    })
    :find()
end

local function run()
  show_filetypes()
end

return require("telescope").register_extension({
  exports = {
    filetypes = run,
  },
})
