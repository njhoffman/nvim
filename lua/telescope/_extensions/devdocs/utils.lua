local human_size = function(bytes)
  if bytes <= 0 then
    return '0 B'
  elseif bytes < 1024 then
    return bytes .. ' B'
  elseif bytes < 1024 * 1024 then
    return string.format('%.2f', bytes / 1024) .. ' KB'
  elseif bytes < 1024 * 1024 * 1024 then
    return string.format('%.2f', bytes / 1024 / 1024) .. ' MB'
  else
    return string.format('%.2f', bytes / 1024 / 1024 / 1024) .. ' GB'
  end
end

local strings = require('plenary.strings')
local get_widths = function(results)
  results = results or {}
  local widths = {}
  for _, entry in pairs(results) do
    for _, key in ipairs(vim.tbl_keys(entry)) do
      widths[key] = math.max(widths[key] or 0, strings.strdisplaywidth(entry[key] or ''))
    end
  end
  return widths
end

return { human_size = human_size, get_widths = get_widths }
