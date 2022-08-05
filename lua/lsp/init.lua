-- require("lsp.config")

-- h["$/progress"]                      = with(vim.lsp.handlers['$/progress'], lspnotify.progress_handler)
-- h["window/showMessage"]              = with(vim.lsp.handlers["window/showMessage"], lspnotify.message_handler)
-- h["textDocument/hover"]              = with(vim.lsp.handlers["textDocument/hover"], handlers.hover)
-- h["textDocument/signatureHelp"]      = with(vim.lsp.handlers["textDocument/signatureHelp"], { border = "rounded" })
-- h["textDocument/publishDiagnostics"] = with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)

require("lsp.config").setup()

local ok_fidget, fidget = pcall(require, "fidget")
if ok_fidget then
  fidget.setup({
    fmt = { stack_upwards = false }
  })
end


require("lsp.server").init()
