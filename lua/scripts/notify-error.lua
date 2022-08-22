local utils = require('plugins.config.nvim-notify.utils')
local ns_id = vim.api.nvim_create_namespace("nvim-notify")

vim.cmd [[
  highlight default link NotifyRunErrorCode Error
  highlight default link NotifyRunErrorMessage DiagnosticError
  highlight default link NotifyRunErrorTitle Normal
  highlight default link NotifyRunErrorFile Normal
  highlight default link NotifyRunErrorStack Comment
  highlight default link NotifyRunErrorLine Constant
]]

local render_box = function(bufnr, highlights, title, width)
  local minimum_width = 20
  local left_icon = " "
  local right_title = title[2]
  local left_title = title[1]
  local title_accum = vim.str_utfindex(left_icon)
    + vim.str_utfindex(right_title)
    + vim.str_utfindex(left_title)

  local left_buffer = string.rep(" ", math.max(0, width - title_accum))
  vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, { "", "" })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
    virt_text = {
      { " " },
      { left_icon, highlights.icon },
      { left_title .. left_buffer, highlights.title },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 0, 0, {
    virt_text = { { " " }, { right_title, highlights.title }, { " " } },
    virt_text_pos = "right_align",
    priority = 10,
  })
  vim.api.nvim_buf_set_extmark(bufnr, ns_id, 1, 0, {
    virt_text = {
      {
        string.rep(
          "━",
          math.max(vim.str_utfindex(left_buffer) + title_accum + 2, minimum_width)
        ),
        highlights.border,
      },
    },
    virt_text_win_col = 0,
    priority = 10,
  })
end

local render_error = function(bufnr, notif, highlights)
  local msg = notif.message[1]
  local parts = {
    code  = string.match(msg, '[E%d]+'),
    title = string.match(msg, ': ([^:]+)'),
    file  = string.match(msg, '[^:]+:[^:]+: ([^:]*):'),
    line  = string.match(msg, '[^:]+:[^:]+:[^:]+:([^:]*):'),
    error = string.match(msg, '[^:]+:[^:]+:[^:]+:[^:]+: ([^:]*)'),
    stack = {},
  }
  local hl = {
    code  = 'NotifyRunErrorCode',
    title = 'NotifyRunErrorTitle',
    file  = 'NotifyRunErrorFile',
    line  = 'NotifyRunErrorLine',
    error = 'NotifyRunErrorMessage',
    stack = 'NotifyRunErrorStack',
  }

  for i, line in pairs(notif.message) do
    if i > 2 then
      line = utils.path_nvim(string.gsub(line, '^%s+', ''))
      if string.len(line) > 0 then
        table.insert(parts.stack, line)
      end
    end
  end

  parts.file = utils.path_nvim(parts.file)
  local width = utils.lines_width({
    parts.error,
    '  ' .. parts.file,
    parts.line,
    unpack(parts.stack),
  })

  render_box(bufnr, highlights, { parts.code, parts.title }, width)

  utils.build_line(bufnr, 2, {
    { parts.error, hl.error },
  })

  utils.build_line(bufnr, 3, {
    { '  ' .. parts.file, hl.file },
    { ':', 'Normal' },
    { parts.line, hl.line }
  })

  for i, line in pairs(parts.stack) do
    utils.build_line(bufnr, 3 + i, {
      { '    ' .. line, hl.stack }
    })
  end
  vim.cmd(':e +' .. parts.line .. ' ' .. parts.file)
end

local test_render = function()
  local notify = require('notify')
  local errors = require('plugins.config.nvim-notify.error-examples')
  notify(errors.error3, 'error', { render = render_error })
end

return {
  test_render = test_render,
  render = render_error
}
