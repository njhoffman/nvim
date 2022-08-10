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

local M = {}
M.init = function()
  vim.import('nvim-lsp-installer', function(lspinstall)
    for _, name in ipairs(servers) do
      local server_is_found, server = lspinstall.get_server(name)
      if server_is_found and not server:is_installed() then
        vim.notify("Installing " .. name, "info")
        server:install()
      end
    end
  end)
end

for _, server in ipairs(servers) do
  vim.import("lsp.servers." .. server, function(server)
    vim.import('lsp.on_attach', function(lsp)
      server.setup(lsp.on_attach, lsp.make_capabilities())
    end)
  end)
end

return M
