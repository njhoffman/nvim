local actions_state = require('telescope.actions.state')
local actions = require('telescope.actions')

local select_picker = function(bufnr)
  local picker_opts = {
    bufnr = vim.api.nvim_get_current_buf(),
    winnr = vim.api.nvim_get_current_win(),
  }
  local selection = actions_state.get_selected_entry()
  local value = selection.value
  actions.close(bufnr)
  vim.dbglog('picker', value)
  if value.extension == false then
    require('telescope.run')('builtin', value.command, picker_opts)
    -- require('telescope.builtin')[value.command](picker_opts)
  else
    require('telescope.run')(value.extension, value.command, picker_opts)
    -- require('telescope._extensions').manager[value.extension][value.command](picker_opts)
  end
end

local view_blacklist = function() end

local attach_mappings = function(prompt_bufnr, map)
  map('n', 'b', view_blacklist)
  local on_picker_selected = function()
    select_picker(prompt_bufnr)
  end
  actions.select_default:replace(on_picker_selected)
  return true
end

return {
  attach_mappings = attach_mappings,
}
