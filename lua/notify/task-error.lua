local utils = require('notify.utils')

vim.cmd [[
  highlight default link NotifyRunErrorCode Error
  highlight default link NotifyRunErrorMessage DiagnosticError
  highlight default link NotifyRunErrorTitle Normal
  highlight default link NotifyRunErrorFile Normal
  highlight default link NotifyRunErrorStack Comment
  highlight default link NotifyRunErrorLine Constant
]]

local _get_parts = function(lines)
  local msg = lines[1]
  local parts = {
    code    = string.match(msg, '[E%d]+'),
    title   = string.match(msg, ': ([^:]+)'),
    file    = string.match(msg, '[^:]+:[^:]+: ([^:]*):'),
    line    = string.match(msg, '[^:]+:[^:]+:[^:]+:([^:]*):'),
    message = string.match(msg, '[^:]+:[^:]+:[^:]+:[^:]+: ([^:]*)'),
    stack   = {},
  }

  for i, line in pairs(lines) do
    if i > 2 then
      line = utils.path_nvim(string.gsub(line, '^%s+', ''))
      if string.len(line) > 0 then
        table.insert(parts.stack, line)
      end
    end
  end

  parts.shortfile = utils.path_nvim(parts.file)
  return parts
end

local _notify_opts = function(parts, cmd)
  -- local orig_map = coreutils.find(vim.api.nvim_get_keymap("n"), "lhs", "gF")
  local bufname = vim.api.nvim_buf_get_name(0)
  local cmd_default = 'edit'
  if bufname ~= parts.file then cmd_default = 'split' end
  cmd = cmd or cmd_default

  local on_open = function(notify_winnr)
    vim.cmd(':' .. cmd .. ' +' .. parts.line .. ' ' .. parts.file)
    local currwin = vim.api.nvim_get_current_win()
    local cb_close = function()
      vim.api.nvim_set_current_win(currwin)
      vim.api.nvim_win_close(notify_winnr, true)
      -- notify.dismiss()
      vim.dbglog('cb_close msg')
    end

    -- gT: telescope all line matches
    -- vim.api.nvim_set_keymap("n", "g!", "", { callback = cb_close })
    -- vim.api.nvim_buf_set_keymap(buf, "n", "<2-LeftMouse>", "", { callback = cb })
  end

  local on_close = function()
    vim.dbglog('notify close')
  end

  local render_error = function(bufnr, _, highlights)
    local hl = {
      code    = 'NotifyRunErrorCode',
      title   = 'NotifyRunErrorTitle',
      file    = 'NotifyRunErrorFile',
      line    = 'NotifyRunErrorLine',
      message = 'NotifyRunErrorMessage',
      stack   = 'NotifyRunErrorStack',
    }

    local width = utils.lines_width({
      parts.message,
      '  ' .. parts.file,
      parts.line,
      unpack(parts.stack),
    })

    utils.render_box(bufnr, highlights, { parts.code, parts.title }, width)

    utils.build_line(bufnr, 2, {
      { parts.message, hl.message },
    })

    utils.build_line(bufnr, 3, {
      { '  ' .. parts.shortfile, hl.file },
      { ':', 'Normal' },
      { parts.line, hl.line }
    })

    for i, line in pairs(parts.stack) do
      utils.build_line(bufnr, 3 + i, { { '    ' .. line, hl.stack } })
    end
  end

  return {
    on_open = on_open,
    on_close = on_close,
    render = render_error
  }
end

local match_error = function(lines)
  return string.match(lines[1], '[E%d]+')
end

local test_error = function()
  local notify = require('notify')
  local errors = require('notify.error-examples')
  local msg = errors.error3
  local parts = _get_parts(msg)
  notify(msg, 'error', _notify_opts(parts))
end

local notify_error = function(msg)
  local notify = require('notify')
  local parts = _get_parts(msg)
  notify(msg, 'error', _notify_opts(parts))
end

return {
  test_render = test_error,
  notify      = notify_error,
  is_match    = match_error,
}
