local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.clangd.setup {
    on_attach = on_attach,
    -- cmd = { path .. "/lsp_servers/dockerls/docker-langserver", "--stdio" },
    -- {filetypes = {"c", "cpp", "cc"}
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
