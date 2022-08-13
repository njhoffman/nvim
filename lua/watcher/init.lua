local config = { interval = 3000, list = {} }

local watch_list = function(get_data, config)
  local curr_list = get_data()
  for i, line in pairs(curr_list) do
    local matches = line:gmatch("[ ]+[0-9]+")
    print(vim.inspect(matches))
  end
end

local get_changes = function()
  local lines = {}
  local changes = vim.api.nvim_command_output("changes")

  for change in changes:gmatch("[^\r\n]+") do
    table.insert(lines, change)
  end
  table.remove(lines, 1)
  return lines
end

watch_list(get_changes, config)
