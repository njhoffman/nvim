local cmd = vim.api.nvim_create_user_command
local state = require('hover.state')

local handle_command = function(fn)
  return function(input)
    local opts = {}
    if input.args and input.args ~= '' then
      vim.dbglog('command args', input.args)
    end
    fn(opts)
  end
end

local init = function()
  vim.api.nvim_create_augroup('Hover', { clear = true })

  cmd('HoverClose', function()
    vim.api.nvim_win_close(state.winnr, true)
  end, { desc = 'Close hover window' })

  cmd('Hover', handle_command(require('hover').hover_once), { desc = 'Open hover window once' })
  cmd('HoverSticky', handle_command(require('hover').hover_sticky), { desc = 'Open hover window sticky' })
  cmd('HoverCursor', handle_command(require('hover').hover_cursor), { desc = 'Open hover select menu' })
  cmd('HoverSelect', handle_command(require('hover').hover_select), { desc = 'Open hover select menu' })
end

return { init = init, clear = clear }
