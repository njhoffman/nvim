local servers = {
  "awk_ls",
  -- "bashls",
  "clangd",
  "cssls",
  "dockerls",
  "efm",
  "golangci_lint_ls",
  "gopls",
  "graphql",
  "html",
  "jsonls",
  "pylsp",
  "sqls",
  "sumneko_lua",
  "terraformls",
  "tsserver",
  "vimls",
  "yamlls"
  -- "null-ls",
}

for _, server_name in ipairs(servers) do
  local server = require("lsp.servers." .. server_name)
  local lsp = require('lsp.on_attach')
  server.setup(lsp.on_attach, lsp.make_capabilities())
end
