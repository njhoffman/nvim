local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.vimls.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/vim/node_modules/.bin/vim-language-server", "--stdio" },
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
