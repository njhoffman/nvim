local lspconfig = require "lspconfig"
local lsp_cmds = require("lsp.commands")
local on_attach_hook = require("lsp.on_attach_hook")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- function to attach completion when setting up lsp
local on_attach = function(client, bufnr)
  -- vim.cmd [[autocmd BufWritePre *.go lua require'lsp.formatters'.format()]]
  on_attach_hook.common_on_attach(client, bufnr)
end

lspconfig.gopls.setup {
  cmd = lsp_cmds.go,
  filetypes = { "go", "gomod" },
  root_dir = function(fname)
    return lspconfig.util.root_pattern(".git")(fname) or lspconfig.util.root_pattern("go.mod")(fname) or
               lspconfig.util.path.dirname(fname)
  end,
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      analyses = { unusedparams = true, shadow = true },
      staticcheck = true,
    },
  },
  on_attach = on_attach,
}
