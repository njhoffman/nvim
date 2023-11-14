local hover = require('hover.hover')
local keymaps = require('hover.keymaps')
local state = require('hover.state')
local utils = require('hover.utils')

local function open(winnr, _opts)
  local opts = _opts or {}
  vim.api.nvim_create_augroup('Hover', { clear = true })

  if opts.behavior == 'once' then
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = function()
        vim.api.nvim_win_close(winnr, true)
        utils.clear_local_state(state)
        vim.api.nvim_del_augroup_by_name('Hover')
        keymaps.clear()
      end,
      group = 'Hover',
    })
  elseif opts.behavior == 'cursor' then
    local au_cursor = function(_bufnr)
      vim.api.nvim_create_autocmd('CursorMoved', {
        callback = function()
          utils.clear_local_state(state)
          vim.defer_fn(hover.hover_cursor, 300)
        end,
        group = 'Hover',
        buffer = _bufnr,
      })
    end
    au_cursor(vim.api.nvim_win_get_buf(0))

    -- vim.api.nvim_create_autocmd("BufEnter", {
    --   callback = function(ev)
    --     vim.api.nvim_del_autocmd(au_cursor_id)
    --     au_cursor(tonumber(ev.match))
    --   end,
    --   group = "Hover",
    -- })

    vim.api.nvim_create_autocmd('WinClosed', {
      callback = function(ev)
        vim.dbglog('winclosed', ev)
        if ev.match == tostring(winnr) then
          vim.dbglog('closing window...')
          vim.api.nvim_del_augroup_by_name('Hover')
          utils.clear_local_state(state)
          vim.dbglog('clear local 2', state)
          keymaps.clear()
        end
      end,
      group = 'Hover',
    })
  end
end
return {
  open = open,
}
