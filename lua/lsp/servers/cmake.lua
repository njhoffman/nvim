local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')

  lspconfig.cmake.setup {
    on_attach = on_attach,
    -- cmd = { path .. "/lsp_servers/dockerls/docker-langserver", "--stdio" },
    -- cmd = {"cmake-language-server"},
    -- filetypes = {"cmake"},
    init_options = {
      buildDirectory = "build"
    },
    single_file_support = true,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
    -- root_dir = function(dirname) {
    --   return util.root_pattern(".git", "compile_commands.json", "build") or dirname
    -- },
  }
end

return M
