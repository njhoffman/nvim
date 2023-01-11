local cmds = require("import.commands")
local ui_state = require("import.ui.state")
local whitespace = "    "

local output_errors = function(lines, errors)
  table.insert(lines, "    Errors (" .. #errors .. "): ")
  for _, _error in ipairs(errors) do
    for line in _error:gmatch("[^\n]+") do
      -- https://github.com/miversen33/netman.nvim
      -- require("netman").log.debug({ line = _line })
      if not line:match("^%s*$") then
        table.insert(lines, string.format("%s%s", whitespace, line))
      end
    end
  end
  table.insert(lines, "")
end

local output_message = function(lines, message)
  table.insert(lines, "    Messages (" .. #message .. "): ")
  for _, _message in ipairs(message) do
    for line in _message:gmatch("[^\n]+") do
      if not line:match("^%s*$") then
        table.insert(lines, string.format("%s%s", whitespace, line))
      end
    end
  end
  table.insert(lines, "")
end

local output_logs = function(lines, logs)
  table.insert(lines, "    Logs (" .. #logs .. "): ")
  for _, log in ipairs(logs) do
    for line in log:gmatch("[^\n]+") do
      table.insert(lines, string.format("%s%s", whitespace, line))
    end
  end
end

local detail_lines = function()
  local module = ui_state._get_module(vim.api.nvim_win_get_cursor(0)[1] - 1)
  if not module then
    vim.api.nvim_buf_set_option(ui_state.view_buf_handle, "modifiable", true)
    vim.api.nvim_buf_set_lines(ui_state.view_buf_handle, 0, -1, false, {})
    return
  end

  local details = cmds.get_status(module)
  local lines = {}

  table.insert(lines, module)
  table.insert(lines, "    Imported: " .. details.status)
  table.insert(lines, "    Import Time: " .. math.floor(details.import_time / 1000000 * 1000) / 1000 .. " ms")
  table.insert(lines, "")

  -- vim.dbglog(module, details)

  if details.errors and #details.errors > 0 then
    output_errors(lines, details.errors)
  end

  if details.message and #details.message > 0 then
    output_message(lines, details.message)
  end

  if details.logs and #details.logs > 0 then
    output_logs(lines, details.logs)
  end

  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, "modifiable", true)
  vim.api.nvim_buf_set_lines(ui_state.view_buf_handle, 0, -1, false, {})
  vim.api.nvim_buf_set_lines(ui_state.view_buf_handle, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, "modifiable", false)
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, "modified", false)
end

return detail_lines
