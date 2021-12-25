local lspconfig = require "lspconfig"
local lsp_cmds = require "lsp.commands"
local on_attach_hook = require "lsp.on_attach_hook"
local lsp_status = require("lsp-status")
local logger = require("logger").initLogger("bashls")

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)
logger:info('Extend bashls')

-- function to attach completion when setting up lsp
local on_attach = function(client, bufnr)
  logger:info('Attaching bashls ' .. bufnr)
  on_attach_hook.common_on_attach(client, bufnr)
end

lspconfig.bashls.setup {
  capabilities = capabilities,
  cmd = lsp_cmds.bash,
  cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
  root_dir = lspconfig.util.find_git_ancestor(),
  single_file_support = true,
  filetypes = { "sh", "bash", "zsh"},
  on_attach = on_attach,
}
