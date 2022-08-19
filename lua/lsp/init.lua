vim.import("lsp.config", function(lspconfig)
  lspconfig.setup()
  vim.import("lsp.server")
end)
