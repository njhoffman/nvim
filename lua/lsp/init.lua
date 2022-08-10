-- require("lsp.config")

-- h["$/progress"]                      = with(vim.lsp.handlers['$/progress'], lspnotify.progress_handler)
-- h["window/showMessage"]              = with(vim.lsp.handlers["window/showMessage"], lspnotify.message_handler)
-- h["textDocument/hover"]              = with(vim.lsp.handlers["textDocument/hover"], handlers.hover)
-- h["textDocument/signatureHelp"]      = with(vim.lsp.handlers["textDocument/signatureHelp"], { border = "rounded" })
-- h["textDocument/publishDiagnostics"] = with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)
vim.import("lsp.config", function(lspconfig)
  vim.import('fidget', function(fidget)
    vim.import("lsp.server", function(lspserver)
      lspconfig.setup()
      fidget.setup({
        fmt = { stack_upwards = false }
      })
      lspserver.init()
    end)
  end)
end)
