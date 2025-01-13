local linterConfig = vim.fn.stdpath("config") .. ".linter_configs"

-- function config.get_lsp_fallback(bufnr)
--   local formatters = require("conform").list_formatters(bufnr)
--   if #formatters > 0 and formatters[1].name == "trim_whitespace" then
--     return "always"
--   else
--     return true

--   end
-- end

-- code_action = { "eslint_d", "gitrebase", "refactoring" },

local eslint = "eslint_d" -- "eslint"
local prettier = "prettierd" -- prettier

-- stylua: ignore
local formatters_by_ft = {
	-- Use the "*" filetype to run formatters on all filetypes.
	-- Use the "_" filetype to run formatters on filetypes that don't
	-- ["*"]        = { "codespell" },
	asm             = { "asmfmt" },
	-- bash            = { "shfmt", "shellharden" },
  bash = {"shfmt"},
	zsh             = { "shfmt" },
	bzl             = { "buildifier" },
	c               = { "uncrustify", "clang_format" },
	cpp             = { "clang_format" },
	css             = { prettier },
	cuda            = { "clang_format" },
	fish            = { "fish_indent" },
	go              = { "goimports", "gofmt", "gofumpt" },
	graphql         = { prettier },
	handlebars      = { prettier },
	html            = { prettier },
	htmlangular     = { prettier },
	javascript      = { eslint, prettier },
	javascriptreact = { eslint },
	json            = { "jq", prettier },
	jsonc           = { "jq", prettier },
	just            = { "just" },
	lua             = { "stylua" },
	markdown        = { "cbfmt", "markdownlint" },
	nasm            = { "asmfmt" },
	nix             = { "nixpkgs_fmt" },
	proto           = { "buf", "protolint" },
	rust            = { "rustfmt" },
	scss            = { prettier },
  sh = {"shfmt"},
	-- sh              = { "shfmt", "shellharden" },
	sql             = { "sql-formatter" },
	toml            = { "taplo", prettier },
	tsx             = { prettier },
	typescript      = { eslint, prettier },
	typescriptreact = { eslint, prettier },
	vue             = { eslint },
	-- ["_"]        = { "trim_whitespace" },
}

local formatters = {
	beautysh = { command = "beautysh", stdin = false, args = { "--indent-size", "2" } },
	cbfmt = {
		prepend_args = { "--config", os.getenv("HOME") .. "/.config/cbfmt/cbfmt.toml" },
	},
	flake8 = {
		command = "flake8",
		stdin = false,
		args = { "--ignore=E203,E501,E402,F401,F821,W503,W292" },
	},
	markdownlint = {
		command = "markdownlint",
		stdin = false,
		args = { "--fix", "--config", linterConfig .. "/markdownlint.yaml", "$FILENAME" },
	},
	shellcheck = {
		command = "shellcheck",
		arg = "--shell=bash --format=diff '$FILENAME' | git apply",
		-- arg = "--shell=bash",
		stdin = false,
	},
	rustfmt = {
		meta = {
			url = "https://github.com/rust-lang/rustfmt",
			description = "A tool for formatting rust code according to style guidelines.",
		},
		command = "rustfmt",
		args = { "--emit=stdout", "--edition=2021" },
	},
	shfmt = { args = { "-i", "2", "-bn", "-ci", "-sr", "-kp" } },
	uncrustify = {
		meta = {
			url = "https://github.com/uncrustify/uncrustify",
			description = "A source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and Vala.",
		},
		command = "uncrustify",
		args = function(self, ctx)
			return {
				"-q",
				"-l",
				vim.bo[ctx.buf].filetype:upper(),
				"-c",
				vim.uv.cwd() .. "/src/uncrustify.cfg",
			}
		end,
	},
}

local cfg = {
	log_level = vim.log.levels.DEBUG,
	default_format_opts = {
		timeout_ms = 3000,
		async = false, -- not recommended to change
		quiet = false, -- not recommended to change
		lsp_format = "fallback", -- not recommended to change
	},
	-- notify_on_error = true, -- Custom formatters and overrides for built-in formatters },
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
		return { lsp_fallback = true }
	end,
	format_after_save = { lsp_fallback = true },
	formatters_by_ft = formatters_by_ft,
	formatters = formatters,
}

if vim.g.started_by_firenvim then
	cfg.format_on_save = false
	cfg.format_after_save = false
end
require("conform").setup(cfg)

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format { async = true, lsp_fallback = true, range = range }
end, { range = true })

-- local event = 'BufWritePost'
-- if format_options.sync then
--   event = 'BufWritePre'
-- end
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function(args)
--     -- vim.dbglog("format", args.buf)
--     require("conform").format({ bufnr = args.buf })
--   end,
-- })
-- null_ls.builtins.formatting.stylua.with({
--   _config_file = get_config_file(root_files.stylua),
--   filetypes = { 'lua' },
--   condition = function()
--     if vim.bo.filetype ~= 'lua' then
--       return false
--     end
--     local config_file = get_config_file(root_files.stylua)
--     return vim.fn.executable('stylua') > 0 and config_file
--   end,
--   -- -- cwd = h.cache.by_bufnr(function(params)
--   -- --   local util = require "lspconfig/util"
--   -- --   return stylua_found
--   -- -- end),
--   -- -- params.bufnr, client_id, command, content, cwd, lsp_method, method, options, root
--   extra_args = function(params)
--     local local_config = get_config_file(root_files.stylua)
--     local bufnr = params.bufnr or 0
--     local column_width = vim.api.nvim_buf_get_option(bufnr, 'textwidth')
--     column_width = column_width > 0 and column_width or 100
--     local args = {
--       '--call-parentheses',
--       'Always',
--       '--collapse-simple-statement',
--       'Never',
--       '--quote-style',
--       'AutoPreferSingle',
--       '--column-width',
--       column_width,
--       '--indent-width',
--       vim.api.nvim_buf_get_option(bufnr, 'shiftwidth'),
--     }
--     if local_config ~= nil then
--       table.insert(args, '--config-path')
--       table.insert(args, local_config)
--     end
--     return args
--     -- sources.root, sources.cwd
--     -- editorconfig generator.opts._last_args, _last_command, _last_cwd
--     -- local sources = require("null-ls.sources")
--     -- local lua_src = sources.get_available('lua')
--   end,
-- }),
