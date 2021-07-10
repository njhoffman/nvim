local lspconfig = require "lspconfig"
local lsp_cmds = require "lsp.commands"
local on_attach_hook = require "lsp.on_attach_hook"
local lsp_status = require("lsp-status")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)

-- function to attach completion when setting up lsp
local on_attach = function(client, bufnr)
  -- require'completion'.on_attach(client)
  client.resolved_capabilities.document_formatting = false
  on_attach_hook.common_on_attach(client, bufnr)
  print("'" .. client.name .. "' server attached")
end

lspconfig.bashls.setup {
  capabilities = capabilities,
  cmd = lsp_cmds.bash,
  cmd_env = { GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)" },
  --   root_dir = function(fname)
  --   return lspconfig.util.root_pattern(".git")(fname) or
  --              lspconfig.util.path.dirname(fname)
  -- end,
  filetypes = { "sh", "bash", "conf", "zsh" },
  on_attach = on_attach,
}
