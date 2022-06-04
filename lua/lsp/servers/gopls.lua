local M = {}

M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath("data")

  lspconfig.gopls.setup {
    on_attach = on_attach,
    cmd = { path .. "/lsp_servers/go/gopls" },
    filetypes = { "go", "gomod" },
    single_file_support = true,
    -- root_dir = util.root_pattern("go.mod", ".git"),
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150
    },
    settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    },
    init_options = {
      usePlaceholders = true,
    }
  }
end

return M
