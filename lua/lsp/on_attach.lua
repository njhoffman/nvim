local handlers = require("lsp.handlers")
local M = {}

M.on_attach = function(client, bufnr)
  handlers.attach_formatting(client, bufnr)
  handlers.attach_signature(client, bufnr)
  handlers.attach_keymaps(client, bufnr)

  -- vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

  if client.name == "tailwindcss" then
    if client.server_capabilities.colorProvider then
      require("lsp.servers.tailwind-colorizer").buf_attach(bufnr)
    end
    client.server_capabilities.textDocument.completion.completionItem.snippetSupport = true
    client.server_capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  end
end

M.make_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local cmp_ok, cmp = pcall(require, "cmp_nvim_lsp")
  if cmp_ok then
    cmp.default_capabilities(capabilities)
  else
    vim.notify({ "Completion error with CMP", cmp }, "error")
  end
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.colorProvider = { dynamicRegistration = false }
  return capabilities
end

return M
