local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.html.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/html/node_modules/.bin/vscode-html-language-server", "--stdio" },
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
