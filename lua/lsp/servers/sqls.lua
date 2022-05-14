local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  lspconfig.sqls.setup {
    on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.range_formatting = false
      on_attach(client, bufnr)
    end,
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
