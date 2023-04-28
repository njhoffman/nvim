local utils = require('notifications.utils')

vim.cmd([[
  highlight default link NotifyRunSuccessOutput Normal
  highlight default link NotifyRunSuccessCommand healthSuccess
]])

local get_opts = function(parts)
  -- local orig_map = coreutils.find(vim.api.nvim_get_keymap("n"), "lhs", "gF")
  local render_success = function(bufnr, _, highlights)
    local hl = {
      command = 'NotifyRunSuccessCommand',
      output = 'NotifyRunSuccessOutput',
    }
    local width = utils.lines_width(vim.fn.flatten({
      parts.cmd,
      parts.output,
    }))
    utils.render_box(bufnr, highlights, { 'OK', parts.time .. ' ms' }, width)
    utils.build_line(bufnr, 2, { { parts.cmd, hl.command } })
    for i, line in ipairs(parts.output) do
      utils.build_line(bufnr, 2 + i, { { line, hl.output } })
    end
  end
  return {
    -- on_open = on_open,
    -- on_close = on_close,
    hide_from_history = false,
    render = render_success,
    -- anchor = "TC",
  }
end

local notify_success = function(output, cmd, time)
  local parts = { cmd = cmd, time = time, output = output }
  local opts = get_opts(parts)
  require('notify')
    .instance({
      level = 4,
      max_height = function()
        return math.floor(vim.opt.lines:get() / 5 * 4)
      end,
      max_width = function()
        return math.floor(vim.opt.columns:get() / 5 * 4)
      end,
    }, true)
    .notify(output, 'run', opts)
end

-- local test_success = function()
--   local notify = require("notify")
--   local msgs = require("notify.success-examples")
--   local msg = msgs.success1
--   local parts = _get_parts(msg)
--   parts.command = "test_cmd"
--   parts.time = 2512523
--   -- vim.fn.system('echo -e "\\033[38;5;89mtesting one, two, three\\033[0m"')
--   notify(msg, "info", _notify_opts(parts))
-- end

return {
  -- test_render = test_success,
  notify = notify_success,
}
