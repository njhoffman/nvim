local lspconfig = require("lspconfig")
local lsp_cmds = require("lsp.commands")
local on_attach_hook = require("lsp.on_attach_hook")
local lsp_status = require("lsp-status")

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)

-- function to attach completion when setting up lsp
local on_attach = function(client, bufnr)
	on_attach_hook.common_on_attach(client, bufnr)
end

lspconfig.gopls.setup({
	cmd = lsp_cmds.go,
	filetypes = { "go", "gomod" },
  -- root_dir = lspconfig.util.root_pattern(".project", "go.mod", ".git") or dirname
  root_dir = lspconfig.util.find_git_ancestor,
	-- root_dir = function(fname)
    -- or lspconfig.util.root_pattern(".project", vim.fn.getcwd())
	-- 	return lspconfig.util.root_pattern(".git", "go.mod", ".project", fname)
	-- end,
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = { unusedparams = true, shadow = true },
			staticcheck = true,
		},
	},
	on_attach = on_attach,
})
