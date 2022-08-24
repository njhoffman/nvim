local ui_state = require('import.ui.state')
local format = require('import.ui.format')

local title_line = function(imported, view_width)
  local title = #imported.successes .. " imported"

  if #imported.failures > 0 then
    title = title .. ' - ' .. #imported.failures .. ' failed'
  end

  title = title .. ' - ' ..
    math.floor(imported.time / 1000000 * 100) / 100 .. " ms total"
  local title_padding = (view_width / 2) - (title:len() / 2)
  title = string.rep(' ', title_padding) .. title
  -- title_line(imported, view_width)
  return title
end

local output_title = function(imported, view_width)
  title_line(imported, view_width)
end

-- local lines_width = function(lines)
--   return math.max(math.max(unpack(vim.tbl_map(
--     function(line) return vim.fn.strchars(string.gsub(line, '^%s+', ''))
--   end, lines))))
-- end
-- local lines_width = function(data, user_cb)
--   local count_c = function(line)
--     return vim.fn.strchars(string.gsub(user_cb(line), '^%s+', ''))
--   end
--   return math.max(math.max(unpack(
--     vim.tbl_map(count_c, data)
--   )))
-- end

-- local combine_fields = function(fields)
--   return fields[2] .. ' fag'
-- end
-- -- return vim.fn.strchars(string.gsub(line, '^%s+', ''))
-- local lines = { { " ", "plugins.config.substitute-nvim" }, { " ", " substitute-nvim" } }

-- vim.dbglog(lines_width(lines, combine_fields))


local output_success = function(imported, view_width)
  local lines = {}
  for _, _success_import in ipairs(imported.successes) do
    table.insert(lines,
      format.success(_success_import, imported.details[_success_import])
    )
    table.insert(ui_state.lines, _success_import)
  end
  return lines
end

-- local summary_lines = function(imported, view_width)
--   local lines = { title_line(imported, view_width) }
--   ui_state.lines = { -1 }
--   failed_lines(imported, view_width, lines)
--   table.insert(lines, "")
--   table.insert(ui_state.lines, -1)
--   success_lines(imported, view_width, lines)
--   return lines
-- end


local hl_fail = {
  icon    = 'ImportIcon',
  title   = 'ImportErrorTitle',
  file    = 'ImportErrorFile',
  line    = 'ImportErrorLine',
  message = 'ImportErrorMessage',
  command = 'ImportErrorCommand',
  stack   = 'ImportErrorStack',
}

local hl_success = {
  icon    = 'ImportErrorIcon',
  title   = 'ImportErrorTitle',
  file    = 'ImportErrorFile',
  line    = 'ImportErrorLine',
  message = 'ImportErrorMessage',
  command = 'ImportErrorCommand',
  stack   = 'ImportErrorStack',
}

-- local width = utils.lines_width({
--   parts.message,
--   '  ' .. parts.file,
--   parts.line,
--   unpack(parts.stack),
-- })


local build_line = function(bufnr, linenum, parts)
  local line = ''
  local hls = {}

  for _, part in pairs(parts) do
    local col_start = string.len(line)
    line = line .. part[1]
    local col_end = string.len(line)
    table.insert(hls, { part[2], col_start, col_end })
  end
  vim.api.nvim_buf_set_lines(bufnr, linenum, -1, false, { line })
  for _, hl in pairs(hls) do
    if type(hl[1]) == 'string' and #hl[1] > 0 then
      vim.api.nvim_buf_add_highlight(bufnr, 0, hl[1], linenum, hl[2], hl[3])
    end
  end
end

local output_failed = function(imported, view_width)
  local lines = {}
  local file_width = 20
  for _, _failed in ipairs(imported.failures) do
    table.insert(lines,
      format.failed(_failed, imported.details[_failed], file_width)
    )
    table.insert(ui_state.lines, _failed)
  end
  return lines
end


local summary_lines = function(imported, view_width, bufnr)
  -- output_title(imported, view_width)
  local failed_lineparts = output_failed(imported)
  for i, linepart in pairs(failed_lineparts) do
    build_line(bufnr, i + 2, linepart)
  end
  -- vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, lines)

  -- vim.dbglog(failed_lines)
  -- local
  -- output_success(imported)
  -- return lines
end

return summary_lines
