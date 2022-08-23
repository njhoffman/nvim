local cmds = require('import.commands')
local ui_state = require('import.ui.state')

local detail_lines = function()
  local module = ui_state._get_module(vim.api.nvim_win_get_cursor(0)[1])
  if not module then
    vim.api.nvim_buf_set_option(ui_state.view_buf_handle, 'modifiable', true)
    vim.api.nvim_buf_set_lines(ui_state.view_buf_handle, 0, -1, false, {})
    vim.api.nvim_buf_set_option(ui_state.view_buf_handle, 'modifiable', true)
    return
  end
  local details = cmds.get_status(module)
  local lines = {}
  table.insert(lines, module)
  table.insert(lines, "    Imported: " .. details.status)
  table.insert(lines, "    Import Time: " .. math.floor(details.import_time / 1000000 * 1000) / 1000 .. " ms")
  table.insert(lines, "")
  local whitespace = '        '
  if details.errors and #details.errors > 0 then
    table.insert(lines, "    Errors (" .. #details.errors .. '): ')
    for _, _error in ipairs(details.errors) do
      for _line in _error:gmatch('[^\n]+') do
        -- https://github.com/miversen33/netman.nvim
        -- require("netman").log.debug({ line = _line })
        vim.notify({
          line = _line,
          len  = string.len(_line),
        }, 'debug')
        if not _line:match('^%s*$') then
          table.insert(lines, string.format('%s%s', whitespace, _line))
        end
      end
    end
    table.insert(lines, '')
  end

  if details.message and #details.message > 0 then
    table.insert(lines, "    Messages (" .. #details.message .. '): ')
    for _, _message in ipairs(details.message) do
      for _line in _message:gmatch('[^\n]+') do
        if not _line:match('^%s*$') then
          table.insert(lines, string.format('%s%s', whitespace, _line))
        end
      end
    end
    table.insert(lines, '')
  end

  if details.logs and #details.logs > 0 then
    table.insert(lines, "    Logs (" .. #details.logs .. '): ')
    for _, _log in ipairs(details.logs) do
      for _line in _log:gmatch('[^\n]+') do
        table.insert(lines, string.format('%s%s', whitespace, _line))
      end
    end
  end
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, 'modifiable', true)
  vim.api.nvim_buf_set_lines(ui_state.view_buf_handle, 0, -1, false, {})
  vim.api.nvim_buf_set_lines(ui_state.view_buf_handle, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, 'modifiable', false)
  vim.api.nvim_buf_set_option(ui_state.view_buf_handle, 'modified', false)
end

return detail_lines
