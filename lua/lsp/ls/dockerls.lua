-- ----------------------------------------------------------------------------
-- Dockerfile Language Server
--
-- Requires: npm install -g dockerfile-language-server-nodejs
--
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#dockerls
-- ----------------------------------------------------------------------------
--
local lspconfig = require("lspconfig")
local lsp_cmds = require("lsp.commands")
local on_attach_hook = require("lsp.on_attach_hook")
local lsp_status = require("plugins.configs.lsp-status")

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)

-- function to attach completion when setting up lsp
local on_attach = function(client, bufnr)
	on_attach_hook.common_on_attach(client, bufnr)
end

lspconfig.dockerls.setup({
	capabilities = capabilities,
	cmd = lsp_cmds.dockerls,
	filetypes = { "Dockerfile" },
	on_attach = on_attach,
  root_dir = lspconfig.utils.root_pattern("Dockerfile"),
  single_file_support = true
})
