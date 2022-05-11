local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')


  lspconfig.yamlls.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/yaml/node_modules/.bin/yaml-language-server", "--stdio" },
    -- filetypes = {"yaml", "yaml.docker-compose"},
    -- settings = {redhat = {telemetry = {enabled = false}}},
    -- root_dir = lspconfig.util.find_git_ancestor
    single_file_support = true,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
