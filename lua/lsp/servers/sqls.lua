local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  lspconfig.sqls.setup {
    on_attach = on_attach,
    -- cmd = { path .. "/lsp_servers/dockerls/docker-langserver", "--stdio" },
    -- filetypes = {"sql", "mysql", "pgsql", "psql"},
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
    settings = {
      format = { enable = false },
      sqls = {
        lowercaseKeywords = false,
        connections = {
          {
            driver = "postgresql",
            dataSourceName = "host=localhost port=5432 user=spadash password=spadash database=spadash sslmode=disable"
          }
        }
      }
    }
  }
end

return M
