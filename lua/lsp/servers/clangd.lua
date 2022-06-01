local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  local path = vim.fn.stdpath('data')
  lspconfig.clangd.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/clangd/clangd/bin/clangd" },
    filetypes = { "c", "cpp", "cc" },
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
