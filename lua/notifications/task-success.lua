local utils = require('notifications.utils')

vim.cmd [[
  highlight default link NotifyRunSuccessMessage Comment
  highlight default link NotifyRunSuccessCommand healthSuccess
]]

local _get_parts = function(lines)
  local msg = lines[1] or ''
  local parts = {
    message = string.match(msg, '.*'),
  }
  return parts
end

local _notify_opts = function(parts)
  -- local orig_map = coreutils.find(vim.api.nvim_get_keymap("n"), "lhs", "gF")
  local render_success = function(bufnr, _, highlights)
    local hl = {
      command = 'NotifyRunSuccessCommand',
      message = 'NotifyRunSuccessMessage',
    }
    local width = utils.lines_width({
      parts.command,
      parts.message,
    })
    utils.render_box(bufnr, highlights, { 'OK', parts.time .. ' ms' }, width)
    utils.build_line(bufnr, 2, { { parts.command, hl.command } })
    if #parts.message > 0 then
      utils.build_line(bufnr, 3, { { parts.message, hl.message } })
    end
  end

  return {
    -- on_open = on_open,
    -- on_close = on_close,
    render = render_success,
    anchor = 'TC'
  }
end

local test_success = function()
  local notify = require('notify')
  local msgs = require('notify.success-examples')
  local msg = msgs.success1
  local parts = _get_parts(msg)
  parts.command = 'test_cmd'
  parts.time = 2512523
  -- vim.fn.system('echo -e "\\033[38;5;89mtesting one, two, three\\033[0m"')
  notify(msg, 'info', _notify_opts(parts))
end

local notify_success = function(msg, cmd, time)
  local notify = require('notify')
  local parts = _get_parts(msg)
  parts.command = cmd
  parts.time = time
  notify(msg, 'info', _notify_opts(parts))
end

return {
  test_render = test_success,
  notify      = notify_success
}
