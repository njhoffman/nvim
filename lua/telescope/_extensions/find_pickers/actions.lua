local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local builtin_pickers = require("telescope.builtin")
local extensions_pickers = require("telescope._extensions")

local select_picker = function(bufnr)
  local picker_opts = {
    bufnr = vim.api.nvim_get_current_buf(),
    winnr = vim.api.nvim_get_current_win(),
  }
  local selection = actions_state.get_selected_entry()
  local value = selection.value
  actions.close(bufnr)
  if value.extension == false then
    vim.schedule(function()
      builtin_pickers[value.command](picker_opts)
    end)
  else
    vim.schedule(function()
      extensions_pickers.manager[value.extension][value.command](picker_opts)
    end)
  end
end

local view_blacklist = function()
end

local attach_mappings = function(prompt_bufnr, map)
  map('n', 'b', view_blacklist)
  local on_picker_selected = function()
    select_picker(prompt_bufnr)
  end
  actions.select_default:replace(on_picker_selected)
  return true
end

return {
  attach_mappings = attach_mappings
}
