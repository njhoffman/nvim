local ui_state = require('import.ui.state')
local format_module = require('import.ui.format')

local summary_lines = function(imported, view_width)
  local title = #imported.successes .. " imported"
  if #imported.failures > 0 then
    title = title .. ' - ' .. #imported.failures .. ' failed'
  end
  title = title .. ' - ' .. math.floor(imported.time / 1000000 * 100) / 100 .. " ms total"
  local title_padding = (view_width / 2) - (title:len() / 2)
  title = string.rep(' ', title_padding) .. title

  local lines = { title }
  ui_state.lines = { -1 }
  for _, _failed_import in ipairs(imported.failures) do
    table.insert(lines, format_module(_failed_import, imported.details[_failed_import]))
    table.insert(ui_state.lines, _failed_import)
  end
  table.insert(lines, "")
  table.insert(ui_state.lines, -1)
  for _, _success_import in ipairs(imported.successes) do
    table.insert(lines, format_module(
      _success_import, imported.details[_success_import])
    )
    table.insert(ui_state.lines, _success_import)
  end
  return lines
end

return summary_lines
