local null_ls = require("null-ls")
local builtins = null_ls.builtins
local on_attach_hook = require("lsp.on_attach_hook")
local lsp_status = require("lsp-status")

local on_attach = function(client, bufnr)
	local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities = vim.tbl_extend("keep", capabilities or {}, lsp_status.capabilities)

	if vim.bo.filetype == "Dockerfile" then
		return
		-- vim.g.null_ls_disable = true
		-- client.resolved_capabilities.document_formatting = false
	end
	-- if vim.bo.filetype == "lua" then client.resolved_capabilities.document_formatting = false end
	-- if vim.bo.filetype == "lua" then vim.g.null_ls_disable = true end
	-- if vim.bo.filetype == "html" then vim.g.null_ls_disable = true end
	-- if vim.bo.filetype == "javascript" then vim.g.null_ls_disable = true end

	on_attach_hook.common_on_attach(client, bufnr)
end

-- builtins.formatting.stylua.with({
--     condition = function(utils)
--         return utils.root_has_file("stylua.toml")
--     end,
-- }),
-- builtins.formatting.trim_whitespace.with({ filetypes = { "tmux", "teal", "zsh" } }),
-- builtins.formatting.shfmt,
-- builtins.diagnostics.write_good,
-- builtins.diagnostics.markdownlint,
-- builtins.diagnostics.teal,
-- builtins.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
-- builtins.code_actions.gitsigns,
-- builtins.formatting.prettierd.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
-- builtins.formatting.prettierd.with({ filetypes = { "markdown", "markdown.pandoc" } }),
-- builtins.formatting.stylua.with({
--   args = {
--     "--config-path",
--     vim.fn.stdpath("config") .. "/lua/stylua.toml",
--     "-",
--   },
-- }),
-- builtins.formatting.trim_whitespace.with({ filetypes = { "tmux", "fish", "teal" } }),
-- builtins.diagnostics.write_good,
-- builtins.diagnostics.markdownlint.with({
--   filetypes = { "markdown", "markdown.pandoc" },
--   args = { "--config", vim.fn.stdpath("config") .. "/lua/.markdownlint.jsonc", "--stdin" },
-- }),
--   builtins.diagnostics.teal,
--   builtins.code_actions.gitsigns,
-- }

-- local sources = {
--   builtins.formatting.shfmt.with({ filetypes = { "sh", "bash", "zsh" } }),
--   -- builtins.formatting.shfmt,
--   -- builtins.diagnostics.shellcheck
--   -- builtins.diagnostics.shellcheck.with({ filetypes = { "sh", "bash", "zsh" } }),
--   -- builtins.code_actions.gitsigns,
-- }
-- null_ls.config({ sources = sources })

local mysources = {
	builtins.diagnostics.eslint,
	builtins.diagnostics.shellcheck,
	builtins.formatting.prettier.with({ disabled_filetypes = { "Dockerfile" } }),
	builtins.formatting.sqlformat,
	builtins.formatting.shfmt,
	builtins.formatting.stylua,
	builtins.code_actions.gitsigns,
	-- null_ls.builtins.hover,
}

-- sources = { require("null-ls").builtins.formatting.stylua },
require("null-ls").config({
	sources = mysources,
	debug = false,

	disabled_filetypes = { "Dockerfile" },
	log = { enable = true, level = "warn", use_console = "async" },
})

require("lspconfig")["null-ls"].setup({ on_attach = on_attach })
