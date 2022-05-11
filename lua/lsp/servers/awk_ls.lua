local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  lspconfig.awk_ls.setup {
    on_attach = on_attach,
    -- cmd = {"awk-language-server"},
    -- cmd = { path .. "/lsp_servers/dockerls/docker-langserver", "--stdio" },
    filetypes = { "awk" },
    single_file_support = true,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
