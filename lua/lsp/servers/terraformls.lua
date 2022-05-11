local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  lspconfig.terraformls.setup {
    on_attach = on_attach,
    -- cmd = { path .. "/lsp_servers/dockerls/docker-langserver", "--stdio" },
    -- cmd = {"terraform-ls", "serve"},
    -- filetypes = {"terraform"},
    -- root_dir = util.root_pattern(".terraform", ".git"),
    single_file_support = true,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
