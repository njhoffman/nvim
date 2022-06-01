local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  lspconfig.sqls.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/sqls/sqls" }, -- "-config", "path/to/config.yml"}
    filetypes = { "sql", "mysql", "pgsql", "psql" },
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
    settings = {
      format = { enable = false },
    }
  }
end

return M
