local display = require('devbox.display')
local state = require('devbox.state')
local devbox_methods = require('devbox.methods')

local stop = function()
  local has_group = function(name)
    local has_match = false
    for _, augroup in ipairs(vim.fn.split(vim.fn.execute('augroup'))) do
      has_match = augroup == name or has_match
    end
    return has_match
  end
  vim.api.nvim_del_user_command('DevboxStop')
  if has_group('Devbox') then
    vim.api.nvim_del_augroup_by_name('Devbox')
  end
end

local provider_state = {
  name = nil,
  start = nil,
  idx = 0,
  content = nil,
  summary = nil,
}

local start = function()
  for i, method in pairs(devbox_methods.ext) do
    local provider = vim.fn.deepcopy(provider_state)
    provider = vim.tbl_deep_extend('force', provider, {
      name = method[1],
      handler = method[2],
      idx = i,
    })
    table.insert(state.providers, provider)
  end
  -- for i, method in pairs(devbox_methods.lsp) do
  --   local provider = vim.fn.deepcopy(provider_state)
  --   provider = vim.tbl_deep_extend("force", provider, { name = method[1], handler = method[2], idx = i })
  --   table.insert(state.providers, provider)
  -- end
  local linecnt = #state.providers
  state.popup.size.height = linecnt + 1
  display.create_popup(state.popup.size)
  display.update_popup()
end

local setup = function()
  vim.api.nvim_del_user_command('Devbox')
  vim.api.nvim_create_user_command('DevboxStop', function()
    vim.api.nvim_win_close(state.popup.winnr, true)
  end, { desc = 'Stop Devbox inspection' })

  vim.api.nvim_create_augroup('Devbox', { clear = true })
  local au_cursor_id = 0
  local au_cursor = function(_bufnr)
    au_cursor_id = vim.api.nvim_create_autocmd('CursorMoved', {
      callback = function()
        vim.defer_fn(display.update_popup, 200)
      end,
      group = 'Devbox',
      buffer = _bufnr,
    })
  end
  au_cursor(vim.api.nvim_win_get_buf(0))
  vim.api.nvim_create_autocmd('BufEnter', {
    callback = function(ev)
      vim.api.nvim_del_autocmd(au_cursor_id)
      au_cursor(tonumber(ev.match))
    end,
    group = 'Devbox',
  })

  vim.api.nvim_create_autocmd('WinClosed', {
    callback = function(ev)
      if ev.match == tostring(state.popup.winnr) then
        stop()
      end
    end,
    group = 'Devbox',
  })
  start()
end

local init = function()
  vim.api.nvim_create_user_command('Devbox', function()
    setup()
  end, { desc = 'Start devbox inspection window' })
end

return {
  start = start,
  stop = stop,
  init = init,
}
