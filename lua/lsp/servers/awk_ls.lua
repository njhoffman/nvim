local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  lspconfig.awk_ls.setup {
    root_dir = lspconfig.util.find_git_ancestor,
    cmd = { path .. "/lsp_servers/awk_ls/node_modules/.bin/awk-language-server" },
    filetypes = { "awk" },
    on_attach = on_attach,
    single_file_support = true,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
