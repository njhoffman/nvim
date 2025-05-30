local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

local attach_mappings = function(opts)
  return function(prompt_bufnr)
    actions.select_default:replace(function()
      local selection = action_state.get_selected_entry()
      if selection == nil then
        utils.__warn_no_selection("builtin.reloader")
        return
      end

      actions.close(prompt_bufnr)
      require("plenary.reload").reload_module(selection.value)
      utils.notify("builtin.reloader", {
        msg = string.format("[%s] - module reloaded", selection.value),
        level = "INFO",
      })
    end)
    return true
  end
end

return attach_mappings
