local lsp_icons = require('lsp.icons')
local capabilities = require('lsp.capabilities')
local format = require('lsp.format')

local setup_mappings = function()
  vim.api.nvim_set_keymap(
    'n',
    '<M-T>',
    "<cmd>lua require('telescope.run')('builtin', 'diagnostics', { bufnr = true })<cr>",
    { silent = true, desc = 'show buffer diagnostics' }
  )

  vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  vim.api.nvim_set_keymap(
    'n',
    '<M-w>',
    "<cmd>lua require('telescope.run')('builtin', 'diagnostics')<cr>",
    { silent = true, desc = 'show workspace  diagnostics' }
  )
  vim.api.nvim_set_keymap(
    'n',
    '<Leader>e',
    '<cmd>lua vim.diagnostic.open_float()<CR>',
    { silent = true, desc = 'open diagnostic float' }
  )
  vim.api.nvim_set_keymap(
    'n',
    '[d',
    '<cmd>lua vim.diagnostic.goto_prev()<CR>',
    { silent = true, desc = 'prev diagnostic problem' }
  )
  vim.api.nvim_set_keymap(
    'n',
    ']d',
    '<cmd>lua vim.diagnostic.goto_next()<CR>',
    { silent = true, desc = 'next diagnostic problem' }
  )
  vim.api.nvim_set_keymap(
    'n',
    '[e',
    '<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>',
    { silent = true, desc = 'jump to prev error' }
  )
  vim.api.nvim_set_keymap(
    'n',
    ']e',
    '<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>',
    { silent = true, desc = 'jump to next error' }
  )
  vim.api.nvim_set_keymap(
    'n',
    'gqd',
    '<cmd>lua vim.diagnostic.setqflist({ open = true  })<CR>',
    { silent = true, desc = 'diagnostics to quickfix' }
  )

  -- if the file is .sql
  if vim.bo.filetype == 'sql' then
    vim.keymap.set('n', '<leader>', ':!sqlfluff fix -fq --dialect=postgres %<cr>')
  end
end

local icons = lsp_icons.get_icons('diagnostics')
vim.fn.sign_define('DiagnosticSignError', { text = icons.error, texthl = 'LspDiagnosticsSignError' })
vim.fn.sign_define('DiagnosticSignWarn', { text = icons.warn, texthl = 'LspDiagnosticsSignWarn' })
vim.fn.sign_define('DiagnosticSignInfo', { text = icons.info, texthl = 'LspDiagnosticsSignInfo' }) -- 󰌵
vim.fn.sign_define('DiagnosticSignHint', { text = icons.hint, texthl = 'LspDiagnosticsSignHint' })

format.setup()

-- exclude is a table of LSP servers that should not format the buffer.
-- Alternatively, you can also just not call on_attach for the clients you don't want to use for formatting.
-- order is a table that determines the order formatting is requested from the LSP server.
-- sync turns on synchronous formatting. The editor will block until the formatting is done.
-- force will write the format result to the buffer, even if the buffer changed after the format request started.
-- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded', max_width = 80 })
-- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

local on_attach = function(client, bufnr)
  local ok, disable_lsp = pcall(vim.api.nvim_buf_get_var, 0, 'disable_lsp')
  if disable_lsp == 1 then
    return vim.notify('Skipping buffer lsp', 1)
  end

  --       vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'
  -- vim.lsp.omnifunc = nil
  -- vim.api.nvim_set_option_value('omnifunc', nil, {})
  -- vim.api.nvim_set_option_value('omnifunc', nil, { buf = bufnr })

  format.on_attach(client, bufnr)
  setup_mappings()

  client.config.flags.debounce_text_changes = 300
  -- client.config.flags.allow_incremental_sync = true

  if client.name == 'lua_ls' then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  elseif client.name == 'pyright' then
    client.server_capabilities.hoverProvider = false
  elseif client.name == 'pylsp' then
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.signatureHelpProvider = false
  elseif client.name == 'cssls' then
    client.server_capabilities.textDocument.completion.completionItem.snippetSupport = true
  end

  -- if client.server_capabilities.inlayHintProvider then
  --   -- vim.dbglog('INLAY HINTS AVAILABLE')
  --   vim.lsp.inlay_hint.enable(bufnr, true)
  -- end

  capabilities.resolve(client, bufnr)
end

return on_attach
