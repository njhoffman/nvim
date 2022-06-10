local lspinstall = require("nvim-lsp-installer")
local on_attach = require("lsp.on_attach").on_attach
local make_config = require("lsp.on_attach").make_config


local servers = {
  "awk_ls",
  "bashls",
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



local M = {}
M.init = function()
  local config = make_config()
  for _, name in ipairs(servers) do
    local server_is_found, server = lspinstall.get_server(name)
    if server_is_found and not server:is_installed() then
      vim.notify("Installing " .. name, "info")
      server:install()
    end
  end
end

for _, server in ipairs(servers) do
  require("lsp.servers." .. server).setup(on_attach, capabilities)
end

return M
