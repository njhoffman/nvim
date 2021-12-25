-- ----------------------------------------------------------------------------
-- SQL Language Server configuration
--
-- Requires : npm install -g sql-language-server
--
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#sqlls
-- ----------------------------------------------------------------------------
local lspconfig = require "lspconfig"
local lsp_cmds = require("lsp.commands")
local on_attach_hook = require "lsp.on_attach_hook"

-- function to attach completion when setting up lsp
local on_attach = function(client, bufnr)
  -- require'completion'.on_attach(client)
  client.resolved_capabilities.execute_command = true
  on_attach_hook.common_on_attach(client, bufnr)
end

-- lspconfig.sqlls.setup {
--   cmd = lsp_cmds.sqlls,
--   filetypes = {"sql", "pgsql"},
--   on_attach = on_attach,
--   -- cmd = {"sql-language-server", "up", "--method", "stdio"};
-- }

require'lspconfig'.sqls.setup{
  on_attach = on_attach,
  settings = {
    sqls = {
      connections = {
        {
          driver = 'postgresql',
          dataSourceName = 'host=localhost port=5432 user=spadash password=spadash dbname=spadash_local sslmode=disable',
        },
      },
    },
  },
}
