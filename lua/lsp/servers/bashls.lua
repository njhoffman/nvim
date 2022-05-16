local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  lspconfig.bashls.setup {
    cmd = { path .. "/lsp_servers/bash/node_modules/.bin/bash-language-server", "start" },
    root_dir = lspconfig.util.find_git_ancestor,
    filetypes = { "sh", "bash", "bats" },
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
