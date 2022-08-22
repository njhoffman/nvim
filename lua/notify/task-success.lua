local utils = require('notify.utils')

vim.cmd [[
  highlight default link NotifyRunSuccessMessage DiagnosticSuccess
]]

local _get_parts = function(lines)
  local msg = lines[1]
  local parts = {
    message = string.match(msg, '.*'),
  }
  return parts
end

local _notify_opts = function(parts, cmd)
  -- local orig_map = coreutils.find(vim.api.nvim_get_keymap("n"), "lhs", "gF")
  local render_success = function(bufnr, _, highlights)
    local hl = {
      message = 'NotifyRunSuccessMessage',
    }

    local width = utils.lines_width({
      parts.message,
      '  ' .. parts.file,
      parts.line,
      unpack(parts.stack),
    })
    utils.render_box(bufnr, highlights, { 'Success', cmd }, width)
    utils.build_line(bufnr, 2, { { parts.message, hl.message } })
  end

  return {
    -- on_open = on_open,
    -- on_close = on_close,
    render = render_success
  }
end

local test_success = function()
  local notify = require('notify')
  local msgs = require('notify.success-examples')
  local msg = msgs.success1
  local parts = _get_success_parts(msg)
  notify(msg, 'task', _notify_opts(parts))
end

local notify_success = function(msg)
  local notify = require('notify')
  local parts = _get_parts(msg)
  notify(msg, 'error', _notify_opts(parts))
end

return {
  test_render = test_success,
  notify      = notify_success
}
