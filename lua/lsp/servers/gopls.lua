local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.gopls.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/go/gopls", "--stdio" },
    filetypes = { "go", "gomod" },
    single_file_support = true,
    -- root_dir = util.root_pattern("go.mod", ".git"),
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
