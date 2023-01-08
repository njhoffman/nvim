local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath("data")

  lspconfig.golangci_lint_ls.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/golangci_lint_ls/golangci-lint-langserver" },
    filetypes = { "go", "gomod" },
    init_options = {
      command = { path .. "/lsp_servers/golangci_lint_ls/golangci-lint", "run", "--out-format", "json" }
    },
    -- root_dir = util.root_pattern("go.work") or util.root_pattern("go.mod", ".golangci.yaml", ".git"),
    single_file_support = true,
    flags = {
      debounce_text_changes = 150
    },
    capabilities = capabilities
  }
end

return M
