local utils = require('notifications.utils')

vim.cmd([[
  highlight default link NotifyRunErrorCommand healthWarning
  highlight default link NotifyRunErrorCode Error
  highlight default link NotifyRunErrorMessage DiagnosticError
  highlight default link NotifyRunErrorTitle Title
  highlight default link NotifyRunErrorFile Normal
  highlight default link NotifyRunErrorStack Comment
  highlight default link NotifyRunErrorLine Constant
]])

local get_error_parts = function(lines)
  local msg = lines[1]
  local parts = {
    code = string.match(msg, '[E%d]+') or '',
    title = string.match(msg, ': ([^:]+)') or '',
    file = string.match(msg, '[^:]+:[^:]+:[^:]+:([^:]*):') or '',
    line = string.match(msg, '[^:]+:[^:]+:[^:]+:[^:]+:([^:]*):') or '',
    message = string.match(msg, '[^:]+:[^:]+:[^:]+:[^:]+: ([^:]*)') or '',
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

  parts.shortfile = utils.path_nvim(string.gsub(parts.file, '^%s+', ''))
  return parts
end

local get_opts = function(output, cmd, time, parts)
  -- local orig_map = coreutils.find(vim.api.nvim_get_keymap("n"), "lhs", "gF")
  -- local bufname = vim.api.nvim_buf_get_name(0)
  -- local run_cmd_default = 'edit'
  -- if bufname ~= parts.file then
  --   run_cmd_default = 'split'
  -- end
  -- run_cmd = run_cmd or run_cmd_default
  --
  -- local on_open = function(notify_winnr)
  --   vim.cmd(':' .. run_cmd .. ' +' .. parts.line .. ' ' .. parts.file)
  --   local currwin = vim.api.nvim_get_current_win()
  --   local cb_close = function()
  --     vim.api.nvim_set_current_win(currwin)
  --     vim.api.nvim_win_close(notify_winnr, true)
  --     -- notify.dismiss()
  --   end
  --
  --   -- gT: telescope all line matches
  --   -- vim.api.nvim_set_keymap("n", "g!", "", { callback = cb_close })
  --   -- vim.api.nvim_buf_set_keymap(buf, "n", "<2-LeftMouse>", "", { callback = cb })
  -- end
  --
  -- local on_close = function()
  --   vim.dbglog('notify close')
  -- end
  --

  local render_error = function(bufnr, _, highlights)
    local hl = {
      code = 'NotifyRunErrorCode',
      title = 'NotifyRunErrorTitle',
      file = 'NotifyRunErrorFile',
      line = 'NotifyRunErrorLine',
      message = 'NotifyRunErrorMessage',
      command = 'NotifyRunErrorCommand',
      stack = 'NotifyRunErrorStack',
    }

    local width = utils.lines_width({
      parts.code .. ' ' .. parts.title,
      '  ' .. parts.shortfile .. ':' .. parts.line .. ':' .. parts.message,
      unpack(parts.stack),
    })
    utils.render_box(bufnr, highlights, { parts.code, parts.title }, width)
    utils.build_line(bufnr, 2, { { cmd, hl.command } })
    utils.build_line(bufnr, 3, { { parts.code, hl.code }, { ': ', 'Normal' }, { parts.title, hl.title } })
    utils.build_line(bufnr, 4, {
      { '  ' .. parts.shortfile, hl.file },
      { ':', 'Normal' },
      { parts.line, hl.line },
      { ':', 'Normal' },
      { parts.message, hl.message },
    })
    -- for i, line in pairs(parts.stack) do
    --   utils.build_line(bufnr, 4 + i, { { '    ' .. line, hl.stack } })
    -- end

    -- TODO: remove old '(Runner)' statements
    local list = vim.fn.getqflist()
    table.insert(list, 1, {
      filename = parts.shortfile,
      lnum = parts.line,
      text = '(Runner) ' .. parts.message,
    })
    vim.fn.setqflist({}, 'r', { nr = '$', items = list })
  end

  return {
    -- on_open = on_open,
    -- on_close = on_close,
    timeout = 8000,
    render = render_error,
    -- anchor = 'TC',
  }
end

-- local test_render = function()
--   local notify = require("notify")
--   local errors = require("notifications.error-examples")
--   local msg = errors.error3
--   -- notify(msg, 'error', _notify_opts(parts))
-- end

local notify_error = function(output, cmd, time)
  local error_parts = get_error_parts(output)
  local opts = get_opts(output, cmd, time, error_parts)
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
    .notify(error_parts, 'error', opts)
end

return {
  -- test_render = test_render,
  notify = notify_error,
}
