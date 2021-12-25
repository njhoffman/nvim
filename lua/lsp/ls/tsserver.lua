local lspconfig = require("lspconfig")
local lsp_cmds = require("lsp.commands")
local on_attach_hook = require("lsp.on_attach_hook")
local lsp_status = require("lsp-status")

local ts_utils_settings = {
	-- debug = true,
	complete_parens = true,
	enable_formatting = false,
	enable_import_on_completion = true,
	eslint_bin = "eslint_d",
	eslint_disable_if_no_config = true,
	eslint_enable_code_actions = true,
	eslint_enable_diagnostics = true,
	eslint_show_rule_id = true,
	filter_out_diagnostics_by_code = { 80001 }, --   -- defaults
	formatter = "eslint_d",
	import_all_scan_buffers = 100,
	signature_help_in_parens = true,
	update_imports_on_move = true,
	--   debug = false,
	--   disable_commands = false,
	--   enable_import_on_completion = true,
	--   import_on_completion_timeout = 5000,
	--   -- eslint
	--   -- eslint_bin = "eslint",
	--   eslint_bin = "eslint_d",
	--   eslint_args = { "-f", "json", "--stdin", "--stdin-filename", "$FILENAME" },
	--   eslint_enable_disable_comments = true,
	--   -- experimental settings!
	--   -- eslint diagnostics
	--   eslint_enable_diagnostics = true,
	--   eslint_diagnostics_debounce = 250,
	--   -- formatting
	--   enable_formatting = true,
	--   -- prettier, prettierd, prettier_d_slim, or eslint_d.
	--   formatter = "prettier",
	--   formatter_args = { "--stdin-filepath", "$FILENAME" },
	--   format_on_save = true,
	--   formatter_config_fallback = "eslint_d",
	--   no_save_after_format = false,
	--   -- parentheses completion
	--   complete_parens = false,
	--   -- update imports on file move
	--   update_imports_on_move = true,
	--   require_confirmation_on_move = false,
	--   -- watch_dir = "/src"
	--   watch_dir = "/",
}

-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)

-- javascript, javascriptreact, javascript.jsx, typescript, typescriptreact, typescript.tsx

local on_attach = function(client, bufnr)
	-- disable tsserver formatting if you plan on formatting via null-ls

	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false

	local lspTsUtils = require("nvim-lsp-ts-utils")
	lspTsUtils.setup(ts_utils_settings)
	lspTsUtils.setup_client(client)
	-- u.buf_map("n", "gs", ":TSLspOrganize<CR>", nil, bufnr)
	--           u.buf_map("n", "gI", ":TSLspRenameFile<CR>", nil, bufnr)
	--           u.buf_map("n", "go", ":TSLspImportAll<CR>", nil, bufnr)
	--           u.buf_map("n", "qq", ":TSLspFixCurrent<CR>", nil, bufnr)
	--           u.buf_map("i", ".", ".<C-x><C-o>", nil, bufnr)
	-- vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
	-- on_attach_hook.common_on_attach(client, bufnr)
end

lspconfig.tsserver.setup({
	-- autostart = LSP.tsserver
	capabilities = capabilities,
	cmd = lsp_cmds.tsserver,
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	on_attach = on_attach,
  -- root_dir = root_pattern('package.json', 'node_modules', '.git') or dirname
})
