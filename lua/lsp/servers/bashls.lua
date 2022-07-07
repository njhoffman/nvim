local M = {}
M.setup = function(on_attach, capabilities)
  local lspconfig = require "lspconfig"
  local path = vim.fn.stdpath('data')
  vim.dbglog({ capabilities })
  lspconfig.bashls.setup {
    cmd = { path .. "/lsp_servers/bash/node_modules/.bin/bash-language-server", "start" },
    cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
    root_dir = lspconfig.util.find_git_ancestor,
    single_file_support = true,
    filetypes = { "sh", "bash", "bats", "zsh" },
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = capabilities,
  }
end

return M
