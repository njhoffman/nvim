local keymaps = require('hover.keymaps')
local state = require('hover.state')
local utils = require('hover.utils')
local providers = require('hover.providers')

local cleanup = function()
  utils.clear_local_state(state)
  keymaps.clear()
  vim.api.nvim_del_augroup_by_name('Hover')
end

local create = function(winnr, _opts)
  local opts = _opts or {}
  local winid = vim.fn.win_getid(winnr)
  vim.api.nvim_create_augroup('Hover', { clear = true })
  vim.api.nvim_create_autocmd('WinClosed', {
    callback = function(ev)
      if tostring(ev.match) == tostring(winnr) then
        cleanup()
      end
    end,
    group = 'Hover',
  })

  if opts.behavior == 'once' then
    vim.api.nvim_create_autocmd('CursorMoved', {
      callback = function()
        vim.api.nvim_win_close(winnr, true)
        cleanup()
      end,
      once = true,
      group = 'Hover',
    })
  elseif opts.behavior == 'cursor' then
    local au_cursor = function(_bufnr)
      vim.api.nvim_create_autocmd('CursorMoved', {
        callback = function()
          utils.clear_local_state(state)
          vim.defer_fn(providers.load, 300)
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
  end
end

return {
  create = create,
}
