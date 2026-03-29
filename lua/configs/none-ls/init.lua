-- https://github.com/nvimtools/none-ls.nvim/discussions/81
-- https://github.com/nvimtools/none-ls.nvim/commit/2236d2bf621b64ccbceebc452137b25ecc7f6228

-- [null-ls]  (code_actions/shellcheck.lua), which will be removed in March.
-- [null-ls]  (diagnostics/gospel.lua), which will be removed in March.
-- [null-ls]  (diagnostics/jsonlint.lua), which will be removed in March.
-- [null-ls]  (diagnostics/misspell.lua), which will be removed in March.
-- [null-ls]  (diagnostics/shellcheck.lua), which will be removed in March.
-- [null-ls]  (diagnostics/standardrb.lua), which will be removed in March.
-- [null-ls]  (formatting/beautysh.lua), which will be removed in March.
-- [null-ls]  (formatting/eslint_d.lua), which will be removed in March.
-- [null-ls]  (formatting/fixjson.lua), which will be removed in March.
-- [null-ls]  (formatting/jq.lua), which will be removed in March.
-- [null-ls]  (formatting/markdown_toc.lua), which will be removed in March.
-- [null-ls]  (formatting/rustfmt.lua), which will be removed in March.
-- [null-ls]  (formatting/standardrb.lua), which will be removed in March.
-- [null-ls]  (formatting/trim_newlines.lua), which will be removed in March.
-- [null-ls]  (formatting/xmlformat.lua), which will be removed in March.
-- [null-ls]  (formatting/xmllint.lua), which will be removed in March.
-- deleted:    diagnostics/gospel.lua
-- deleted:    diagnostics/jsonlint.lua       (use jsonls)
-- deleted:    diagnostics/misspell.lua
-- deleted:    diagnostics/shellcheck.lua     (use bashls / available in gbprod/none-ls-shellcheck.nvim)
-- deleted:    diagnostics/standardjs.lua     (use eslint-language-server)
-- deleted:    diagnostics/standardrb.lua     (use standardrb lsp)
-- deleted:    formatting/beautysh.lua        (use shfmt)
-- deleted:    formatting/eslint_d.lua        (use eslint-language-server)
-- deleted:    formatting/fixjson.lua         (use jsonls)
-- deleted:    formatting/jq.lua              (use jsonls)
-- deleted:    formatting/markdown_toc.lua    (use marksman)
-- deleted:    formatting/standardrb.lua      (use standardrb lsp)
-- deleted:    formatting/trim_newlines.lua   (use editorconfig)
-- deleted:    formatting/xmlformat.lua       (use lemminx)
-- deleted:    formatting/xmllint.lua         (use lemminx)
vim.g.nonels_supress_issue58 = true

local u = require("null-ls.utils")
local null_ls = require("null-ls")

-- autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
-- vim.fn.input()
local custom_sources = require("configs.none-ls.custom")
local source_categories = {
  require("configs.none-ls.codeactions"),
  require("configs.none-ls.formatting"),
  require("configs.none-ls.diagnostics"),
  custom_sources.formatting,
  custom_sources.diagnostics,
  custom_sources.codeactions,
}

local sources = {}
for _, src in ipairs(source_categories) do
  for _, v in ipairs(src) do
    table.insert(sources, v)
  end
end

local supports_method_for_filetype = function(filetype, method)
  local null_sources = require("null-ls.sources")
  local available = null_sources.get_available(filetype, method)
  return #available > 0
end

local map_buf = function(bufnr, lhs, rhs)
  require("mapper").map("n", lhs, rhs, { buffer = bufnr })
end

-- local handlers = require('lsp.handlers')
-- local on_attach = function(client, bufnr)
--   local filetype = vim.bo.filetype
--   if supports_method_for_filetype(filetype, 'NULL_LS_FORMATTING') then
--     -- require('lsp.format').on_attach(client)
--     -- handlers.documentFormattingProvider('null-ls', bufnr)
--     -- map_buf(bufnr, "gQ", lsp_document_format("null-ls"))
--     -- format_on_save(bufnr, "null-ls")
--     -- attach.keybindings_formatting(bufnr, "null-ls")
--   end

--   if supports_method_for_filetype(filetype, 'NULL_LS_CODE_ACTION') then
--     map_buf(bufnr, 'cxa', vim.lsp.buf.code_action)
--     -- attach.keybindings_codeaction(bufnr)
--   end
-- end

local exclude_ft = {
  "TelescopePrompt",
  "alpha",
  "dap.*",
  "dashboard",
  "help",
  "mason",
  "neo-tree",
  "noice",
  "notify",
  "oil",
  "packer",
  "qf",
  "spectre_panel",
  "startify",
  "tablegen",
  "tsplayground",
}

-- null_ls.setup({
--   border = 'rounded',
--   cmd = { 'nvim' },
--   log_level = 'info',
--   update_in_insert = false,
--   sources = sources,
--   fallback_severity = vim.diagnostic.severity.INFO,
--   on_init = function(new_client, _)
--     if vim.tbl_contains({ 'h', 'cpp', 'c' }, vim.o.ft) then
--       new_client.offset_encoding = 'utf-16' -- , "utf-32" for ccls
--     end
--   end,
--   diagnostic_config = { underline = false },
--   -- on_attach = on_attach,
--   debounce = 2000,
--   default_timeout = 5000,
--   root_dir = u.root_pattern(
--     '.null-ls-root',
--     'Makefile',
--     '.git',
--     'go.mod',
--     'package.json',
--     'requirements.txt',
--     'tsconfig.json'
--   ),
--   should_attach = function(bufnr)
--     local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
--     if not vim.tbl_contains(exclude_ft, ft) and ft ~= '' then
--       return true
--     end
--     -- local large_file = require('large_file')
--     -- return not large_file.is_large_file(bufnr)
--   end,
-- })
