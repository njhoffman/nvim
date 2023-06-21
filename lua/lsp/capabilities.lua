local lspdefs = require('lsp.definitions')
local windows = require('lspconfig.ui.windows')
local handlers = require('lsp.handlers')

windows.default_options = { border = 'rounded' }

local function close_preview_window(winnr, bufnrs)
  vim.schedule(function()
    -- exit if we are in one of ignored buffers
    if bufnrs and vim.tbl_contains(bufnrs, vim.api.nvim_get_current_buf()) then
      return
    end

    local augroup = 'preview_window_' .. winnr
    pcall(vim.api.nvim_del_augroup_by_name, augroup)
    pcall(vim.api.nvim_win_close, winnr, true)
  end)
end

local function close_preview_autocmd(events, winnr, bufnrs)
  local augroup = vim.api.nvim_create_augroup('preview_window_' .. winnr, {
    clear = true,
  })

  -- close the preview window when entered a buffer that is not
  -- the floating window buffer or the buffer that spawned it
  vim.api.nvim_create_autocmd('BufEnter', {
    group = augroup,
    callback = function()
      close_preview_window(winnr, bufnrs)
    end,
  })

  if #events > 0 then
    vim.api.nvim_create_autocmd(events, {
      group = augroup,
      buffer = bufnrs[2],
      callback = function()
        close_preview_window(winnr)
      end,
    })
  end
end

vim.cmd("command! LspCapabilities lua require'lsp.capabilities'.show()")

local function show_capabilities()
  local buf_clients = vim.lsp.get_active_clients()

  local win_info = windows.percentage_range_window(0.8, 0.7)
  local bufnr, win_id = win_info.bufnr, win_info.win_id

  local buf_lines = {}

  local buf_client_names = {}
  for _, client in ipairs(buf_clients) do
    table.insert(buf_client_names, client.name)
  end

  local function make_client_info(client)
    local filtered, skipped = {}, {}
    for key, val in pairs(client.server_capabilities) do
      vim.dbglog(client.name, key)
      if vim.tbl_contains(lspdefs.display_keys, key) and client.server_capabilities[key] ~= false then
        table.insert(filtered, key)
      else
        table.insert(skipped, key)
      end
    end

    local lines = {
      'Client: ' .. client.name .. ' (id ' .. tostring(client.id) .. ')',
    }
    for _, key in ipairs(vim.fn.sort(filtered)) do
      table.insert(lines, '      ' .. key)
    end
    for _, key in ipairs(vim.fn.sort(skipped)) do
      table.insert(lines, '    󰍴  ' .. key)
    end
    return lines
  end

  for _, client in ipairs(buf_clients) do
    vim.list_extend(buf_lines, make_client_info(client))
    vim.list_extend(buf_lines, { '' })
  end

  vim.api.nvim_win_set_option(win_id, 'wrap', true)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, buf_lines)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'lspinfo')
  -- vim.api.nvim_set_hl(0, 'LspInfoBorder', { link = 'LspFloatWinBorder' })
  local configs_pattern = [[\%(]] .. table.concat(buf_client_names, [[\|]]) .. [[\)]]
  vim.cmd([[syntax match Title /\%(Client\):.*\zs]] .. configs_pattern .. '/')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<esc>', '<cmd>bd<CR>', { noremap = true })
  -- close_preview_autocmd({ "BufHidden", "BufLeave" }, win_id, { bufnr })
end

local try_capability = function(client, bufnr, capability)
  -- local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
  -- vim.dbglog(client.name .. ":  ? " .. capability .. " for '" .. ft .. "'")
  if client.server_capabilities[capability] then
    if handlers[capability] then
      -- vim.dbglog(client.name .. ": " .. " + " .. capability)
      handlers[capability](client, bufnr)
    else
      -- vim.dbglog(client.name .. ": " .. " - " .. capability)
    end
  end
end

local resolve_capabilities = function(client, bufnr)
  if client.name == 'tsserver' then
    vim.dbglog('SKIP tsserver')
    return false
  end
  for key, _ in pairs(client.server_capabilities) do
    try_capability(client, bufnr, key)
  end
end

local make_capabilities = function()
  local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { 'documentation', 'detail', 'additionalTextEdits' },
  }

  return capabilities
end

return {
  make = make_capabilities,
  show = show_capabilities,
  resolve = resolve_capabilities,
}
