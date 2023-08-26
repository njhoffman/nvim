local api = vim.api
local base = require('notify.render.base')
local utils = require('notify.util.render')

vim.cmd([[
  highlight default link NotifyERRORCode Error
  highlight default link NotifyERRORMain healthWarning
  " highlight default link NotifyERRORFile Comment
  highlight default link NotifyERRORFile Normal
  highlight default link NotifyERRORLine Constant
  highlight default link NotifyERRORMessage Title
  highlight default link NotifyERRORStack Comment
]])

local file_pfx = string.gsub(vim.fn.stdpath('config'), os.getenv('HOME') .. '/', '') .. '/'
local get_path = function(file)
  local path = vim.fn.trim(file) or file
  local file_match = string.match(path, '.*' .. file_pfx)
  if file_match then
    path = vim.fn.stdpath('config') .. '/' .. string.gsub(path, file_match, '')
  elseif not string.match(path, '^/') then
    path = vim.fn.stdpath('config') .. '/' .. string.gsub(path, '^./', '')
  end
  return path
end

local get_error_parts = function(lines)
  local first_line = lines[1]
  -- stylua: ignore
  local parts = {
    code = string.match(first_line,    '(E[%d]+)') or '',
    title = string.match(first_line,   ': ([^:/.]+)') or '',
    file = string.match(first_line,    '[^:]+:[^:/.]+:?([^:]*):') or '',
    line = string.match(first_line,    '[^:]+:[^:/.]+:?[^:]+:([^:]*):') or '',
    message = string.match(first_line, '[^:]+:[^:/.]+:?[^:]+:[^:]+: ([^:]*)') or '',
    stack = {},
  }

  for i, line in pairs(lines) do
    if i > 2 then
      line = utils.path_nvim(string.gsub(line, '^%s+', ''))
      if string.len(line) > 0 then
        table.insert(parts.stack, line)
      end
    end
  end
  parts.title = vim.trim(parts.title)
  parts.path = get_path(parts.file)
  parts.shortfile = utils.path_nvim(string.gsub(parts.path, '^%s+', ''))
  return parts
end

local function error_highlighting(bufnr, notif, highlights, config)
  local namespace = base.namespace()
  local msg = notif.message
  local parts = get_error_parts(msg)

  local hl_map = {
    code = 'NotifyERRORCode',
    title = 'NotifyERRORMain',
    file = 'NotifyERRORFile',
    line = 'NotifyERRORLine',
    message = 'NotifyERRORMessage',
    stack = 'NotifyERRORStack',
  }

  local line_start = 1
  if utils.file_exists(parts.path) then
    vim.api.nvim_buf_set_var(bufnr, 'notify_file', parts.path)
    vim.api.nvim_buf_set_var(bufnr, 'notify_line', parts.line)
    line_start = 2
  end

  local lines = { '' }
  local hls = {}
  local col = 0
  if #parts.code > 0 then
    lines[1] = parts.code .. ':'
    table.insert(hls, { hl_map.code, 0, 0, #parts.code })
    col = #parts.code + 1
  end
  lines[1] = lines[1] .. parts.title
  table.insert(hls, { hl_map.title, 0, col, col + #parts.title })

  lines[2] = parts.shortfile .. ':' .. parts.line .. ':' .. parts.message
  table.insert(hls, { hl_map.file, 1, 0, #parts.shortfile })
  col = #parts.shortfile + 1
  table.insert(hls, { hl_map.line, 1, col, col + #parts.line })
  col = col + #parts.line + 1

  for i, stack in ipairs(parts.stack) do
    lines[2 + i] = '  ' .. stack
    table.insert(hls, { hl_map.stack, 1 + i, 0, #lines[2 + i] })
  end

  vim.api.nvim_buf_set_lines(bufnr, 2, -1, true, lines)
  for _, hl in ipairs(hls) do
    local opt = { hl_group = hl[1], end_col = hl[4] }
    -- vim.dbglog(lines, hl[4])
    vim.api.nvim_buf_set_extmark(bufnr, namespace, hl[2] + line_start, hl[3], opt)
  end
end

local default_render = function(bufnr, notif, highlights, config)
  local left_icon = notif.icon .. ' '
  local max_message_width = math.max(math.max(unpack(vim.tbl_map(function(line)
    return vim.fn.strchars(line)
  end, notif.message))))
  local right_title = notif.title[2]
  local left_title = notif.title[1]
  local title_accum = vim.str_utfindex(left_icon) + vim.str_utfindex(right_title) + vim.str_utfindex(left_title)

  local left_buffer = string.rep(' ', math.max(0, max_message_width - title_accum))

  local namespace = base.namespace()
  api.nvim_buf_set_lines(bufnr, 0, 1, false, { '', '' })
  api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    virt_text = {
      { ' ' },
      { left_icon, highlights.icon },
      { left_title .. left_buffer, highlights.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
    virt_text = { { ' ' }, { right_title, highlights.title }, { ' ' } },
    virt_text_pos = 'right_align',
    priority = 10,
  })
  api.nvim_buf_set_extmark(bufnr, namespace, 1, 0, {
    virt_text = {
      {
        string.rep('━', math.max(vim.str_utfindex(left_buffer) + title_accum + 2, config.minimum_width())),
        highlights.border,
      },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
end

return function(bufnr, notif, highlights, config)
  default_render(bufnr, notif, highlights, config)
  error_highlighting(bufnr, notif, highlights, config)
end
