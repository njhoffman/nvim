local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"

local conf = require("telescope.config").values


nick.synitems = function(opts)
  local filetypes = vim.fn.getcompletion("", "filetype")

  pickers.new(opts, {
    prompt_title = "Filetypes",
    finder = finders.new_table {
      results = filetypes,
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        if selection == nil then
          print "[telescope] Nothing currently selected"
          return
        end

        actions.close(prompt_bufnr)
        vim.cmd("setfiletype " .. selection[1])
      end)
      return true
    end,
  }):find()
end
