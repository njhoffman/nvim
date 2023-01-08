local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.graphql.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/graphql/node_modules/.bin/graphql-lsp", "server", "-m", "stream" },
    filetypes = { "graphql", "typescriptreact", "javascriptreact" },
    -- root_dir = util.root_pattern(".git", ".graphqlrc*", ".graphql.config.*"),
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
