local get_changes = function()
  local lines = {}
  local changes = vim.api.nvim_command_output("changes")

  for change in changes:gmatch("[^\r\n]+") do
    table.insert(lines, change)
  end
  table.remove(lines, 1)
  return lines
end

return get_changes
