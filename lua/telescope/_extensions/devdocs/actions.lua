local state = require("telescope.state")
local operations = require("devdocs2.operations")
local plugin_state = require("devdocs2.state")
local plugin_config = require("devdocs2.config")

local open_doc = function(selection, float)
  local bufnr = state.get_global_key("last_preview_bufnr")
  local picker_cmd = plugin_config.options.picker_cmd

  if picker_cmd or not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    if float then
      bufnr = vim.api.nvim_create_buf(false, true)
    else
      bufnr = vim.api.nvim_create_buf(true, false)
    end
    local lines = plugin_state.get("preview_lines") or operations.read_entry(selection.value)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  end

  plugin_state.set("last_mode", float and "float" or "normal")
  operations.open(selection.value, bufnr, float)
end

return { open_doc = open_doc }
