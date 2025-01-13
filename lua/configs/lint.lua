-- Everything in opts will be passed to setup()
local linterConfig = vim.fn.stdpath("config") .. ".linter_configs"

local lint = require("lint")
local linters = require("lint").linters

-- stylua: ignore
lint.linters_by_ft = {
	lua        = { "stylua" },
	css        = { "stylelint" },
	sh         = { "shellcheck" },
	markdown   = { "markdownlint" },
	yaml       = { "yamllint" },
	python     = { "pylint" },
	gitcommit  = {},
	json       = {},
	javascript = {},
	typescript = {},
	toml       = {},
	text       = {},
}

-- for ft, _ in pairs(lint.linters_by_ft) do
--  -- use for codespell for all except bib and css
-- 	if ft ~= "bib" and ft ~= "css" then table.insert(lint.linters_by_ft[ft], "codespell") end
-- end

-- linters.codespell.args = {
-- 	"--ignore-words",
-- 	linterConfig .. "/codespell-ignore.txt",
-- 	"--builtin=rare,clear,informal,code,names,en-GB_to_en-US",
-- }

linters.shellcheck.args = {
	"--shell=bash", -- force to work with zsh
	"--format=json",
	"-",
}

linters.yamllint.args = {
	"--config-file",
	linterConfig .. "/yamllint.yaml",
	"--format=parsable",
	"-",
}

linters.markdownlint.args = {
	"--disable=no-trailing-spaces", -- not disabled in config, so it's enabled for formatting
	"--disable=no-multiple-blanks",
	"--config=" .. linterConfig .. "/markdownlint.yaml",
}

local function run_linter()
	-- due to auto-save.nvim, we need the custom event "AutoSaveWritePost"
	-- instead of "BufWritePost" to trigger linting to prevent race conditions
	vim.api.nvim_create_autocmd("User", {
		pattern = "AutoSaveWritePost",
		callback = function() require("lint").try_lint() end,
	})

	-- Use nvim-lint's logic first:
	-- * checks if linters exist for the full filetype first
	-- * otherwise will split filetype by "." and add all those linters
	-- * this differs from conform.nvim which only uses the first filetype that has a formatter
	local names = lint._resolve_linter_by_ft(vim.bo.filetype)

	-- Create a copy of the names table to avoid modifying the original.
	names = vim.list_extend({}, names)

	-- Add fallback linters.
	if #names == 0 then vim.list_extend(names, lint.linters_by_ft["_"] or {}) end

	-- Add global linters.
	vim.list_extend(names, lint.linters_by_ft["*"] or {})

	-- Filter out linters that don't exist or don't match the condition.
	local ctx = { filename = vim.api.nvim_buf_get_name(0) }
	ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")

	names = vim.tbl_filter(function(name)
		local linter = lint.linters[name]
		if not linter then vim.notify("Linter not found: " .. name, { title = "nvim-lint" }) end
		return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
	end, names)

	-- Run linters.
	if #names > 0 then lint.try_lint(names) end
end

local function debounce(ms, fn)
	local timer = vim.uv.new_timer()
	return function(...)
		local argv = { ... }
		timer:start(ms, 0, function()
			timer:stop()
			vim.schedule_wrap(fn)(unpack(argv))
		end)
	end
end

local events = { "BufWritePost", "BufReadPost", "InsertLeave" }
vim.api.nvim_create_autocmd(events, {
	group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
	callback = debounce(100, run_linter),
})
