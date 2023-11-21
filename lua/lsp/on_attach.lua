local capabilities = require('lsp.capabilities')
local format = require('lsp.format')

format.setup()
-- exclude is a table of LSP servers that should not format the buffer.
-- Alternatively, you can also just not call on_attach for the clients you don't want to use for formatting.
-- order is a table that determines the order formatting is requested from the LSP server.
-- sync turns on synchronous formatting. The editor will block until the formatting is done.
-- force will write the format result to the buffer, even if the buffer changed after the format request started.

local on_attach = function(client, bufnr)
  local ok, disable_lsp = pcall(vim.api.nvim_buf_get_var, 0, 'disable_lsp')
  if disable_lsp == 1 then
    return vim.notify('Skipping buffer lsp', 1)
  end
  format.on_attach(client, bufnr)
  -- diag on hover
  -- vim.api.nvim_create_autocmd('CursorHold', {
  --   buffer = bufnr,
  --   callback = function()
  --     virtual_text = {}
  --     -- local opts = {
  --     --   focusable = false,
  --     --   close_events = { 'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost' },
  --     --   border = 'rounded',
  --     --   source = 'always',
  --     --   prefix = '■', -- Could be '●', '▎', 'x'
  --     --   scope = 'cursor',
  --     -- }
  --     vim.diagnostic.open_float(nil, {})
  --   end,
  -- })

  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "")

  -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded', max_width = 80 })
  -- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

  -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  --   vim.lsp.diagnostic.on_publish_diagnostics, {
  --     -- Enable signs
  --     signs = true,
  --   }
  -- )
  -- local on_references = vim.lsp.handlers["textDocument/references"]
  -- vim.lsp.handlers["textDocument/references"] = vim.lsp.with(
  --   on_references, {
  --     -- Use location list instead of quickfix list
  --     loclist = true,
  --   }
  -- )
  -- vim.lsp.handlers['textDocument/hover'] = function(_, result, ctx, config)
  --   config = config or {}
  --   config.focus_id = ctx.method
  -- if not (result and result.contents) then
  --   return
  -- end

  -- local icons = require("nvim-nonicons")
  -- ✘  i 󰌶

  vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'LspDiagnosticsSignError' })
  vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'LspDiagnosticsSignWarn' })
  vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'LspDiagnosticsSignInfo' }) -- 󰌵
  vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'LspDiagnosticsSignHint' })

  local keymap_opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap(
    'n',
    '<C-T>',
    "<cmd>lua require('telescope.run')('builtin', 'diagnostics', { bufnr = true })<cr>",
    keymap_opts
  )
  vim.api.nvim_set_keymap('n', '<M-T>', "<cmd>lua require('telescope.run')('builtin', 'diagnostics')<cr>", keymap_opts)
  vim.api.nvim_set_keymap('n', '<Leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', keymap_opts)
  vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', keymap_opts)
  vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', keymap_opts)
  vim.api.nvim_set_keymap('n', '<Leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', keymap_opts)

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
  capabilities.resolve(client, bufnr)
end

return on_attach
